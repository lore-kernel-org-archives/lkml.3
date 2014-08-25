Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbaHYHas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 03:30:48 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59175 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbaHYHan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 03:30:43 -0400
X-AuditID: cbfee68d-f79c46d000000b84-f9-53fae6187b16
From: Chanwoo Choi <cw00.choi@samsung.com>
To: eduardo.valentin@ti.com, amit.daniel@samsung.com, rui.zhang@intel.com
Cc: kgene.kim@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, galak@codeaurora.org, ch.naveen@samsung.com,
        kyungmin.park@samsung.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv4 0/4] thermal: exynos: Add support for TRIMINFO feature of
 Exynos3250
Date: Mon, 25 Aug 2014 16:30:21 +0900
Message-id: <1408951825-2639-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkWFfi2a9gg3VTLS0aroZY3H1+mNHi
	+pfnrBbzj5xjtViz/yeTRf+bhawWvQuuslmcbXrDbrHp8TVWi8u75rBZfO49wmgx4/w+Joul
	1y8yWUyYvpbFonXvEXaLJw/72BwEPNbMW8Pocbmvl8lj8Z6XTB6bVnWyeWxeUu/Rt2UVo8fx
	G9uZPD5vkgvgiOKySUnNySxLLdK3S+DK2HzSqmA/T8XBqzPZGxhnc3UxcnBICJhI9B1K7GLk
	BDLFJC7cW8/WxcjFISSwlFFixuKVzBAJE4n92/vZIRLTGSVmP/jECOE0MUlM/97JBFLFJqAl
	sf/FDTYQW0TAU2LuwhYmkCJmgTdMEr+WnWMHSQgLREi0r17GAmKzCKhKnNn/hBXE5hVwkdi1
	cRM7xDo5iQ97HoGtkxC4xi4x/8IuqAYBiW+TD7FA3C0rsekA1HmSEgdX3GCZwCi4gJFhFaNo
	akFyQXFSepGhXnFibnFpXrpecn7uJkZgrJz+96x3B+PtA9aHGAU4GJV4eFdw/goWYk0sK67M
	PcRoCrRhIrOUaHI+MCLzSuINjc2MLExNTI2NzC3NlMR5FaV+BgsJpCeWpGanphakFsUXleak
	Fh9iZOLglGpg3Nv4/o9UQFNlxNxvc8U3v776M2fl3I8h8xWuHnDW0va66M8cenPeKb70Q+2q
	ydsfem/16Od+9mHx15x5vw0f7r+zr+/+O4d1rfumqi1p2RFQoiTkfbfwsvYX62t3SrYaT+E8
	KGJ/9dmrsM09W6/Zp4ZeXrr2sEb+CvWImDMaAd/q3t9OOf987xUlluKMREMt5qLiRABQ6f2h
	kAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t9jQV2JZ7+CDd7PMbBouBpicff5YUaL
	61+es1rMP3KO1WLN/p9MFv1vFrJa9C64ymZxtukNu8Wmx9dYLS7vmsNm8bn3CKPFjPP7mCyW
	Xr/IZDFh+loWi9a9R9gtnjzsY3MQ8Fgzbw2jx+W+XiaPxXteMnlsWtXJ5rF5Sb1H35ZVjB7H
	b2xn8vi8SS6AI6qB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnF
	J0DXLTMH6AMlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8bmk1YF+3kq
	Dl6dyd7AOJuri5GTQ0LARGL/9n52CFtM4sK99WxdjFwcQgLTGSVmP/jECOE0MUlM/97JBFLF
	JqAlsf/FDTYQW0TAU2LuwhYmkCJmgTdMEr+WnQMbJSwQIdG+ehkLiM0ioCpxZv8TVhCbV8BF
	YtfGTVDr5CQ+7HnEPoGRewEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Fh8JrWDcWWD
	xSFGAQ5GJR7elZy/goVYE8uKK3MPMUpwMCuJ8E45DhTiTUmsrEotyo8vKs1JLT7EaAq0fSKz
	lGhyPjBN5JXEGxqbmBlZGpkbWhgZmyuJ8x5otQ4UEkhPLEnNTk0tSC2C6WPi4JRqYAxQeL9t
	ppm6BL9HXNXMQ8VcDA96f2/9k/TzvevtSx6VSe8CjHmv2N5NsPyxe6bKB+WpanyvN4c6en5h
	71zLdvSwtbi/xNmTdyVufj3to3Y2fF3GTP7AmKMnbl4stWNiW7Z9ync5/xcx2d1FJ/cEfzDh
	lxPbJmfsc9l0cZDlotPLl69RfZkjMEmJpTgj0VCLuag4EQCRCpEx2wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add the support of TRIMINFO_RELOAD feature for Exynos3250.
But Exynos3250 has two TRIMINFO_CTRL register instead other Exynos has only one
TRIMINFO_CTRL register. So, this patchset support the some Exynos SoC which
has more than one TRIMINF_CTRL.

Also, this patchset fix wrong value of TRIMINFO_RELOAD_SHIFT and remove
duplicate code when reading triminfo register of Exynos5440.

Changes from v3:
- Add reviewed message of Amit Daniel Kachhap <amit.daniel@samsung.com>
- Split RELOAD patch as two patch
- Fix 'TRIMINFO_RELOAD_SHIFT' value
- This series includes separate patch[1]
  [1] https://lkml.org/lkml/2014/8/20/5
- Drop ACTIME bit setting because TRM includes not enough information of ACTIME bit.

Changes from v2:
- Fix build break because of missing 'or' operation.

Changes from v1:
- Add missing 'TMU_SUPPORT_TRIM_RELOAD' features

Chanwoo Choi (4):
  thermal: exynos: Fix wrong value of TRIMINFO_RELOAD_SHIFT
  thermal: exynos: Add support for many TRIMINFO_CTRL registers
  thermal: exynos: Add support for TRIM_RELOAD feature at Exynos3250
  thermal: exynos: Remove duplicate code when reading triminfo register
    of Exynos5440

 drivers/thermal/samsung/exynos_thermal_common.h |  1 +
 drivers/thermal/samsung/exynos_tmu.c            | 27 +++++++++++++++++++------
 drivers/thermal/samsung/exynos_tmu.h            |  9 +++++++--
 drivers/thermal/samsung/exynos_tmu_data.c       | 14 +++++++++++--
 drivers/thermal/samsung/exynos_tmu_data.h       | 12 ++++++++---
 5 files changed, 50 insertions(+), 13 deletions(-)

-- 
1.8.0

