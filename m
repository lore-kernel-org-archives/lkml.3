Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734AbbAARqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 12:46:55 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:35236 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbbAARqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 12:46:53 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] mfd: db8500-prcmu:  Remove unused function
Date: Thu,  1 Jan 2015 18:49:53 +0100
Message-Id: <1420134593-690-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function prcmu_get_boot_status() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/mfd/db8500-prcmu.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 193cf16..b517501 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -675,15 +675,6 @@ bool prcmu_has_arm_maxopp(void)
 }
 
 /**
- * prcmu_get_boot_status - PRCMU boot status checking
- * Returns: the current PRCMU boot status
- */
-int prcmu_get_boot_status(void)
-{
-	return readb(tcdm_base + PRCM_BOOT_STATUS);
-}
-
-/**
  * prcmu_set_rc_a2p - This function is used to run few power state sequences
  * @val: Value to be set, i.e. transition requested
  * Returns: 0 on success, -EINVAL on invalid argument
-- 
1.7.10.4

