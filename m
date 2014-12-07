Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaLGBQt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 20:16:49 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:65083 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbaLGBQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 20:16:48 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] arch: arm: mach-mxs: mach-mxs.c:  Remove unused function
Date: Sun,  7 Dec 2014 02:19:27 +0100
Message-Id: <1417915167-8750-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function __mxs_togl() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/arm/mach-mxs/mach-mxs.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/mach-mxs/mach-mxs.c b/arch/arm/mach-mxs/mach-mxs.c
index 2e7cec8..3362f48 100644
--- a/arch/arm/mach-mxs/mach-mxs.c
+++ b/arch/arm/mach-mxs/mach-mxs.c
@@ -72,11 +72,6 @@ static inline void __mxs_clrl(u32 mask, void __iomem *reg)
 	__raw_writel(mask, reg + MXS_CLR_ADDR);
 }
 
-static inline void __mxs_togl(u32 mask, void __iomem *reg)
-{
-	__raw_writel(mask, reg + MXS_TOG_ADDR);
-}
-
 #define OCOTP_WORD_OFFSET		0x20
 #define OCOTP_WORD_COUNT		0x20
 
-- 
1.7.10.4

