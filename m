Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbaLUNa0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 08:30:26 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:52143 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbaLUNaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 08:30:24 -0500
From: Jeremiah Mahler <jmmahler@gmail.com>
To: trivial@kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH 2/2] doc: usbmon: fix spelling s/unpriviledged/unprivileged/
Date: Sun, 21 Dec 2014 05:30:04 -0800
Message-Id: <1419168604-2266-1-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
---
 Documentation/usb/usbmon.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/usb/usbmon.txt b/Documentation/usb/usbmon.txt
index be2ccb9..28425f7 100644
--- a/Documentation/usb/usbmon.txt
+++ b/Documentation/usb/usbmon.txt
@@ -231,7 +231,7 @@ number. Number zero (/dev/usbmon0) is special and means "all buses".
 Note that specific naming policy is set by your Linux distribution.
 
 If you create /dev/usbmon0 by hand, make sure that it is owned by root
-and has mode 0600. Otherwise, unpriviledged users will be able to snoop
+and has mode 0600. Otherwise, unprivileged users will be able to snoop
 keyboard traffic.
 
 The following ioctl calls are available, with MON_IOC_MAGIC 0x92:
-- 
2.1.4

