Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaLANZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:25:05 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:34524 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbaLANZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:25:02 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/4] ARM: at91/defconfig: add TCB PWM driver selection
Date: Mon, 1 Dec 2014 14:24:38 +0100
Message-ID: <bfbab2b9b949582b7ff52a2804b631536d861798.1417440150.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <eb931e7c5534cd949ba61307f0380826e62ceb2c.1417440150.git.nicolas.ferre@atmel.com>
References: <eb931e7c5534cd949ba61307f0380826e62ceb2c.1417440150.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the selection of the new PWM driver using TC Blocks. This driver is
useful so we enable it in both sama5 and at91_dt defconfig files.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/configs/at91_dt_defconfig | 1 +
 arch/arm/configs/sama5_defconfig   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm/configs/at91_dt_defconfig b/arch/arm/configs/at91_dt_defconfig
index 3b515c179487..cb6ec18ce68b 100644
--- a/arch/arm/configs/at91_dt_defconfig
+++ b/arch/arm/configs/at91_dt_defconfig
@@ -186,6 +186,7 @@ CONFIG_IIO=y
 CONFIG_AT91_ADC=y
 CONFIG_PWM=y
 CONFIG_PWM_ATMEL=y
+CONFIG_PWM_ATMEL_TCB=y
 CONFIG_EXT4_FS=y
 CONFIG_FANOTIFY=y
 CONFIG_VFAT_FS=y
diff --git a/arch/arm/configs/sama5_defconfig b/arch/arm/configs/sama5_defconfig
index d1a2ee5b7b50..b58fb32770a0 100644
--- a/arch/arm/configs/sama5_defconfig
+++ b/arch/arm/configs/sama5_defconfig
@@ -183,6 +183,7 @@ CONFIG_IIO=y
 CONFIG_AT91_ADC=y
 CONFIG_PWM=y
 CONFIG_PWM_ATMEL=y
+CONFIG_PWM_ATMEL_TCB=y
 CONFIG_EXT4_FS=y
 CONFIG_FANOTIFY=y
 CONFIG_VFAT_FS=y
-- 
2.1.3

