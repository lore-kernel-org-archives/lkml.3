Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaEIG6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 02:58:07 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:44784 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaEIG6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 02:58:05 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v3 1/3] ARM: integrator: drop CONFIG_COMMON_CLK_DEBUG
Date: Fri,  9 May 2014 12:27:47 +0530
Message-Id: <1399618669-6830-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399618669-6830-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1399618669-6830-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch drops CONFIG_COMMON_CLK_DEBUG option
as this config option is now obsolete.

CC: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 arch/arm/configs/integrator_defconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/configs/integrator_defconfig b/arch/arm/configs/integrator_defconfig
index 5bae195..c1f5adc 100644
--- a/arch/arm/configs/integrator_defconfig
+++ b/arch/arm/configs/integrator_defconfig
@@ -73,7 +73,6 @@ CONFIG_LEDS_TRIGGER_HEARTBEAT=y
 CONFIG_LEDS_TRIGGER_CPU=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_PL030=y
-CONFIG_COMMON_CLK_DEBUG=y
 CONFIG_EXT2_FS=y
 CONFIG_VFAT_FS=y
 CONFIG_TMPFS=y
-- 
1.7.9.5

