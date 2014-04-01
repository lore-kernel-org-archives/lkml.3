Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbaDAQow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:44:52 -0400
Received: from ns3094689.ip-91-121-202.eu ([91.121.202.112]:50807 "EHLO
	ns3094689.ip-91-121-202.eu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751788AbaDAQot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:44:49 -0400
From: Denis Pithon <denis.pithon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: khoroshilov@ispras.ru, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv3 2/3] staging/wlan-ng: remove obsolete comments
Date: Tue,  1 Apr 2014 18:43:18 +0200
Message-Id: <1396370599-27618-2-git-send-email-denis.pithon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1396370599-27618-1-git-send-email-denis.pithon@gmail.com>
References: <20140331213431.GA31288@kroah.com>
 <1396370599-27618-1-git-send-email-denis.pithon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prism2sta_probe_usb() and prism2sta_disconnect_usb() header comments are
erroneous and useless. Removed.

Signed-off-by: Denis Pithon <denis.pithon@gmail.com>
---
 drivers/staging/wlan-ng/prism2usb.c | 40 -------------------------------------
 1 file changed, 40 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2usb.c b/drivers/staging/wlan-ng/prism2usb.c
index 9f2427c..613c312 100644
--- a/drivers/staging/wlan-ng/prism2usb.c
+++ b/drivers/staging/wlan-ng/prism2usb.c
@@ -56,27 +56,6 @@ static struct usb_device_id usb_prism_tbl[] = {
 };
 MODULE_DEVICE_TABLE(usb, usb_prism_tbl);
 
-/*----------------------------------------------------------------
-* prism2sta_probe_usb
-*
-* Probe routine called by the USB subsystem.
-*
-* Arguments:
-*	dev		ptr to the usb_device struct
-*	ifnum		interface number being offered
-*
-* Returns:
-*	NULL		- we're not claiming the device+interface
-*	non-NULL	- we are claiming the device+interface and
-*			  this is a ptr to the data we want back
-*			  when disconnect is called.
-*
-* Side effects:
-*
-* Call context:
-*	I'm not sure, assume it's interrupt.
-*
-----------------------------------------------------------------*/
 static int prism2sta_probe_usb(struct usb_interface *interface,
 			       const struct usb_device_id *id)
 {
@@ -152,25 +131,6 @@ done:
 	return result;
 }
 
-/*----------------------------------------------------------------
-* prism2sta_disconnect_usb
-*
-* Called when a device previously claimed by probe is removed
-* from the USB.
-*
-* Arguments:
-*	dev		ptr to the usb_device struct
-*	ptr		ptr returned by probe() when the device
-*                       was claimed.
-*
-* Returns:
-*	Nothing
-*
-* Side effects:
-*
-* Call context:
-*	process
-----------------------------------------------------------------*/
 static void prism2sta_disconnect_usb(struct usb_interface *interface)
 {
 	wlandevice_t *wlandev;
-- 
1.9.0

