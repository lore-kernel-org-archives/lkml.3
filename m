Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759917Ab3CGWJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 17:09:00 -0500
Received: from mail-ye0-f169.google.com ([209.85.213.169]:54008 "EHLO
	mail-ye0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758733Ab3CGWI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 17:08:58 -0500
From: Steve Conklin <sconklin@canonical.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: serial: Add Rigblaster Advantage to device table
Date: Thu,  7 Mar 2013 16:01:19 -0600
Message-Id: <1362693679-30458-1-git-send-email-sconklin@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Rigblaster Advantage is an amateur radio interface sold by West Mountain Radio. It contains a cp210x serial interface but the device ID is not in the driver.

Signed-off-by: Steve Conklin <sconklin@canonical.com>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index edc0f0d..78721ba 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -85,6 +85,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x10C4, 0x813F) }, /* Tams Master Easy Control */
 	{ USB_DEVICE(0x10C4, 0x814A) }, /* West Mountain Radio RIGblaster P&P */
 	{ USB_DEVICE(0x10C4, 0x814B) }, /* West Mountain Radio RIGtalk */
+	{ USB_DEVICE(0x2405, 0x0003) }, /* West Mountain Radio RIGblaster Advantage */
 	{ USB_DEVICE(0x10C4, 0x8156) }, /* B&G H3000 link cable */
 	{ USB_DEVICE(0x10C4, 0x815E) }, /* Helicomm IP-Link 1220-DVM */
 	{ USB_DEVICE(0x10C4, 0x815F) }, /* Timewave HamLinkUSB */
-- 
1.7.9.5

