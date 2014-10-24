Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373AbaJXLkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 07:40:07 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:65155 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317AbaJXLkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 07:40:03 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-e1-544a3a919ffb
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com
Cc: mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net, tomasz.figa@gmail.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCHv3 0/3] ARM: dts: Add new board dts file for Exynos3250-based
 Rinato board
Date: Fri, 24 Oct 2014 20:39:52 +0900
Message-id: <1414150795-31105-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsWyRsSkWHeilVeIwZTf4hZ/Jx1jt7j+5Tmr
	xZ8JrWwWk+5PYLHoXXCVzeJs0xt2i02Pr7FaXN41h81ixvl9TBZLr19ksjh1/TOQO/klm8Wq
	XX8YHXg91sxbw+jx+9ckRo+ds+6ye2xeUu9x5UQTq0ffllWMHp83yQWwR3HZpKTmZJalFunb
	JXBldM5oYC74xlOxYs9bxgbGo1xdjBwcEgImEj3fqroYOYFMMYkL99azdTFycQgJLGWUePTl
	FjtEwkTi/u0mJojEdEaJ9zs6GSGcJiaJq6f6GUGq2AS0JPa/uMEGYosISEo0NfxhBrGZBbYx
	SbRNygKxhQWiJebv+ApWwyKgKnGyvQ9sA6+Aq8Sk+auhtilILFs+kxVkgYTALnaJG48/skI0
	CEh8m3yIBeJsWYlNB5gh6iUlDq64wTKBUXABI8MqRtHUguSC4qT0IhO94sTc4tK8dL3k/NxN
	jMAoOP3v2YQdjPcOWB9iFOBgVOLhNZjtGSLEmlhWXJl7iNEUaMNEZinR5HxgrOWVxBsamxlZ
	mJqYGhuZW5opifO+lvoZLCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHRVcY3oNjzwMfVYRaa
	81UfHgrYbn7g4HG2ty++vzBdz/WH8yVveb3UfDdWlowtczOWCjHxc/7YUJRkZ755em25pnr/
	1SM8rwpKLt0Oqt83iX/v4WIZvjne8uz+E5Njn5X3BMk/kFt4nsNeak/AhUIFgaXmWwv/+82e
	esst8F5fdLj74+ZHHoFKLMUZiYZazEXFiQAlY6PDfQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t9jQd2JVl4hBpff8Vv8nXSM3eL6l+es
	Fn8mtLJZTLo/gcWid8FVNouzTW/YLTY9vsZqcXnXHDaLGef3MVksvX6RyeLU9c9A7uSXbBar
	dv1hdOD1WDNvDaPH71+TGD12zrrL7rF5Sb3HlRNNrB59W1YxenzeJBfAHtXAaJORmpiSWqSQ
	mpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdK6SQlliTilQKCCxuFhJ
	3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMaNzRgNzwTeeihV73jI2MB7l6mLk5JAQMJG4f7uJ
	CcIWk7hwbz1bFyMXh5DAdEaJ9zs6GSGcJiaJq6f6GUGq2AS0JPa/uMEGYosISEo0NfxhBrGZ
	BbYxSbRNygKxhQWiJebv+ApWwyKgKnGyvY8dxOYVcJWYNH81O8Q2BYlly2eyTmDkXsDIsIpR
	NLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOMqeSe9gXNVgcYhRgINRiYf3xgzPECHWxLLiytxD
	jBIczEoivF4mXiFCvCmJlVWpRfnxRaU5qcWHGE2Btk9klhJNzgcmgLySeENjEzMjSyNzQwsj
	Y3Mlcd6DrdaBQgLpiSWp2ampBalFMH1MHJxSDYzBmx5GcG06rsF797t6l5M2wxWe/Ec7vzy5
	9eqNyH3WV1sblqw8WTplycL1Uafc9HKfzfbt+3PmD1up27uSzMfXEqYFszev/rnvS5/qN4lP
	4Wkp903EZzu/KJg/9x9re/+rgz7GmY9Ln1u0uvz5FxQuZfrZ9Vd7p6Pcfwsh5qbOB9dfOyz5
	EaWoxFKckWioxVxUnAgAyLVNqsgCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds new board dts file for Samsung Rinato board (Gear 2) which
is based on Exynos3250 SoC and adds sleep mode pin configuration using pinctrl
subsystem to reduce leakage power-consumption in sleep state.

This patchset is based on linux-samsung.git (for-next branch).

Changes from v2:
- Separate patch3 from patchset[1] and then this patchset includes patch3.
  After applied patch3, the power-consumption of Rinato board is 0.6mA in suspend state.
  [1] [PATCHv5 0/3] regulator: of: Add support for parsing regulator suspend state
  : https://lkml.org/lkml/2014/10/10/161
- Change PDN (Power-down mode) state for GPE0-3 (BT_UART_RTS) because Rinato
  board uses UART1 for bluetooth device. BT_UART_RTS pin should be disabled in
  suspend state by setting high state of GPE0-3
- Turn on always the regulator state of VAP_VMIPI_1.0V because if VAP_VMIPI_1.0V
  is off state or would be not controlled by DRM driver, happen imprecise external abort.

Changes from v1:
- Remove useless brace
- Remove unneeded 'regulators' keyword
- Consolidate memory information in one entry

Chanwoo Choi (3):
  ARM: dts: Add board dts file for Exynos3250-based Rinato board
  ARM: dts: Add sleep mode pin configuration for exynos3250-rinato
  ARM: dts: Add sleep mode of regulator for exynos3250-rinato board

 arch/arm/boot/dts/Makefile                |   3 +-
 arch/arm/boot/dts/exynos3250-pinctrl.dtsi |  16 +
 arch/arm/boot/dts/exynos3250-rinato.dts   | 695 ++++++++++++++++++++++++++++++
 3 files changed, 713 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/exynos3250-rinato.dts

-- 
1.8.5.5

