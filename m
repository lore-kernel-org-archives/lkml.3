Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaFMO6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 10:58:18 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:57731 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbaFMO6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 10:58:14 -0400
MIME-Version: 1.0
Date: Fri, 13 Jun 2014 22:58:14 +0800
Message-ID: <CAJKoSVTafxWR3eLO=tLv1VSrdyuAp_-eEJWCGBJ+zTRqcp=VVw@mail.gmail.com>
Subject: [PATCH] staging: wlan-ng: fix Missing a blank line after declarations warnings
From: Cheng-Wei Lee <lee.rhapsody@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>,
        Avinash Kumar <avi.kp.137@gmail.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Quentin Lee <lee.rhapsody@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c
b/drivers/staging/wlan-ng/hfa384x_usb.c
index 98343ff7..b87cd6b 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -3533,7 +3533,6 @@ static void hfa384x_usbin_rx(wlandevice_t
*wlandev, struct sk_buff *skb)
 	}

 done:
-	return;
 }

 /*----------------------------------------------------------------
@@ -3643,8 +3642,6 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,

 	/* pass it back up */
 	prism2sta_ev_rx(wlandev, skb);
-
-	return;
 }

 /*----------------------------------------------------------------
@@ -3705,6 +3702,7 @@ static void hfa384x_usbout_callback(struct urb *urb)
 		case -EPIPE:
 			{
 				hfa384x_t *hw = wlandev->priv;
+
 				netdev_warn(hw->wlandev->netdev,
 					    "%s tx pipe stalled: requesting reset\n",
 					    wlandev->netdev->name);
-- 
1.7.9.5
