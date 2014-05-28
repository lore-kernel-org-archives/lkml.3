Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182AbaE1JAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:00:34 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17791 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168AbaE1JA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:00:26 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-ad-5385a5a575d9
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] ARM: multi_v7_defconfig: Enable clock and RTC driver for S2M
 and S5M
Date: Wed, 28 May 2014 11:00:13 +0200
Message-id: <1401267613-8232-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42I5/e/4Zd2lS1uDDR6uVbH4O+kYu8XGGetZ
	LV6/MLToXXCVzeJs0xt2i02Pr7FaXN41h81ixvl9TBa3L/NarD1yl93i1PXPbBYn//QyOvB4
	tDT3sHn8/jWJ0ePOtT1sHpuX1HtcOdHE6tG3ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZ51b+
	YSo4zl4xf9EBxgbGk2xdjJwcEgImEo8vt7BC2GISF+6tB4pzcQgJLGWUaF43iwXC6WOSeNJ7
	kxmkik3AWGLz8iVgVSICUxglfny8B1bFLHCVSeL41hOMIFXCAuESDybfAbNZBFQlfi5cAraP
	V8BN4vvL6ewQ++QkTh6bzDqBkXsBI8MqRtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJBQ+7KD
	cfExq0OMAhyMSjy8C2Rbg4VYE8uKK3MPMUpwMCuJ8DZ3AoV4UxIrq1KL8uOLSnNSiw8xMnFw
	SjUwslUxN7gcTv139Pr0L3aM2YoS83fYOkVpyO14Gtf6KMTqstOhsrKqGQ0PU1q6+Kuze1J7
	Lly5c1dBI9Nk/W7RfO87Nm/CNm7qyBAwmOZqfLv1SGrpuZub/Re9meh/SDrkresfRf2IR0tv
	6v3N99waUse2PCRnP/NVwbLGq7UMQWvm7a718Z6kxFKckWioxVxUnAgA5FVIPhMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The config enables already Samsung's PMIC-s MFD driver and regulators
(S2MPS11 and S5M8767). Enable also drivers for rest of these PMIC-s
features: clock and RTC.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/configs/multi_v7_defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 839d16ab7b81..71f2e42978d7 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -321,6 +321,7 @@ CONFIG_RTC_DRV_PL031=y
 CONFIG_RTC_DRV_VT8500=y
 CONFIG_RTC_DRV_MV=y
 CONFIG_RTC_DRV_TEGRA=y
+CONFIG_RTC_DRV_S5M=y
 CONFIG_DMADEVICES=y
 CONFIG_DW_DMAC=y
 CONFIG_MV_XOR=y
@@ -341,6 +342,7 @@ CONFIG_KEYBOARD_NVEC=y
 CONFIG_SERIO_NVEC_PS2=y
 CONFIG_NVEC_POWER=y
 CONFIG_COMMON_CLK_QCOM=y
+CONFIG_COMMON_CLK_S2MPS11=y
 CONFIG_MSM_GCC_8660=y
 CONFIG_MSM_MMCC_8960=y
 CONFIG_MSM_MMCC_8974=y
-- 
1.9.1

