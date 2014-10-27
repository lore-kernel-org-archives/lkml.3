Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbaJ0XKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 19:10:10 -0400
Received: from down.free-electrons.com ([37.187.137.238]:55617 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752833AbaJ0XKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 19:10:02 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Sebastian Reichel <sre@kernel.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v2 6/8] ARM: at91: sam9: remove useless resource for rstc
Date: Tue, 28 Oct 2014 00:09:35 +0100
Message-Id: <1414451377-11053-7-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414451377-11053-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1414451377-11053-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RAMC resources are now unnecessary in the reset driver, remove them.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/at91sam9260.c | 5 -----
 arch/arm/mach-at91/at91sam9261.c | 5 -----
 arch/arm/mach-at91/at91sam9263.c | 5 -----
 3 files changed, 15 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index d5a6df9ce570..d1c97e025483 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -365,11 +365,6 @@ static struct resource rstc_resources[] = {
 		.end    = AT91SAM9260_BASE_RSTC + SZ_16 - 1,
 		.flags  = IORESOURCE_MEM,
 	},
-	[1] = {
-		.start  = AT91SAM9260_BASE_SDRAMC,
-		.end    = AT91SAM9260_BASE_SDRAMC + SZ_512 - 1,
-		.flags  = IORESOURCE_MEM,
-	},
 };
 
 static struct platform_device rstc_device = {
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index 1b23a023cca6..7a354d5a3d4c 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -324,11 +324,6 @@ static struct resource rstc_resources[] = {
 		.end    = AT91SAM9261_BASE_RSTC + SZ_16 - 1,
 		.flags  = IORESOURCE_MEM,
 	},
-	[1] = {
-		.start  = AT91SAM9261_BASE_SDRAMC,
-		.end    = AT91SAM9261_BASE_SDRAMC + SZ_512 - 1,
-		.flags  = IORESOURCE_MEM,
-	},
 };
 
 static struct platform_device rstc_device = {
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index 55c0c212fde1..1f7e7021ae83 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -347,11 +347,6 @@ static struct resource rstc_resources[] = {
 		.end    = AT91SAM9263_BASE_RSTC + SZ_16 - 1,
 		.flags  = IORESOURCE_MEM,
 	},
-	[1] = {
-		.start  = AT91SAM9263_BASE_SDRAMC0,
-		.end    = AT91SAM9263_BASE_SDRAMC0 + SZ_512 - 1,
-		.flags  = IORESOURCE_MEM,
-	},
 };
 
 static struct platform_device rstc_device = {
-- 
1.9.1

