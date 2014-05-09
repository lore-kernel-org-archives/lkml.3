Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaEIG6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 02:58:18 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:37795 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaEIG6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 02:58:13 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Olof Johansson <olof@lixom.net>, Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH v3 3/3] ARM: vt8500: drop CONFIG_COMMON_CLK_DEBUG
Date: Fri,  9 May 2014 12:27:49 +0530
Message-Id: <1399618669-6830-4-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399618669-6830-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1399618669-6830-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch drops CONFIG_COMMON_CLK_DEBUG option
as this config option is now obsolete.

CC: Olof Johansson <olof@lixom.net>
CC: Tony Prisk <linux@prisktech.co.nz>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 arch/arm/configs/vt8500_v6_v7_defconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/configs/vt8500_v6_v7_defconfig b/arch/arm/configs/vt8500_v6_v7_defconfig
index f052017..9e7a256 100644
--- a/arch/arm/configs/vt8500_v6_v7_defconfig
+++ b/arch/arm/configs/vt8500_v6_v7_defconfig
@@ -73,7 +73,6 @@ CONFIG_LEDS_TRIGGERS=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_VT8500=y
 CONFIG_DMADEVICES=y
-CONFIG_COMMON_CLK_DEBUG=y
 # CONFIG_IOMMU_SUPPORT is not set
 CONFIG_PWM=y
 CONFIG_PWM_VT8500=y
-- 
1.7.9.5

