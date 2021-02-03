//
//  Grayscale.swift
//  grayscale
//
//  Created by Brett Gutstein on 1/31/21.
//  Copyright © 2021 Brett Gutstein. All rights reserved.
//

// see Sources/Bridge.h for information about toggling grayscale
func grayscaleEnabled() -> Bool {
    return MADisplayFilterPrefGetCategoryEnabled(SYSTEM_FILTER) &&
        (MADisplayFilterPrefGetType(SYSTEM_FILTER) == GRAYSCALE_TYPE)
}

func enableGrayscale() {
    MADisplayFilterPrefSetType(SYSTEM_FILTER, GRAYSCALE_TYPE)
    MADisplayFilterPrefSetCategoryEnabled(SYSTEM_FILTER, true)
    _UniversalAccessDStart(UNIVERSALACCESSD_MAGIC)
}

func disableGrayscale() {
    MADisplayFilterPrefSetCategoryEnabled(SYSTEM_FILTER, false)
    _UniversalAccessDStart(UNIVERSALACCESSD_MAGIC)
}

func toggleGrayscale() {
    grayscaleEnabled() ? disableGrayscale() : enableGrayscale()
}

func setGrayscale(_ enable: Bool) {
    if grayscaleEnabled() != enable {
        toggleGrayscale()
    }
}
