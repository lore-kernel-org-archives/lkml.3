Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbaGCBbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 21:31:25 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:34075 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaGCBbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 21:31:24 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: tony@atomide.com
Cc: linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] omap16xx: Removes fixme no longer needed in ocpi_enable()
Date: Wed,  2 Jul 2014 21:31:19 -0400
Message-Id: <1404351079-5117-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the FIXME message above ocpi_enable being declared
for proper locking in this function. As of the current kernel
verisons there is no need for locking as only one driver uses
this function currently and therefore there is no need for real
locking requirements.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 arch/arm/mach-omap1/ocpi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-omap1/ocpi.c b/arch/arm/mach-omap1/ocpi.c
index 238170c..44a3d19 100644
--- a/arch/arm/mach-omap1/ocpi.c
+++ b/arch/arm/mach-omap1/ocpi.c
@@ -55,7 +55,6 @@ static struct clk *ocpi_ck;
 
 /*
  * Enables device access to OMAP buses via the OCPI bridge
- * FIXME: Add locking
  */
 int ocpi_enable(void)
 {
-- 
1.9.1

