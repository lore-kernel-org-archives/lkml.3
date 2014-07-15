Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbaGODN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 23:13:28 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:46944 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaGODN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 23:13:26 -0400
From: sam-the-6 <asadi.samuel@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Asadi <asadi.samuel@gmail.com>
Subject: [PATCH 91/93] Staging: comedi: 8253.h fixed by removing 'return' from generic func
Date: Tue, 15 Jul 2014 06:13:19 +0300
Message-Id: <1405393999-25927-1-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Asadi <asadi.samuel@gmail.com>

Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>

	modified:   drivers/staging/comedi/drivers/8253.h
---
 drivers/staging/comedi/drivers/8253.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8253.h b/drivers/staging/comedi/drivers/8253.h
index 5829b46..f6b8607 100644
--- a/drivers/staging/comedi/drivers/8253.h
+++ b/drivers/staging/comedi/drivers/8253.h
@@ -55,7 +55,7 @@ static inline void i8253_cascade_ns_to_timer(int i8253_osc_base,
 	    /* check for overflow */
 	    divider > div1 && divider > div2 &&
 	    divider * i8253_osc_base > divider &&
-	    divider * i8253_osc_base > i8253_osc_base) {
+	    divider * i8253_osc_base > i8253_osc_base)	{
 		return;
 	}
 
@@ -118,7 +118,6 @@ static inline void i8253_cascade_ns_to_timer(int i8253_osc_base,
 	/*  masking is done since counter maps zero to 0x10000 */
 	*d1 = div1 & 0xffff;
 	*d2 = div2 & 0xffff;
-	return;
 }
 
 #ifndef CMDTEST
-- 
1.7.10.4

