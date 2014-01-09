Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbaAIMfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:35:44 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:41188 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbaAIMfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:35:12 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: nicolas.ferre@atmel.com, b.brezillon@overkiz.com, arnd@arndb.de
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH v2 08/12] at91: sam9261: Add a clock definition for the smc
Date: Thu,  9 Jan 2014 13:31:45 +0100
Message-Id: <1389270709-32662-9-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389270709-32662-1-git-send-email-jjhiblot@traphandler.com>
References: <1389270709-32662-1-git-send-email-jjhiblot@traphandler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 arch/arm/mach-at91/at91sam9261.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index a67bfe6..cb5f906 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -205,6 +205,7 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID(NULL, "fffff400.gpio", &pioA_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fffff600.gpio", &pioB_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fffff800.gpio", &pioC_clk),
+	CLKDEV_CON_DEV_ID("smc", "ffffec00.smc", &mck),
 };
 
 static struct clk_lookup usart_clocks_lookups[] = {
-- 
1.8.5.2

