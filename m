Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab3GANXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 09:23:39 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:40857 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab3GANXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 09:23:37 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>, jimwall@q.com,
        brian@crystalfontz.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv4 1/8] ARM: mxs: Simplify detection of CrystalFontz boards
Date: Mon,  1 Jul 2013 15:23:22 +0200
Message-Id: <1372685009-15564-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372685009-15564-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1372685009-15564-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As all CrystalFontz boards are compatible with "crystalfontz,cfa10036", make it
easier to add future boards.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-mxs/mach-mxs.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm/mach-mxs/mach-mxs.c b/arch/arm/mach-mxs/mach-mxs.c
index 6298adb..1b8c274 100644
--- a/arch/arm/mach-mxs/mach-mxs.c
+++ b/arch/arm/mach-mxs/mach-mxs.c
@@ -478,10 +478,7 @@ static void __init mxs_machine_init(void)
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

