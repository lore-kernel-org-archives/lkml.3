Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbaBRWy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:54:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51210 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbaBRWrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:47:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stefan Becker <schtefan@gmx.net>, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.13 26/40] [media] af9035: add ID [2040:f900] Hauppauge WinTV-MiniStick 2
Date: Tue, 18 Feb 2014 14:47:27 -0800
Message-Id: <20140218224434.074261680@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224433.337299968@linuxfoundation.org>
References: <20140218224433.337299968@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antti Palosaari <crope@iki.fi>

commit f2e4c5e004691dfe37d0e4b363296f28abdb9bc7 upstream.

Add USB ID [2040:f900] for Hauppauge WinTV-MiniStick 2.
Device is build upon IT9135 chipset.

Tested-by: Stefan Becker <schtefan@gmx.net>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/dvb-usb-v2/af9035.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1539,6 +1539,8 @@ static const struct usb_device_id af9035
 		&af9035_props, "TerraTec Cinergy T Stick Dual RC (rev. 2)", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_LEADTEK, 0x6a05,
 		&af9035_props, "Leadtek WinFast DTV Dongle Dual", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_HAUPPAUGE, 0xf900,
+		&af9035_props, "Hauppauge WinTV-MiniStick 2", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, af9035_id_table);


