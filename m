Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbaILPnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 11:43:40 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55609 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752215AbaILPnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 11:43:31 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2 7/8] ARM: at91: add sama5d4 support to sama5_defconfig
Date: Fri, 12 Sep 2014 17:43:06 +0200
Message-Id: <1410536587-24607-8-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410536587-24607-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1410536587-24607-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sama5d4 to sama5_defconfig to build kernel booting on both sama5d3 and
samad4.

Note that earlyprintk can only be working for one or the other.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/configs/sama5_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/sama5_defconfig b/arch/arm/configs/sama5_defconfig
index 96c15b775d57..c9089c927daf 100644
--- a/arch/arm/configs/sama5_defconfig
+++ b/arch/arm/configs/sama5_defconfig
@@ -19,6 +19,7 @@ CONFIG_MODULE_FORCE_UNLOAD=y
 CONFIG_ARCH_AT91=y
 CONFIG_SOC_SAM_V7=y
 CONFIG_SOC_SAMA5D3=y
+CONFIG_SOC_SAMA5D4=y
 CONFIG_MACH_SAMA5_DT=y
 CONFIG_AEABI=y
 CONFIG_UACCESS_WITH_MEMCPY=y
-- 
1.9.1

