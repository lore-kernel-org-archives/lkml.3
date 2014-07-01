Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624AbaGAOOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:14:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35707 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932573AbaGAOOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:14:48 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 30/33] ARM: at91: move at91sam9263 SoC to the CCF
Date: Tue,  1 Jul 2014 16:12:39 +0200
Message-Id: <1404223962-30471-31-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the selection of AT91_USE_OLD_CLK when selecting
at91sam9263 SoC support. This will automatically enable COMMON_CLK_AT91
option and add support for at91 common clock implementation.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 461966d0ee4d..6cc6f7aebdae 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -138,7 +138,6 @@ config SOC_AT91SAM9263
 	select HAVE_AT91_DBGU1
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
-	select AT91_USE_OLD_CLK
 	select HAVE_AT91_USB_CLK
 
 config SOC_AT91SAM9RL
-- 
1.9.1

