Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481AbaFZMQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 08:16:13 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60295 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409AbaFZMP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 08:15:59 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-24-53ac0ef6eca8
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
Subject: [PATCH RESEND 1/2] ARM: multi_v7_defconfig: Enable clock and RTC
 driver for S2M and S5M
Date: Thu, 26 Jun 2014 14:15:43 +0200
Message-id: <1403784944-12890-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNJMWRmVeSWpSXmKPExsVy+t/xq7rf+NYEG5y6YW3xd9IxdouNM9az
	Wrx+YWjRu+Aqm8XZpjfsFpseX2O1uLxrDpvFjPP7mCxuX+a1WHvkLrvFqeuf2SzWz3jN4sDj
	0dLcw+bx+9ckRo/NS+o9rpxoYvXo27KK0ePzJrkAtigum5TUnMyy1CJ9uwSujFPXO1gLjrNX
	3D5ygbGB8QRbFyMnh4SAicSrlg4WCFtM4sK99UBxLg4hgaWMEhemTGSCcPqYJGb+nQhWxSZg
	LLF5+RKwKhGBHYwSy+9dZgdxmAVWMkl8ODmJEaRKWCBJ4v/Dw0wgNouAqsSbBT1g+3gF3CWu
	X73PDrFPTuLkscmsExi5FzAyrGIUTS1NLihOSs810itOzC0uzUvXS87P3cQICbCvOxiXHrM6
	xCjAwajEw3sibHWwEGtiWXFl7iFGCQ5mJRFekd9AId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYy3
	Il02rXI6qC2ZEjc5RGSDP8s6GZl/M1uC+Gus+45qh3oHFkppKGhfvP1C3y0+brJsfeiZe+8m
	+9i8ELI2q/x0yrDki43CabsmnZ9Ptdn2HTzZvThQjSM27eg+A885PmxZc1MmHbBv9q4QeJE/
	zStad5nkvNyr8WyFc2ukNk2UZNp83tq3WYmlOCPRUIu5qDgRAFRJ8E0OAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The config enables already Samsung's PMIC-s MFD and regulator (S2MPS11
and S5M8767) drivers. Enable also drivers for the rest of these PMIC-s
features: clock and RTC.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/configs/multi_v7_defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index be1a3455a9fe..d578ebbc05a0 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -334,6 +334,7 @@ CONFIG_RTC_DRV_VT8500=y
 CONFIG_RTC_DRV_SUNXI=y
 CONFIG_RTC_DRV_MV=y
 CONFIG_RTC_DRV_TEGRA=y
+CONFIG_RTC_DRV_S5M=y
 CONFIG_DMADEVICES=y
 CONFIG_DW_DMAC=y
 CONFIG_MV_XOR=y
@@ -355,6 +356,7 @@ CONFIG_SERIO_NVEC_PS2=y
 CONFIG_NVEC_POWER=y
 CONFIG_QCOM_GSBI=y
 CONFIG_COMMON_CLK_QCOM=y
+CONFIG_COMMON_CLK_S2MPS11=y
 CONFIG_MSM_GCC_8660=y
 CONFIG_MSM_MMCC_8960=y
 CONFIG_MSM_MMCC_8974=y
-- 
1.9.1

