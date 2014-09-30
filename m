Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbaI3Vht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:37:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60966 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaI3Vhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:37:46 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 066/103] USB: sisusb: add device id for Magic Control USB video
Date: Tue, 30 Sep 2014 14:31:11 -0700
Message-Id: <1412112708-27356-67-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Hemminger <stephen@networkplumber.org>

commit 5b6b80aeb21091ed3030b9b6aae597d81326f1aa upstream.

I have a j5 create (JUA210) USB 2 video device and adding it device id
to SIS USB video gets it to work.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/misc/sisusbvga/sisusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
index de98906..0aef801 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3248,6 +3248,7 @@ static const struct usb_device_id sisusb_table[] = {
 	{ USB_DEVICE(0x0711, 0x0918) },
 	{ USB_DEVICE(0x0711, 0x0920) },
 	{ USB_DEVICE(0x0711, 0x0950) },
+	{ USB_DEVICE(0x0711, 0x5200) },
 	{ USB_DEVICE(0x182d, 0x021c) },
 	{ USB_DEVICE(0x182d, 0x0269) },
 	{ }
-- 
1.9.1

