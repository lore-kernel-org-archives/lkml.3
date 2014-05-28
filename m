Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbaE1Mwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 08:52:53 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33944 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaE1Mww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 08:52:52 -0400
Date: Wed, 28 May 2014 14:52:45 +0200
From: Robin Schroer <sulamiification@gmail.com>
To: gregkh@linuxfoundation.org
Cc: d@teklibre.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging/frontier/tranzport: coding style fixes
Message-ID: <20140528125245.GA20824@shodan.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

added newlines after declarations in two places

Signed-off-by: Robin Schroer <sulamiification@gmail.com>
---
 drivers/staging/frontier/tranzport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/frontier/tranzport.c b/drivers/staging/frontier/tranzport.c
index 334ba04..2f86163 100644
--- a/drivers/staging/frontier/tranzport.c
+++ b/drivers/staging/frontier/tranzport.c
@@ -475,6 +475,7 @@ static unsigned int usb_tranzport_poll(struct file *file, poll_table *wait)
 {
 	struct usb_tranzport *dev;
 	unsigned int mask = 0;
+
 	dev = file->private_data;
 	poll_wait(file, &dev->read_wait, wait);
 	poll_wait(file, &dev->write_wait, wait);
@@ -937,6 +938,7 @@ static void usb_tranzport_disconnect(struct usb_interface *intf)
 {
 	struct usb_tranzport *dev;
 	int minor;
+
 	mutex_lock(&disconnect_mutex);
 	dev = usb_get_intfdata(intf);
 	usb_set_intfdata(intf, NULL);
-- 
1.9.3

