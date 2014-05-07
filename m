Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711AbaEGUcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 16:32:45 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:43387 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaEGUcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 16:32:41 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Bastian Hecht <hechtb+renesas@gmail.com>, linux-sh@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 1/3] ARM: shmobile: r8a7740: Correct name of DT Ethernet clock
Date: Wed,  7 May 2014 22:32:28 +0200
Message-Id: <1399494750-31996-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The preferred node name in DT for an Ethernet device is "ethernet".
"sh-eth" was used in preliminary and incomplete bindings.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
This clock lookup entry should be removed after the conversion to CCF is
integrated.

 arch/arm/mach-shmobile/clock-r8a7740.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-shmobile/clock-r8a7740.c b/arch/arm/mach-shmobile/clock-r8a7740.c
index dd989f93498f..433ec674ead1 100644
--- a/arch/arm/mach-shmobile/clock-r8a7740.c
+++ b/arch/arm/mach-shmobile/clock-r8a7740.c
@@ -596,7 +596,7 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_DEV_ID("sh_mmcif",		&mstp_clks[MSTP312]),
 	CLKDEV_DEV_ID("e6bd0000.mmc",		&mstp_clks[MSTP312]),
 	CLKDEV_DEV_ID("r8a7740-gether",		&mstp_clks[MSTP309]),
-	CLKDEV_DEV_ID("e9a00000.sh-eth",	&mstp_clks[MSTP309]),
+	CLKDEV_DEV_ID("e9a00000.ethernet",	&mstp_clks[MSTP309]),
 	CLKDEV_DEV_ID("renesas-tpu-pwm",	&mstp_clks[MSTP304]),
 	CLKDEV_DEV_ID("e6600000.pwm",		&mstp_clks[MSTP304]),
 
-- 
1.7.9.5

