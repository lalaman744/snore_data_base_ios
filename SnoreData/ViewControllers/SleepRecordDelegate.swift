//
//  SleepRecordDelegate.swift
//  SnoreData
//
//  Created by Josh Kleinschmidt on 4/16/19.
//  Copyright © 2019 clara. All rights reserved.
//

import Foundation

protocol SleepRecordDelegate {
    func newSleepRecord(familyMember: FamilyMember, hours: Float, date: Date) -> Void
}
