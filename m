Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaF0GL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 02:11:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:29651 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaF0GLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 02:11:23 -0400
X-AuditID: cbfee690-b7fb56d000003439-0d-53ad0b08e690
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, cpgs@samsung.com
Subject: [PATCH 0/2 v2] ARM: DTS: create thermistor fragment dtsi for Peach
 boards
Date: Fri, 27 Jun 2014 11:38:13 +0530
Message-id: <1403849295-29538-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWyRsSkTpeDe22wwZPl0hYvD2lazD9yjtXi
	7LKDbBbNi9ezWcw78o7F4vKuOWwWM87vY7JYtO0/swOHx+yGiyweO2fdZffYP3cNu0ffllWM
	Hp83yQWwRnHZpKTmZJalFunbJXBl/OuULZjPXfHiyUXWBsZ5nF2MnBwSAiYShx6dZoewxSQu
	3FvP1sXIxSEksJRR4nrDKxaYooWTLrFDJKYzSpxZMocFwulnkvj3+RcTSBWbgJnEwUWrwUaJ
	CDhK7JjzjwmkiFlgAaNE667VYEXCAiES0x/MYu1i5OBgEVCVuLadGyTMK+Aqcar1OlhYQkBB
	Ys4kG5BWCYF2dokrj/awgdSwCAhIfJt8iAWiRlZi0wFmiOMkJQ6uuMEygVFwASPDKkbR1ILk
	guKk9CITveLE3OLSvHS95PzcTYzA4D3979mEHYz3DlgfYkwGGjeRWUo0OR8Y/Hkl8YbGZkYW
	piamxkbmlmakCSuJ86o9SgoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwNi75Y2lXPn+2iNJ
	K5TFtu79HdhytolJcenrs/NSna4LBmkwHkpdsuhyhInxjEUrBYpEMqaovfybFvp0hc/CnyGW
	Bvb1+sfOpgtFnDoh5T3/yoG7Cu9XsDhpnWydaHDEM+RelMYRyQMMT45bvtVZ4v7orkszx+nQ
	1C8XZNwPxM9+My/g/YI2MS4lluKMREMt5qLiRAAW3nOAdAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsVy+t9jQV0O7rXBBnt2CVu8PKRpMf/IOVaL
	s8sOslk0L17PZjHvyDsWi8u75rBZzDi/j8li0bb/zA4cHrMbLrJ47Jx1l91j/9w17B59W1Yx
	enzeJBfAGtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6Dr
	lpkDdIuSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMeNfp2zBfO6KF08u
	sjYwzuPsYuTkkBAwkVg46RI7hC0mceHeerYuRi4OIYHpjBJnlsxhgXD6mST+ff7FBFLFJmAm
	cXDRarAOEQFHiR1z/jGBFDELLGCUaN21GqxIWCBEYvqDWaxdjBwcLAKqEte2c4OEeQVcJU61
	XgcLSwgoSMyZZDOBkXsBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjODYeCa9g3FVg8Uh
	RgEORiUe3g6vNcFCrIllxZW5hxglOJiVRHhf3gMK8aYkVlalFuXHF5XmpBYfYjQF2j2RWUo0
	OR8Yt3kl8YbGJuamxqaWJhYmZpZK4rwHW60DhQTSE0tSs1NTC1KLYPqYODilGhgXNP3dw5wS
	ZqQiX/bKvIpx36yjJQnGbTGSu/wzpCdycKZtD7SyWuPeN1PijfbZtP21rTUZWiedC24lnvi5
	7r3d7eq912MLbh7vFn3r/6JVZHNFeuABLc8ZU2wjNdbzKe6c/OR9k5a0SOCGv2wV26WM53q3
	uvaJHAo8cEVl9ZvHd1cWX9cTfqfEUpyRaKjFXFScCADVrCugowIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset does the following
1. Create a thermistor dtsi fragment file cros-adc-thermistors.dtsi for
   exynos5420-peach-pit.dts and exynos5800-peach-pi.dts
2. Adds the ADC based Thermistor nodes and enables them in peach_pit.dts
   and peach_pi.dts
3. Corrects the vendor prefix for thermistors in exynos4412-trats2.dts

This patch depends on (1/4 and 2/4 patches of) patchset posted
http://www.spinics.net/lists/linux-iio/msg13486.html
Which were applied on to Guenter Roeck's tree.

cat sysfs entries exported by hwmon for 4 thermistors
and verified the values on Peach pit and pi boards.

Changes since v1:
1. Dropped 2/3 "ARM: DTS: Add NTC thermistor nodes to Exynos5250 based Snow"
   https://lkml.org/lkml/2014/6/26/192
   As large number of Snow boards dint have thermistors.
2. Created a thermistor fragment instead of common dtsi file

Naveen Krishna Chatradhi (2):
  ARM: DTS: use new compatible string for thermistors in trats2
  ARM: DTS: Add thermistor dts fragment needed by exynos based peach
    boards

 arch/arm/boot/dts/cros-adc-thermistors.dtsi |   44 +++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos4412-trats2.dts     |    4 +--
 arch/arm/boot/dts/exynos5420-peach-pit.dts  |    6 ++++
 arch/arm/boot/dts/exynos5800-peach-pi.dts   |    6 ++++
 4 files changed, 58 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/boot/dts/cros-adc-thermistors.dtsi

-- 
1.7.9.5

