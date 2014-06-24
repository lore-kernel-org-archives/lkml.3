Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaFXHeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 03:34:18 -0400
Received: from mail-ig0-f202.google.com ([209.85.213.202]:57620 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbaFXHeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 03:34:16 -0400
From: Ben Chan <benchan@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH staging-next] staging: gdm72xx: remove blank lines after an open brace
Date: Tue, 24 Jun 2014 00:34:14 -0700
Message-Id: <1403595254-10060-1-git-send-email-benchan@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch warning:

  CHECK: Blank lines aren't necessary after an open brace '{'

Signed-off-by: Ben Chan <benchan@chromium.org>
---
 drivers/staging/gdm72xx/gdm_usb.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index 78d6667..256059c 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -632,7 +632,6 @@ static void gdm_usb_disconnect(struct usb_interface *intf)
 	if (idProduct != EMERGENCY_PID &&
 	    bConfigurationValue != DOWNLOAD_CONF_VALUE &&
 	    (idProduct & B_DOWNLOAD) == 0) {
-
 		udev = phy_dev->priv_dev;
 		udev->usbdev = NULL;
 
@@ -710,10 +709,8 @@ static int k_mode_thread(void *arg)
 	int ret;
 
 	while (!k_mode_stop) {
-
 		spin_lock_irqsave(&k_lock, flags2);
 		while (!list_empty(&k_list)) {
-
 			udev = list_entry(k_list.next, struct usbwm_dev, list);
 			tx = &udev->tx;
 			rx = &udev->rx;
-- 
2.0.0.526.g5318336

