Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab3FXJJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 05:09:24 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:16081 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab3FXJJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 05:09:22 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Bo Shen <voice.shen@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 1/3] ARM: at91/PMC: sama5d3 family doesn't have a PLLB
Date: Mon, 24 Jun 2013 11:08:45 +0200
Message-ID: <f914b67ea7c5af4bf24e93f092b5c2e31fac01bc.1372064763.git.nicolas.ferre@atmel.com>
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
 arch/arm/mach-at91/clock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
index da84188..085a79d 100644
--- a/arch/arm/mach-at91/clock.c
+++ b/arch/arm/mach-at91/clock.c
@@ -75,7 +75,8 @@ EXPORT_SYMBOL_GPL(at91_pmc_base);
 #define cpu_has_pllb()		(!(cpu_is_at91sam9rl() \
 				|| cpu_is_at91sam9g45() \
 				|| cpu_is_at91sam9x5() \
-				|| cpu_is_at91sam9n12()))
+				|| cpu_is_at91sam9n12() \
+				|| cpu_is_sama5d3()))
 
 #define cpu_has_upll()		(cpu_is_at91sam9g45() \
 				|| cpu_is_at91sam9x5() \
-- 
1.8.2.2

