Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964782AbaFZMQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 08:16:10 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52179 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932417AbaFZMQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 08:16:03 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-25-53ac0ef76e74
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH RESEND 2/2] ARM: exynos_defconfig: Enable clock and RTC driver
 for S2M and S5M
Date: Thu, 26 Jun 2014 14:15:44 +0200
Message-id: <1403784944-12890-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1403784944-12890-1-git-send-email-k.kozlowski@samsung.com>
References: <1403784944-12890-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprALMWRmVeSWpSXmKPExsVy+t/xq7rf+dYEG5w6I2fxd9IxdouNM9az
	Wrx+YWjRu+Aqm8XZpjfsFpseX2O1uLxrDpvFjPP7mCxuX+a1WHvkLrvFqeuf2SzWz3jN4sDj
	0dLcw+bx+9ckRo/NS+o9rpxoYvXo27KK0ePzJrkAtigum5TUnMyy1CJ9uwSujBVTprMUzGCr
	2Hf7CWMD4zrWLkZODgkBE4kJe2azQdhiEhfurQeyuTiEBJYySrxv/w1WJCTQxyTx/XgIiM0m
	YCyxefkSsCIRgR2MEsvvXWYHcZgFVjJJfDg5ibGLkYNDWCBBYlIDP4jJIqAqMX+pGkgvr4C7
	xOu5zUwQy+QkTh6bDDafU8BDYua958wQu9wlTs7fyTaBkXcBI8MqRtHU0uSC4qT0XCO94sTc
	4tK8dL3k/NxNjJBQ/LqDcekxq0OMAhyMSjy8J8JWBwuxJpYVV+YeYpTgYFYS4RX5DRTiTUms
	rEotyo8vKs1JLT7EyMTBKdXAaBb9eMWSmoVKk93/MR9bvdrp8iGjfeXmHJl8F/8sS5LfvUXv
	ycIEM+67J6Qsj8/aeaK08t63n0vTIyfV/vRhWFuhxylztuFmsJdUruK7qfVvn1jU+GtfXBFs
	WWOx3fub/O/PJ1u3iliVTnYz+NZeqsPgqPH9Go/indpMvyu2OxbqJ/TJX0mWVWIpzkg01GIu
	Kk4EAIlchDYjAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The config enables already Samsung's PMIC-s MFD and regulator (S2MPS11
and S5M8767) drivers. Enable also drivers for the rest of these PMIC-s
features: clock and RTC.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/configs/exynos_defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
index e07a227ec0db..f69b86b650fa 100644
--- a/arch/arm/configs/exynos_defconfig
+++ b/arch/arm/configs/exynos_defconfig
@@ -109,7 +109,9 @@ CONFIG_MMC_DW_IDMAC=y
 CONFIG_MMC_DW_EXYNOS=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_S3C=y
+CONFIG_RTC_DRV_S5M=y
 CONFIG_COMMON_CLK_MAX77686=y
+CONFIG_COMMON_CLK_S2MPS11=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 CONFIG_EXT4_FS=y
-- 
1.9.1

