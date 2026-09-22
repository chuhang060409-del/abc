import 'package:flutter/material.dart';

/// Blockchain Provenance & Cryptographic Record
@immutable
class BlockchainRecord {
  final String blockHeight;
  final String transactionHash;
  final String sm2Signature;
  final String sm3Digest;
  final int syncedNodes;
  final DateTime blockTimestamp;
  final String antiCounterfeitCode;

  const BlockchainRecord({
    this.blockHeight = '#18,492,031',
    this.transactionHash = '0x8f2b3e41...982c7a',
    this.sm2Signature = 'SM2-SIG-04B2...A9FE',
    this.sm3Digest = '3A8E...D921',
    this.syncedNodes = 8,
    required this.blockTimestamp,
    this.antiCounterfeitCode = '9203-8812-4019-3321',
  });
}

/// Full Lifecycle Traceability Timeline Node
@immutable
class TraceLifecycleNode {
  final String id;
  final String stage;
  final String title;
  final String subtitle;
  final String operatorName;
  final String location;
  final DateTime timestamp;
  final bool isVerified;
  final String evidenceHash;

  const TraceLifecycleNode({
    required this.id,
    required this.stage,
    required this.title,
    required this.subtitle,
    required this.operatorName,
    required this.location,
    required this.timestamp,
    this.isVerified = true,
    required this.evidenceHash,
  });
}

/// 5 Key TCM Stakeholders for Cross-Chain Collaboration
@immutable
class StakeholderRole {
  final String roleKey;
  final String roleName;
  final String description;
  final IconData icon;
  final bool isConnected;
  final int pendingSignatures;

  const StakeholderRole({
    required this.roleKey,
    required this.roleName,
    required this.description,
    required this.icon,
    this.isConnected = true,
    this.pendingSignatures = 0,
  });
}

/// Risk Alert Engine Diagnostics
@immutable
class RiskAlertItem {
  final String id;
  final String title;
  final String description;
  final String severity; // 'CRITICAL' | 'WARNING' | 'STABLE'
  final String cabinId;
  final DateTime timestamp;
  final bool isMitigated;

  const RiskAlertItem({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.cabinId,
    required this.timestamp,
    this.isMitigated = false,
  });
}
