Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab3LJGju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 01:39:50 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:46223 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab3LJGjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 01:39:44 -0500
X-AuditID: cbfee68f-b7f256d000003c1b-69-52a6b72ebd40
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, rui.zhang@intel.com, eduardo.valentin@ti.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        devicetree@vger.kernel.org, b.zolnierkie@samsung.com, cpgs@samsung.com,
        t.figa@samsung.com
Subject: [PATCH v11 0/4] thermal: samsung: Clean up and add support for
 Exynos5420
Date: Tue, 10 Dec 2013 12:10:40 +0530
Message-id: <1386657640-21481-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1384238132-24515-1-git-send-email-ch.naveen@samsung.com>
References: <1384238132-24515-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42JZI2JSo6u3fVmQwcZvlhYNV0MsNs5Yz2rx
	8pCmxfwj51gt1uz/yWTRu+Aqm8XlXXPYLD73HmG0mHF+H5PFom3/mS2ePOxjs1g/4zWLA4/H
	zll32T0W73nJ5NG3ZRWjx/Eb25k8Pm+SC2CN4rJJSc3JLEst0rdL4MrouvqAseAPV8XdC7fY
	GxjfcXQxcnJICJhInNj1mhHCFpO4cG89WxcjF4eQwFJGiVvNN9lginbO+soIkZjOKLHz9kIm
	CKeHSeL7yjssIFVsAmYSBxetZgexRQRkJKZe2c8KUsQsMJ9J4tCftWAJYYEQiVUXfzKB2CwC
	qhIdDxeCxXkFXCXWrbjIBLFOUaL72QSw1ZwCbhIbDx0Eu08IqObuvsvsIEMlBA6xS0zsuMMI
	MUhA4tvkQ0BXcAAlZCU2HWCGmCMpcXDFDZYJjMILGBlWMYqmFiQXFCelFxnrFSfmFpfmpesl
	5+duYgRGxul/z/p3MN49YH2IMRlo3ERmKdHkfGBk5ZXEGxqbGVmYmpgaG5lbmpEmrCTOe/9h
	UpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxv5q64S5v64LWCxLYZ7Vupd7poLLrOcd7x8V
	rF/lvFbOa/myVLY4DY+0+UXMJTviF10zajP5enTf2Zx3IRZnz260i/rFcJDlwAq5tZPzHnM7
	ti+YdGnPIkOdGWz+93eeEuSTbdCJF9a9vSLqyoHDa3lVrQ3n2v+cvMXRPYc9l2/G86bDIVO4
	6pRYijMSDbWYi4oTAUYn+dmiAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t9jQV297cuCDB4dN7BouBpisXHGelaL
	l4c0LeYfOcdqsWb/TyaL3gVX2Swu75rDZvG59wijxYzz+5gsFm37z2zx5GEfm8X6Ga9ZHHg8
	ds66y+6xeM9LJo++LasYPY7f2M7k8XmTXABrVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7yp
	mYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QeUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC
	4HqMDNBAwhrGjK6rDxgL/nBV3L1wi72B8R1HFyMnh4SAicTOWV8ZIWwxiQv31rN1MXJxCAlM
	Z5TYeXshE4TTwyTxfeUdFpAqNgEziYOLVrOD2CICMhJTr+xnBSliFpjPJHHoz1qwhLBAiMSq
	iz+ZQGwWAVWJjocLweK8Aq4S61ZcZIJYpyjR/WwCG4jNKeAmsfHQQbAzhIBq7u67zD6BkXcB
	I8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOC4eya9g3FVg8UhRgEORiUeXol/S4OEWBPL
	iitzDzFKcDArifB61i0LEuJNSaysSi3Kjy8qzUktPsSYDHTVRGYp0eR8YErIK4k3NDYxNzU2
	tTSxMDGzJE1YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQbGdb9nab8u4br2pC+kh+cHS/3E
	I9ZXrgtUaBcKrjswVzzrW8jUCU3vsl3UjLLrdl0WumLotNkkf5fhnr9NNddWCr3juXn88WE5
	hX3z193aUptgr3Dx0MJDX1g/TdV8alfSr32GX4F5O6dBSskfX4ZtUf/v9+xd2B/JbMl88HzA
	5t9Fjz9G3FpWrsRSnJFoqMVcVJwIANM1brv/AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset does a little clean up of the existing code (linux-soc-thermal)
1.  [v11] thermal: samsung: replace inten_ bit fields with intclr_
2.  [v11] thermal: samsung: change base_common to more meaningful base_second

adds support for Exynos5420 in the driver and (linux-soc-thermal)
3.  [v11] thermal: samsung: Add TMU support for Exynos5420 SoCs
also adds the device tree nodes for the same to exynos5420.dtsi (linux-samsung.git)
4.  [v11] ARM: dts: Exynos5420: Add device nodes for TMU blocks

(linux-soc-thermal)
Naveen Krishna Chatradhi (3):
  thermal: samsung: replace inten_ bit fields with intclr_
  thermal: samsung: change base_common to more meaningful base_second
  thermal: samsung: Add TMU support for Exynos5420 SoCs

 .../devicetree/bindings/thermal/exynos-thermal.txt |   42 ++++++-
 drivers/thermal/samsung/exynos_tmu.c               |   72 +++++++++---
 drivers/thermal/samsung/exynos_tmu.h               |   21 ++--
 drivers/thermal/samsung/exynos_tmu_data.c          |  119 ++++++++++++++++++--
 drivers/thermal/samsung/exynos_tmu_data.h          |   12 +-
 5 files changed, 228 insertions(+), 38 deletions(-)

(linux-samsung.git)
Naveen Krishna Chatradhi (1):
  ARM: dts: Exynos5420: Add device nodes for TMU blocks

 arch/arm/boot/dts/exynos5420.dtsi |   40 +++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)
-- 
1.7.10.4

