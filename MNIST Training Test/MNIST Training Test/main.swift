//
//  main.swift
//  MNIST Training Test
//
//  Created by Yongyang Nie on 3/18/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

import Foundation

print("Hello, World!")

var learner = Learner()
learner.trainNetwork(batchSize: 5000, accuracy: 0.93)
Storage.write(Storage.getFileURL("mindData_learn"), learner.swiftMind)
