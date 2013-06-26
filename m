Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab3FZOxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:53:20 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:48745 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab3FZOwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:52:41 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>, jimwall@q.com,
        brian@crystalfontz.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 1/3] ARM: mxs: Simplify detection of CrystalFontz boards
Date: Wed, 26 Jun 2013 16:52:25 +0200
Message-Id: <1372258347-18422-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372258347-18422-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1372258347-18422-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As all CrystalFontz boards are compatible with "crystalfontz,cfa10036", make it
easier to add future boards.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-mxs/mach-mxs.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm/mach-mxs/mach-mxs.c b/arch/arm/mach-mxs/mach-mxs.c
index 77280c6..8be23cb 100644
--- a/arch/arm/mach-mxs/mach-mxs.c
+++ b/arch/arm/mach-mxs/mach-mxs.c
@@ -363,10 +363,7 @@ static void __init mxs_machine_init(void)
 		imx28_evk_init();
 	else if (of_machine_is_compatible("bluegiga,apx4devkit"))
 		apx4devkit_init();
-	else if (of_machine_is_compatible("crystalfontz,cfa10037") ||
-		 of_machine_is_compatible("crystalfontz,cfa10049") ||
-		 of_machine_is_compatible("crystalfontz,cfa10055") ||
-		 of_machine_is_compatible("crystalfontz,cfa10057"))
+	else if (of_machine_is_compatible("crystalfontz,cfa10036"))
 		crystalfontz_init();
 
 	of_platform_populate(NULL, of_default_bus_match_table,
-- 
1.8.1.2

