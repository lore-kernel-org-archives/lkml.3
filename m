Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaKKP4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:56:49 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:42462 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaKKP4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:56:47 -0500
From: Johan Hovold <johan@kernel.org>
To: Paul Walmsley <paul@pwsan.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH] ARM: OMAP2+: clock: remove unused function prototype
Date: Tue, 11 Nov 2014 16:56:04 +0100
Message-Id: <1415721364-25749-1-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused function prototype that was left by commit 149c09d3a61d
("ARM: AM33xx: remove old clock data and link in new clock init code")
which removed the definition.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 arch/arm/mach-omap2/clock.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/mach-omap2/clock.h b/arch/arm/mach-omap2/clock.h
index 4592a2762592..c81d6cc41891 100644
--- a/arch/arm/mach-omap2/clock.h
+++ b/arch/arm/mach-omap2/clock.h
@@ -269,8 +269,6 @@ extern const struct clksel_rate div31_1to31_rates[];
 
 extern void __iomem *clk_memmaps[];
 
-extern int am33xx_clk_init(void);
-
 extern int omap2_clkops_enable_clkdm(struct clk_hw *hw);
 extern void omap2_clkops_disable_clkdm(struct clk_hw *hw);
 
-- 
2.0.4

