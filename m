Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaDAQoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:44:55 -0400
Received: from ns3094689.ip-91-121-202.eu ([91.121.202.112]:50809 "EHLO
	ns3094689.ip-91-121-202.eu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751729AbaDAQot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:44:49 -0400
From: Denis Pithon <denis.pithon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: khoroshilov@ispras.ru, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv3 3/3] staging/wlan-ng: fix small coding style issues
Date: Tue,  1 Apr 2014 18:43:19 +0200
Message-Id: <1396370599-27618-3-git-send-email-denis.pithon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1396370599-27618-1-git-send-email-denis.pithon@gmail.com>
References: <20140331213431.GA31288@kroah.com>
 <1396370599-27618-1-git-send-email-denis.pithon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete some unneeded blank lines and add few ones to make checkpatch.pl
happy.

Signed-off-by: Denis Pithon <denis.pithon@gmail.com>
---
 drivers/staging/wlan-ng/prism2usb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2usb.c b/drivers/staging/wlan-ng/prism2usb.c
index 613c312..e92bbc1 100644
--- a/drivers/staging/wlan-ng/prism2usb.c
+++ b/drivers/staging/wlan-ng/prism2usb.c
@@ -96,7 +96,8 @@ static int prism2sta_probe_usb(struct usb_interface *interface,
 					   prism2_reset_settletime, 0);
 		if (result != 0) {
 			result = -EIO;
-			dev_err(&interface->dev, "hfa384x_corereset() failed.\n");
+			dev_err(&interface->dev,
+				"hfa384x_corereset() failed.\n");
 			goto failed_reset;
 		}
 	}
@@ -136,7 +137,6 @@ static void prism2sta_disconnect_usb(struct usb_interface *interface)
 	wlandevice_t *wlandev;
 
 	wlandev = (wlandevice_t *) usb_get_intfdata(interface);
-
 	if (wlandev != NULL) {
 		LIST_HEAD(cleanlist);
 		struct list_head *entry;
@@ -228,6 +228,7 @@ static int prism2sta_suspend(struct usb_interface *interface,
 {
 	hfa384x_t *hw = NULL;
 	wlandevice_t *wlandev;
+
 	wlandev = (wlandevice_t *) usb_get_intfdata(interface);
 	if (!wlandev)
 		return -ENODEV;
@@ -250,6 +251,7 @@ static int prism2sta_resume(struct usb_interface *interface)
 	int result = 0;
 	hfa384x_t *hw = NULL;
 	wlandevice_t *wlandev;
+
 	wlandev = (wlandevice_t *) usb_get_intfdata(interface);
 	if (!wlandev)
 		return -ENODEV;
-- 
1.9.0

