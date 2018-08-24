import UIKit
import SectionsTableViewKit
import GrouviExtensions
import SnapKit

class FullTransactionInfoController: UIViewController, SectionsDataSource {
    var transaction: TransactionRecordViewItem

    var tableView = SectionsTableView(style: .grouped)

    init(transaction: TransactionRecordViewItem) {
        self.transaction = transaction

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppTheme.controllerBackground

        title = "full_transaction_info.navigation_bar.title".localized

        view.addSubview(tableView)
        tableView.separatorInset.left = 0
        tableView.separatorColor = FullTransactionInfoTheme.separatorColor
        tableView.registerCell(forClass: FullTransactionInfoTextCell.self)
        tableView.backgroundColor = .clear
        tableView.sectionDataSource = self
        tableView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        let blurEffect = UIBlurEffect(style: AppTheme.blurStyle)
        let bottomBar = UIVisualEffectView(effect: blurEffect)
        view.addSubview(bottomBar)
        bottomBar.snp.makeConstraints { maker in
            maker.leading.bottom.trailing.equalToSuperview()
            maker.height.equalTo(FullTransactionInfoTheme.bottomBarHeight + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0))
        }

        let shareIcon: TintImageView = TintImageView(image: UIImage(named: "Share Full Transaction Icon"), tintColor: FullTransactionInfoTheme.bottomBarTintColor, selectedTintColor: FullTransactionInfoTheme.bottomHighlightBarTintColor)
        let shareButton = RespondView()
        shareButton.handleTouch = { [weak self] in
            self?.share()
        }
        shareButton.delegate = shareIcon
        shareButton.addSubview(shareIcon)
        shareIcon.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(self.tableView.layoutMargins.left * 2)
            maker.top.equalToSuperview().offset(FullTransactionInfoTheme.mediumMargin)
            maker.trailing.equalToSuperview()
        }
        bottomBar.contentView.addSubview(shareButton)
        shareButton.snp.makeConstraints { maker in
            maker.leading.top.bottom.equalToSuperview()
        }

        let closeIcon: TintImageView = TintImageView(image: UIImage(named: "Close Full Transaction Icon"), tintColor: FullTransactionInfoTheme.bottomBarTintColor, selectedTintColor: FullTransactionInfoTheme.bottomHighlightBarTintColor)
        let closeButton = RespondView()
        closeButton.handleTouch = { [weak self] in
            self?.close()
        }
        closeButton.delegate = closeIcon
        closeButton.addSubview(closeIcon)
        closeIcon.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().offset(-self.tableView.layoutMargins.left * 2)
            maker.top.equalToSuperview().offset(FullTransactionInfoTheme.mediumMargin)
            maker.leading.equalToSuperview()
        }
        bottomBar.contentView.addSubview(closeButton)
        closeButton.snp.makeConstraints { maker in
            maker.trailing.top.bottom.equalToSuperview()
        }

        tableView.reload()
    }

    func buildSections() -> [SectionProtocol] {
        var rows = [RowProtocol]()

        rows.append(Row<FullTransactionInfoTextCell>(id: "size", hash: "size", height: FullTransactionInfoTheme.cellHeight, bind: { cell, _ in
            //stab
            cell.bind(title: "full_transaction_info.cell.size".localized, description: "254 bytes")
        }))
        rows.append(Row<FullTransactionInfoTextCell>(id: "fee_rate", hash: "fee_rate", height: FullTransactionInfoTheme.cellHeight, bind: { cell, _ in
            //stab
            cell.bind(title: "full_transaction_info.cell.fee_rate".localized, description: "0.000000000004 BTC per kB")
        }))
        let timeString = DateHelper.instance.formatTransactionInfoTime(from: transaction.date)
        rows.append(Row<FullTransactionInfoTextCell>(id: "received_time", hash: "received_time", height: FullTransactionInfoTheme.cellHeight, bind: { cell, _ in
            //stab received date instead of date?
            cell.bind(title: "full_transaction_info.cell.received_time".localized, description: timeString)
        }))
        rows.append(Row<FullTransactionInfoTextCell>(id: "mined_time", hash: "mined_time", height: FullTransactionInfoTheme.cellHeight, bind: { cell, _ in
            cell.bind(title: "full_transaction_info.cell.mined_time".localized, description: "N/A")
        }))
        rows.append(Row<FullTransactionInfoTextCell>(id: "included_in_block", hash: "included_in_block", height: FullTransactionInfoTheme.cellHeight, bind: { [weak self] cell, _ in
            let confirmedString = (self?.transaction.confirmations ?? 0) > 0 ? "full_transaction_info.cell.included_in_block.confirmed".localized : "full_transaction_info.cell.included_in_block.unconfirmed".localized
            cell.bind(title: "full_transaction_info.cell.included_in_block".localized, description: confirmedString)
        }))
        rows.append(Row<FullTransactionInfoTextCell>(id: "lock_time", hash: "lock_time", height: FullTransactionInfoTheme.cellHeight, bind: { cell, _ in
            //stab
            cell.bind(title: "full_transaction_info.cell.lock_time".localized, description: "#420858")
        }))
        rows.append(Row<FullTransactionInfoTextCell>(id: "from", hash: "from", height: FullTransactionInfoTheme.cellHeight, bind: { cell, _ in
            //stab
            cell.bind(title: "full_transaction_info.cell.from".localized, description: "54NJ3D4S46KB6543JK3F8DS6J5K43FB4D32JS524LK4F3J4K3")
        }))
        for (index, address) in  ["3K4J3F4KL425SJ23D4BF34K5J6SD8F3KJ3456BK64S4D3JN45", "KJ3456BK64S4D3JN453K4J3F4KL425SJ23D4BF34K5J6SD8F3"].enumerated() {
            rows.append(Row<FullTransactionInfoTextCell>(id: "to\(index)", hash: "to\(index)", height: FullTransactionInfoTheme.cellHeight, bind: { cell, _ in
                //stab
                cell.bind(title: "full_transaction_info.cell.to".localized, description: address)
            }))
        }
        let feeAmount = CoinValueHelper.formattedAmount(for: transaction.fee)
        rows.append(Row<FullTransactionInfoTextCell>(id: "fee", hash: "fee", height: FullTransactionInfoTheme.cellHeight, bind: { cell, _ in
            cell.bind(title: "full_transaction_info.cell.fee".localized, description: feeAmount)
        }))
        let statusString = transaction.incoming ? "full_transaction_info.cell.received".localized : "full_transaction_info.cell.sent".localized
        let amountString = CoinValueHelper.formattedAmount(for: transaction.amount)
        rows.append(Row<FullTransactionInfoTextCell>(id: "sent_received", hash: "sent_received", height: FullTransactionInfoTheme.cellHeight, bind: { cell, _ in
            cell.bind(title: statusString, description: amountString)
        }))

        return [Section(id: "info", footerState: .margin(height: FullTransactionInfoTheme.bottomBarHeight), rows: rows)]
    }

    func share() {
        print("on share")
    }

    func close() {
        dismiss(animated: true)
    }

}