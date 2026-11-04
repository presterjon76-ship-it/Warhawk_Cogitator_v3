import 'package:flutter/material.dart';
import '../theme/cogitator_theme.dart';

class CogitatorHudHeader extends StatelessWidget {
  final int currentXp;
  final String cogitatorRank;
  final bool linkActive;

  const CogitatorHudHeader({
    super.key,
    required this.currentXp,
    required this.cogitatorRank,
    required this.linkActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: const BoxDecoration(
        color: Color(0xFF040604),
        border: Border(
          bottom: BorderSide(color: CogitatorTheme.terminalBorder, width: 2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "FORGE COGITATOR // 734-STC",
                style: CogitatorTheme.terminalHeader.copyWith(fontSize: 12),
              ),
              Text(
                "RANK: $cogitatorRank | XP: $currentXp",
                style: CogitatorTheme.terminalText.copyWith(
                  fontSize: 11,
                  color: CogitatorTheme.sanctifiedGold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                linkActive ? "RELAY: SYNCHED" : "RELAY: DISCONNECTED",
                style: CogitatorTheme.terminalText.copyWith(
                  fontSize: 10,
                  color: linkActive ? CogitatorTheme.crtGreen : CogitatorTheme.rustRed,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: linkActive ? CogitatorTheme.crtGreen : CogitatorTheme.rustRed,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
