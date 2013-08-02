Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964779Ab3HBKEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:04:14 -0400
Received: from up.free-electrons.com ([94.23.35.102]:58772 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758282Ab3HBKEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:04:12 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv2 1/9] ARM: sunxi: Introduce Allwinner A20 support
Date: Fri,  2 Aug 2013 12:02:45 +0200
Message-Id: <1375437773-3211-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1375437773-3211-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1375437773-3211-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A20 is a dual-core Cortex-A7-based SoC. It is
pin-compatible with the A10, and re-uses most of the IPs found in it,
plus some additional ones like a Gigabit Ethernet controller.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-sunxi/sunxi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
index 19bcc96..b9b2db6 100644
--- a/arch/arm/mach-sunxi/sunxi.c
+++ b/arch/arm/mach-sunxi/sunxi.c
@@ -134,6 +134,7 @@ static const char * const sunxi_board_dt_compat[] = {
 	"allwinner,sun5i-a10s",
 	"allwinner,sun5i-a13",
 	"allwinner,sun6i-a31",
+	"allwinner,sun7i-a20",
 	NULL,
 };
 
-- 
1.8.3.4

