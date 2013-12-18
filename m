Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab3LRV2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:28:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284Ab3LRVNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Piko <michael@piko.com.au>, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.12 076/118] media: af9035: add [0413:6a05] Leadtek WinFast DTV Dongle Dual
Date: Wed, 18 Dec 2013 13:11:53 -0800
Message-Id: <20131218211221.600619918@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antti Palosaari <crope@iki.fi>

commit 0c413d10515feae02cee967b31bb8afea8aa0d29 upstream.

It is IT9135 dual design.
Thanks to Michael Piko for reporting that!

Reported-by: Michael Piko <michael@piko.com.au>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/dvb-usb-v2/af9035.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1534,6 +1534,8 @@ static const struct usb_device_id af9035
 	/* XXX: that same ID [0ccd:0099] is used by af9015 driver too */
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x0099,
 		&af9035_props, "TerraTec Cinergy T Stick Dual RC (rev. 2)", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_LEADTEK, 0x6a05,
+		&af9035_props, "Leadtek WinFast DTV Dongle Dual", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, af9035_id_table);


