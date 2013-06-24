Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab3FXJKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 05:10:35 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:16235 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab3FXJKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 05:10:33 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Bo Shen <voice.shen@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3/3] ARM: at91/PMC: at91sam9n12 family has USB HS feature
Date: Mon, 24 Jun 2013 11:08:47 +0200
Message-ID: <a3b28f9041482ff60ed0b1b7a6f11d0b1beb5163.1372064763.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <cover.1372064763.git.nicolas.ferre@atmel.com>
References: <cover.1372064763.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/clock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
index 978de42..1b9bbba 100644
--- a/arch/arm/mach-at91/clock.c
+++ b/arch/arm/mach-at91/clock.c
@@ -88,6 +88,7 @@ EXPORT_SYMBOL_GPL(at91_pmc_base);
 #define cpu_has_udpfs()		(!(cpu_is_at91sam9rl() \
 				|| cpu_is_at91sam9g45() \
 				|| cpu_is_at91sam9x5() \
+				|| cpu_is_at91sam9n12() \
 				|| cpu_is_sama5d3()))
 
 #define cpu_has_plladiv2()	(cpu_is_at91sam9g45() \
-- 
1.8.2.2

