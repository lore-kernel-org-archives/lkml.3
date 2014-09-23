Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbaIWCkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:40:03 -0400
Received: from mail.kernel.org ([198.145.19.201]:38325 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176AbaIWCj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:39:59 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 27/45] USB: sisusb: add device id for Magic Control USB video
Date: Tue, 23 Sep 2014 10:31:29 +0800
Message-Id: <1411439507-30391-27-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit 5b6b80aeb21091ed3030b9b6aae597d81326f1aa upstream.

I have a j5 create (JUA210) USB 2 video device and adding it device id
to SIS USB video gets it to work.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/misc/sisusbvga/sisusb.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
index 7af163d..f1bfd01 100644
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
1.7.9.5

