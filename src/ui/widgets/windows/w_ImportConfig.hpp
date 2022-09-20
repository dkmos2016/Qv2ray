#pragma once

#include "ui/widgets/common/WidgetUIBase.hpp"
#include "ui_w_ImportConfig.h"

class ImportConfigWindow
    : public QvDialog
    , private Ui::ImportConfigWindow
{
    Q_OBJECT

  public:
    explicit ImportConfigWindow(QWidget *parent = nullptr);
    ~ImportConfigWindow();
    int PerformImportConnection();
    QMultiMap<QString, CONFIGROOT> SelectConnection(bool outboundsOnly);

    // VMESS Q_DECL_ENUMERATOR_DEPRECATED_X("VMess") = 0,     //
    // VLESS Q_DECL_ENUMERATOR_DEPRECATED_X("VLESS") = 1,     //
    // SSR Q_DECL_ENUMERATOR_DEPRECATED_X("Shadowsocks") = 2, //
    // HTTP Q_DECL_ENUMERATOR_DEPRECATED_X("HTTP"),           //
    // SOCKS Q_DECL_ENUMERATOR_DEPRECATED_X("SOCKS"),         //
    // FREEDOM Q_DECL_ENUMERATOR_DEPRECATED_X("Freedom"),     //
    // BLACKHOLE Q_DECL_ENUMERATOR_DEPRECATED_X("Blackhole"), //
    // DNS Q_DECL_ENUMERATOR_DEPRECATED_X("DNS"),             //
    // LOOPBACK Q_DECL_ENUMERATOR_DEPRECATED_X("Loopback"),   //
    enum ConnectionTypeEnum
    {
        VMESS,
        VLESS,
        SS,
        SSR,
        HTTP,
        SOCKS,
        FREEDOM,
        BLACKHOLE,
        DNS,
        LOOPBACK
    };

    QList<ConnectionTypeEnum> getAllConnectionType();
    QString getConnectionTypeString(uint type);

    void processCommands(QString command, QStringList commands, QMap<QString, QString> args) override
    {
#if QV2RAY_FEATURE(ui_has_import_qrcode)
        const static QMap<QString, int> indexMap{ { "link", 0 }, { "qr", 1 }, { "advanced", 2 } };
#else
        const static QMap<QString, int> indexMap{ { "link", 0 }, { "advanced", 1 } };
#endif
        nameTxt->setText(args["name"]);
        if (commands.isEmpty())
            return;
        if (command == "open")
        {
            const auto c = commands.takeFirst();
            tabWidget->setCurrentIndex(indexMap[c]);
        }
    }

  private:
    QvMessageBusSlotDecl override;

  private slots:
#if QV2RAY_FEATURE(ui_has_import_qrcode)
    void on_qrFromScreenBtn_clicked();
    void on_selectImageBtn_clicked();
    void on_hideQv2rayCB_stateChanged(int arg1);
#endif
    void on_errorsList_currentItemChanged(QListWidgetItem *current, QListWidgetItem *previous);
    void on_beginImportBtn_clicked();
    void on_cancelImportBtn_clicked();
    void on_routeEditBtn_clicked();
    void on_jsonEditBtn_clicked();
    void on_selectFileBtn_clicked();

  private:
    void updateColorScheme() override;
    QMap<QString, QString> linkErrors;
    //
    // Use hash here since the order is not important.
    QHash<GroupId, QMultiMap<QString, CONFIGROOT>> connectionsToExistingGroup;
    QMap<QString, QMultiMap<QString, CONFIGROOT>> connectionsToNewGroup;

    // 根据不同type进行不同操作
    void on_beginImportBtn_clicked_link_type_choice();
    void on_beginImportBtn_clicked_link_type_choice_v2ray();
    void on_beginImportBtn_clicked_link_type_choice_ssr();
};
