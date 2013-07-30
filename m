Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab3G3Jmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:42:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53292 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932550Ab3G3Jdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?J=C3=B3hann=20B=2E=20Gu=C3=B0mundsson?= 
	<johannbg@fedoraproject.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 076/106] USB: misc: Add Manhattan Hi-Speed USB DVI Converter to sisusbvga
Date: Tue, 30 Jul 2013 10:31:35 +0100
Message-Id: <1375176725-5825-77-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?J=C3=B3hann=20B=2E=20Gu=C3=B0mundsson?= <johannbg@gmail.com>

commit 58fc90db8261b571c026bb8bf23aad48a7233118 upstream.

Signed-off-by: Jóhann B. Guðmundsson <johannbg@fedoraproject.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/misc/sisusbvga/sisusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
index dd573ab..7af163d 100644
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
1.8.3.2

