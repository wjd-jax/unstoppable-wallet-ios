import UIKit
import ThemeKit
import SnapKit

class TransactionsCurrencyCell: UICollectionViewCell {
    private static let nameLabelFont = UIFont.subhead1

    private let button = ThemeButton()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(button)
        button.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        button.apply(style: .secondaryTransparent)
        button.isUserInteractionEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    override var isSelected: Bool {
        didSet {
            bind(selected: isSelected)
        }
    }


    override var isHighlighted: Bool {
        didSet {
            bind(highlighted: isHighlighted)
        }
    }

    func bind(title: String, selected: Bool) {
        button.setTitle(title, for: .normal)

        bind(selected: selected)
    }

    private func bind(selected: Bool) {
        button.isSelected = selected
    }

    private func bind(highlighted: Bool) {
        button.isHighlighted = highlighted
    }

}

extension TransactionsCurrencyCell {
    static func size(for title: String) -> CGSize {
        let size = title.size(containerWidth: .greatestFiniteMagnitude, font: TransactionsCurrencyCell.nameLabelFont)
        let calculatedWidth = size.width + 2 * .margin3x
        return CGSize(width: calculatedWidth, height: 28)
    }

}
