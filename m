Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934877AbaE2OMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:12:20 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59385 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933266AbaE2Ntc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 045/103] usb: qcserial: add Sierra Wireless MC73xx
Date: Thu, 29 May 2014 15:48:30 +0200
Message-Id: <47c41d33c7398409dbd677c353eff6bcf87da2f4.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 70a3615fc07c2330ed7c1e922f3c44f4a67c0762 upstream.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/qcserial.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 662235240f3f..1d1bc9b41337 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -136,6 +136,9 @@ static const struct usb_device_id id_table[] = {
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68a2, 0)},	/* Sierra Wireless MC7710 Device Management */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68a2, 2)},	/* Sierra Wireless MC7710 NMEA */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68a2, 3)},	/* Sierra Wireless MC7710 Modem */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68c0, 0)},	/* Sierra Wireless MC73xx Device Management */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68c0, 2)},	/* Sierra Wireless MC73xx NMEA */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68c0, 3)},	/* Sierra Wireless MC73xx Modem */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x901c, 0)},	/* Sierra Wireless EM7700 Device Management */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x901c, 2)},	/* Sierra Wireless EM7700 NMEA */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x901c, 3)},	/* Sierra Wireless EM7700 Modem */
-- 
1.9.3

