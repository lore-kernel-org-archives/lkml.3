Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab3KLGeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 01:34:07 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:27566 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab3KLGeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 01:34:04 -0500
X-AuditID: cbfee690-b7f3d6d000001c4a-c8-5281cbda7ab0
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, rui.zhang@intel.com, eduardo.valentin@ti.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        devicetree@vger.kernel.org, b.zolnierkie@samsung.com, cpgs@samsung.com,
        t.figa@samsung.com
Subject: [PATCH 0/3] thermal: samsung: Clean up and add support for Exynos5420
Date: Tue, 12 Nov 2013 12:05:32 +0530
Message-id: <1384238132-24515-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1377668719-8602-1-git-send-email-ch.naveen@samsung.com>
References: <1377668719-8602-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42JZI2JSo3vrdGOQwZlfXBYNV0MsNs5Yz2rx
	8pCmxfwj51gt1uz/yWTRu+Aqm8XlXXPYLD73HmG0mHF+H5PFom3/mS2ePOxjs1g/4zWLA4/H
	zll32T0W73nJ5NG3ZRWjx/Eb25k8Pm+SC2CN4rJJSc3JLEst0rdL4MpYt8SpYBJnxb4Fi1ga
	GBewdzFyckgImEi0bm9jhLDFJC7cW8/WxcjFISSwlFFi04d/LDBFm7a3sEMkFjFK3Nz3lBnC
	6WGSWLznKxNIFZuAmcTBRavBxooIyEhMvbKfFaSIWWA+k8ShP2vBEsICfhLHN30C28cioCqx
	4uAxMJtXwFXi0PuJbBDrFCW6n00AszmB4tOXvASrERJwkbj8ZjXUSbvYJdr2GkDMEZD4NvkQ
	UJwDKC4rsekAM0SJpMTBFTdYJjAKL2BkWMUomlqQXFCclF5kolecmFtcmpeul5yfu4kRGBWn
	/z2bsIPx3gHrQ4zJQOMmMkuJJucDoyqvJN7Q2MzIwtTE1NjI3NKMNGElcV61R0lBQgLpiSWp
	2ampBalF8UWlOanFhxiZODilGhjn7+FSk87+O+WU2deVS5JiA5WTS8Tv7DXe97boHO+azpe6
	vCeLXI0ddPNvTc1QWslSKLwo86R1xp1bFq0NHZ+/hykslbcqscz886lE4PXFY4qpbjNeSb8I
	ZubVsxBZX7L/k6Lb0kvZObEMp+eqnDu9+Pt/sbWGe5pXXOpsKd5lG+dxP+dRdaQSS3FGoqEW
	c1FxIgDGftSAoAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jAd1bpxuDDHYuYrZouBpisXHGelaL
	l4c0LeYfOcdqsWb/TyaL3gVX2Swu75rDZvG59wijxYzz+5gsFm37z2zx5GEfm8X6Ga9ZHHg8
	ds66y+6xeM9LJo++LasYPY7f2M7k8XmTXABrVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7yp
	mYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QeUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC
	4HqMDNBAwhrGjHVLnAomcVbsW7CIpYFxAXsXIyeHhICJxKbtLVC2mMSFe+vZuhi5OIQEFjFK
	3Nz3lBnC6WGSWLznKxNIFZuAmcTBRavBOkQEZCSmXtnPClLELDCfSeLQn7VgCWEBP4njmz4x
	gtgsAqoSKw4eA7N5BVwlDr2fyAaxTlGi+9kEMJsTKD59yUuwGiEBF4nLb1azTGDkXcDIsIpR
	NLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOOqeSe1gXNlgcYhRgINRiYd3B1djkBBrYllxZe4h
	RgkOZiUR3vDFQCHelMTKqtSi/Pii0pzU4kOMyUBXTWSWEk3OByaEvJJ4Q2MTc1NjU0sTCxMz
	S9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpgzIn9dG3btdRZnjYTA3P67OvF5wrY8Tq/
	krrIMel5582XklNf7zjAN/Vv3YHOua2eC+7edNpygUPB7PMhVnGPA0xbudrnlJ1UnCwV8KNo
	BZfZ3OzUSIuVUZeVWyZWRS3s/8t547uQtVVTmUT+vy97z299sORAZ2+/4tKGU1JG9mfPeX9R
	+dR5VomlOCPRUIu5qDgRAJ+L01X+AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset does a little clean up of the existing code
1.  [v9] thermal: samsung: replace inten_ bit fields with intclr_
2.  [v9] thermal: samsung: change base_common to more meaningful base_second

adds support for Exynos5420 in the driver and
3.  [v9] thermal: samsung: Add TMU support for Exynos5420 SoCs
also adds the device tree nodes for the same to exynos5420.dtsi (linux-samsung.git)
4.  [v3] ARM: dts: Exynos5420: Add device nodes for TMU blocks

Naveen Krishna Chatradhi (3):
  thermal: samsung: replace inten_ bit fields with intclr_
  thermal: samsung: change base_common to more meaningful base_second
  thermal: samsung: Add TMU support for Exynos5420 SoCs
  ARM: dts: Exynos5420: Add device nodes for TMU blocks

 .../devicetree/bindings/thermal/exynos-thermal.txt |   49 +++++++-
 drivers/thermal/samsung/exynos_tmu.c               |   78 +++++++++---
 drivers/thermal/samsung/exynos_tmu.h               |   22 ++--
 drivers/thermal/samsung/exynos_tmu_data.c          |  126 ++++++++++++++++++--
 drivers/thermal/samsung/exynos_tmu_data.h          |   12 +-
 5 files changed, 249 insertions(+), 38 deletions(-)

-- 
1.7.10.4

