Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbbAARtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 12:49:23 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:50559 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbbAARtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 12:49:22 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: avr32: mach-at32ap: at32ap700x:  Remove unused function
Date: Thu,  1 Jan 2015 18:52:22 +0100
Message-Id: <1420134742-1142-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function set_ebi_sfr_bits() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/avr32/mach-at32ap/at32ap700x.c |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index 37b7560..d84516c 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -744,17 +744,6 @@ struct clk at32_hmatrix_clk = {
 	.users		= 1,
 };
 
-/*
- * Set bits in the HMATRIX Special Function Register (SFR) used by the
- * External Bus Interface (EBI). This can be used to enable special
- * features like CompactFlash support, NAND Flash support, etc. on
- * certain chipselects.
- */
-static inline void set_ebi_sfr_bits(u32 mask)
-{
-	hmatrix_sfr_set_bits(HMATRIX_SLAVE_EBI, mask);
-}
-
 /* --------------------------------------------------------------------
  *  Timer/Counter (TC)
  * -------------------------------------------------------------------- */
-- 
1.7.10.4

