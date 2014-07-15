Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbaGORGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:06:12 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:64196 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967AbaGORCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:21 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Asadi <asadi.samuel@gmail.com>
Subject: [PATCH 90/94] Staging: comedi: 8253.h fixed by removing 'return' from generic func
Date: Tue, 15 Jul 2014 20:01:45 +0300
Message-Id: <1405443709-15288-90-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>

	modified:   drivers/staging/comedi/drivers/8253.h
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
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

