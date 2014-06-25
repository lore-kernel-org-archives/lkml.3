Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbaFYPfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:35:12 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:49648 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756886AbaFYPfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:35:10 -0400
MIME-Version: 1.0
Date: Wed, 25 Jun 2014 23:35:09 +0800
Message-ID: <CAJKoSVRLvPe+5tae=buV3j12L612tdaYAWMT303GO71NF-w27g@mail.gmail.com>
Subject: [PATCH 2/2] staging: wlan-ng/hfa384x_usb.c: remove return statements
 for void function
From: Cheng-Wei Lee <lee.rhapsody@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>,
        Avinash Kumar <avi.kp.137@gmail.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>
Cc: devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl issues in hfa384x_usb.c:
WARNING: Missing a blank line after declarations

Signed-off-by: Quentin Lee <lee.rhapsody@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c
b/drivers/staging/wlan-ng/hfa384x_usb.c
index 07cee56..99e2f2d 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -3533,7 +3533,7 @@ static void hfa384x_usbin_rx(wlandevice_t
*wlandev, struct sk_buff *skb)
 	}

 done:
-	return;
+	pr_debug("hfa384x_usbin_rx: done\n");
 }

 /*----------------------------------------------------------------
@@ -3643,8 +3643,6 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,

 	/* pass it back up */
 	prism2sta_ev_rx(wlandev, skb);
-
-	return;
 }

 /*----------------------------------------------------------------
-- 
1.7.9.5
