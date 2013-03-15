Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab3COH6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 03:58:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15576 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab3COH6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 03:58:19 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-e6-5142d496bdfe
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, balbi@ti.com, rob.herring@calxeda.com,
        kgene.kim@samsung.com, thomas.abraham@linaro.org,
        grant.likely@secretlab.ca, dianders@chromium.org, jg1.han@samsung.com,
        p.paneri@samsung.com
Subject: [PATCH v4 0/2] ARM: Exynos5250: Enabling samsung usb phy
Date: Fri, 15 Mar 2013 13:26:09 +0530
Message-id: <1363334171-21812-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42JZI2JSpTv9ilOgweFfXBYH79dbHJj9kNXi
	7LKDbBavzmxks7i88BKrRe+Cq0DWrjlsFjPO72OyWLSsldni/JZOJovDKw4wWRybsYTRgcdj
	wecr7B6zGy6yeNy5tofN4/yMhYwefVtWMXr8fKnjcfzGdiaPz5vkAjiiuGxSUnMyy1KL9O0S
	uDJ+7zjJXvCTteLt5AnMDYxfWboYOTkkBEwkpl6cxghhi0lcuLeeDcQWEljKKPHnDi9MTUPv
	SqA4F1B8OqPE/d6vUM4UJolH3R/ButkEdCWa3u4Cs0UE0iX+3+1nBCliFrjFKLFl5l0mkISw
	gKPE/AlNYCtYBFQlNsy6zwxi8wp4SLQ0P2WFWKcg8eb2M2aQZgmBbewSN1vnM0M0CEh8m3wI
	6G4OoISsxKYDzBD1khIHV9xgmcAouICRYRWjaGpBckFxUnqRqV5xYm5xaV66XnJ+7iZGYBSc
	/vds4g7G+wesDzEmA42byCwlmpwPjKK8knhDYzMjC1MTU2Mjc0sz0oSVxHnVW6wDhQTSE0tS
	s1NTC1KL4otKc1KLDzEycXBKNTDOUPoQylIzM6/2YVqY21Sz36t2e6mxzzf/1ZDo8kTe9EaT
	2xbOTQlib7znXt/e2aLxutTjJGPdRL761NrY77nHC1WupS03iHc8t2zOZtUMna9hUXxRPRf3
	14UlVUT19DXyPvJ49N9YYkGnsmuihVnGzJDkPWwrD7O3y/BKsvpPOH2fmyuzR4mlOCPRUIu5
	qDgRANZEvGWYAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t9jQd1pV5wCDfastLQ4eL/e4sDsh6wW
	Z5cdZLN4dWYjm8XlhZdYLXoXXAWyds1hs5hxfh+TxaJlrcwW57d0MlkcXnGAyeLYjCWMDjwe
	Cz5fYfeY3XCRxePOtT1sHudnLGT06NuyitHj50sdj+M3tjN5fN4kF8AR1cBok5GamJJapJCa
	l5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0rZJCWWJOKVAoILG4WEnf
	DtOE0BA3XQuYxghd35AguB4jAzSQsIYx4/eOk+wFP1kr3k6ewNzA+JWli5GTQ0LARKKhdyUb
	hC0mceHeeiCbi0NIYDqjxP3er1DOFCaJR90fGUGq2AR0JZre7gKzRQTSJf7f7WcEKWIWuMUo
	sWXmXSaQhLCAo8T8CU1gY1kEVCU2zLrPDGLzCnhItDQ/ZYVYpyDx5vYz5gmM3AsYGVYxiqYW
	JBcUJ6XnGukVJ+YWl+al6yXn525iBEfZM+kdjKsaLA4xCnAwKvHwOjx0DBRiTSwrrsw9xCjB
	wawkwvvxolOgEG9KYmVValF+fFFpTmrxIcZkoO0TmaVEk/OBCSCvJN7Q2MTc1NjU0sTCxMyS
	NGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhjlL3+55Z7EUrjc5e03l6yjOZoLuHdqSvJM
	1nG8ou69u94t3uhRaZJQgEOmVCrrae7OveuEr3dna77ve+pz2sx8Z/IrteULM+9NXpj01r6p
	b1mGcnEa8/2/R9ZMPLbiZ9vX8+8K5CP9C7i+ulTf404qchNOqON1epduGrynv2bOE2NdXfMH
	lUosxRmJhlrMRcWJAFONjET2AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on 'for-next' of linux-samsung tree with following patches
from Doug on top:
usb: Document clocks in samsung, exynos4210-ehci/ohci bindings
ARM: dts: add usb 2.0 clock references to exynos5250 device tree

Also depending upon following patch-series for Samsung-usb-phy driver:
[PATCH v7 0/2] Adding USB 3.0 DRD-phy support for exynos5250

Changes from v3:
Added 'clocks' and 'clock-names' entry also in device nodes, aligning
with common clock framework for Samsung's SoCs.

Vivek Gautam (2):
  ARM: Exynos5250: Enabling samsung-usb2phy driver
  ARM: Exynos5250: Enabling samsung-usb3phy driver

 arch/arm/boot/dts/exynos5250.dtsi |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

-- 
1.7.6.5

