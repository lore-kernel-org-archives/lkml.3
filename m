Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbaJXNMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:12:51 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:15621 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225AbaJXNMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:12:48 -0400
X-AuditID: cbfee68d-f79296d000004278-28-544a504e7936
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com
Cc: mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net, tomasz.figa@gmail.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        k.kozlowski@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCHv4 0/3] ARM: dts: Add new board dts file for Exynos3250-based
 Rinato board
Date: Fri, 24 Oct 2014 22:12:39 +0900
Message-id: <1414156362-5752-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWyRsSkWNcvwCvE4Mh9Q4u/k46xW1z/8pzV
	4s+EVjaLSfcnsFi8fmFo0bvgKpvF2aY37BabHl9jtbi8aw6bxYzz+5gsll6/yGRx6vpnIHfy
	SzaLVbv+MDrweayZt4bR4/evSYweO2fdZffYvKTe48qJJlaPvi2rGD0+b5ILYI/isklJzcks
	Sy3St0vgynh7+xxjwQfeikMTN7M1MC7j7mLk4JAQMJFYOZ+pi5ETyBSTuHBvPRuILSSwlFFi
	y/I8iLiJxMY1B4FquIDiixglzi7qYINwmpgkzixvAetmE9CS2P/iBli3iICkRFPDH2aQImaB
	80wSjSd3soFsExaIlujcHAhSwyKgKvFo9QNWEJtXwEWip7+JFWKbgsSy5TNZQXolBPaxS5x7
	dooRokFA4tvkQywQV8tKbDrADFEvKXFwxQ2WCYyCCxgZVjGKphYkFxQnpRcZ6hUn5haX5qXr
	JefnbmIExsLpf896dzDePmB9iFGAg1GJh/fGDM8QIdbEsuLK3EOMpkAbJjJLiSbnAyMuryTe
	0NjMyMLUxNTYyNzSTEmcV1HqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRsc5yq3H12VZ
	Xlkvp2G377Jnd7uzcvI1yV0sp7llvZ6fT3mr9K0yq3IXh4qJStqdO5MdKxw1NqhLZ66/euL3
	xQMMGa6tH+9t3aex0OCncltg2FQujU1/Ehfev//oWthsS/vKh/8c+c3adZYcSWEMubLr1orA
	IMVlT36svPhjrv+ENf+P/C7pUFJiKc5INNRiLipOBAAiS7z9gAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jAV2/AK8Qg/mzNS3+TjrGbnH9y3NW
	iz8TWtksJt2fwGLx+oWhRe+Cq2wWZ5vesFtsenyN1eLyrjlsFjPO72OyWHr9IpPFqeufgdzJ
	L9ksVu36w+jA57Fm3hpGj9+/JjF67Jx1l91j85J6jysnmlg9+rasYvT4vEkugD2qgdEmIzUx
	JbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+hkJYWyxJxSoFBA
	YnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPG29vnGAs+8FYcmriZrYFxGXcXIyeHhICJ
	xMY1B5kgbDGJC/fWs3UxcnEICSxilDi7qAPKaWKSOLO8BayKTUBLYv+LG2wgtoiApERTwx9m
	kCJmgfNMEo0ndwIlODiEBaIlOjcHgtSwCKhKPFr9gBXE5hVwkejpb2KF2KYgsWz5TNYJjNwL
	GBlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgRH2zOpHYwrGywOMQpwMCrx8N6Y4RkixJpY
	VlyZe4hRgoNZSYTX398rRIg3JbGyKrUoP76oNCe1+BCjKdD2icxSosn5wESQVxJvaGxiZmRp
	ZG5oYWRsriTOe6DVOlBIID2xJDU7NbUgtQimj4mDU6qB0e/I/Q2TFyovyN1/Q+8ha+RNls/N
	9pKyjxiz71xmfP+0dX9EyzFN6SdrJlgVc7y6eS42ZFLVu1NsmpOWP49/1H+xuaX37Df+piv1
	lbPum508nTo1l+dE/YNEsS5vXza38G5hpmaOIxkd3J9u12c/fcSdwz5VaKezTnIcx6UVFjef
	MIlsenNfUYmlOCPRUIu5qDgRAOYXPQLMAgAA
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

Changes from v3:
- Fix wrong email address
- Remove 'vemmc_reg' fixed regulator and then use 'ldo12_reg' for mshc_0 

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
 arch/arm/boot/dts/exynos3250-rinato.dts   | 686 ++++++++++++++++++++++++++++++
 3 files changed, 704 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/exynos3250-rinato.dts

-- 
1.8.5.5

