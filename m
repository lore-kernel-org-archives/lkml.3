Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933309Ab3GDVud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 17:50:33 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:44594 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832Ab3GDVub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 17:50:31 -0400
From: "=?UTF-8?q?J=C3=B3hann=20B=2E=20Gu=C3=B0mundsson?=" 
	<johannbg@gmail.com>
To: Thomas Winischhofer <thomas@winischhofer.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?J=C3=B3hann=20B=2E=20Gu=C3=B0mundsson?= 
	<johannbg@fedoraproject.org>
Subject: [PATCH 1/1] Adding Manhattan Hi-Speed USB DVI Converter to sisusbvga
Date: Thu,  4 Jul 2013 21:47:52 +0000
Message-Id: <1372974472-1351-1-git-send-email-johannbg@fedoraproject.org>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jóhann B. Guðmundsson <johannbg@fedoraproject.org>
---
 drivers/usb/misc/sisusbvga/sisusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
index c21386e..de98906 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3247,6 +3247,7 @@ static const struct usb_device_id sisusb_table[] = {
 	{ USB_DEVICE(0x0711, 0x0903) },
 	{ USB_DEVICE(0x0711, 0x0918) },
 	{ USB_DEVICE(0x0711, 0x0920) },
+	{ USB_DEVICE(0x0711, 0x0950) },
 	{ USB_DEVICE(0x182d, 0x021c) },
 	{ USB_DEVICE(0x182d, 0x0269) },
 	{ }
-- 
1.8.1.4

