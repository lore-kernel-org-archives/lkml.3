Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbaFYPYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:24:14 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:46328 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515AbaFYPYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:24:13 -0400
MIME-Version: 1.0
Date: Wed, 25 Jun 2014 23:24:12 +0800
Message-ID: <CAJKoSVTGC+-v09aCDTV5HfnpDMVuPiGTe5-Y9TMu+2E+EzMotw@mail.gmail.com>
Subject: [PATCH 1/2] staging: wlan-ng/hfa384x_usb.c: remove return statements
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
WARNING: void function return statements are not generally useful

Signed-off-by: Quentin Lee <lee.rhapsody@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c
b/drivers/staging/wlan-ng/hfa384x_usb.c
index 98343ff7..07cee56 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -3705,6 +3705,7 @@ static void hfa384x_usbout_callback(struct urb *urb)
 		case -EPIPE:
 			{
 				hfa384x_t *hw = wlandev->priv;
+
 				netdev_warn(hw->wlandev->netdev,
 					    "%s tx pipe stalled: requesting reset\n",
 					    wlandev->netdev->name);
-- 
1.7.9.5
