//
//  SelfAttestation.swift
//  WebAuthnKit
//
//  Created by Lyo Kato on 2018/11/20.
//  Copyright © 2018 Lyo Kato. All rights reserved.
//

import Foundation

public class SelfAttestation {
    
    public static func create(
        authData:       AuthenticatorData,
        clientDataHash: [UInt8],
        alg:            COSEAlgorithmIdentifier,
        keySupport:     KeySupport
        ) -> Optional<AttestationObject> {
        
        WAKLogger.debug("<SelfAttestation> create")
        
        var dataToBeSigned = authData.toBytes()
        dataToBeSigned.append(contentsOf: clientDataHash)
        
        guard let sig = keySupport.sign(
            data:  dataToBeSigned
        ) else {
            WAKLogger.debug("<AttestationHelper> failed to sign")
            return nil
        }
        
        let stmt = SimpleOrderedDictionary<String>()
        stmt.addInt("alg", Int64(alg.rawValue))
        stmt.addBytes("sig", sig)
        
        return AttestationObject(
            fmt:      "packed",
            authData: authData,
            attStmt:  stmt
        )
    }

    
}
