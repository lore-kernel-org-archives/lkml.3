Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636Ab3JJVnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 17:43:06 -0400
Received: from libra.uberspace.de ([95.143.172.171]:60043 "HELO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756844Ab3JJVln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 17:41:43 -0400
From: Matthias Beyer <mail@beyermatthias.de>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Beyer <mail@beyermatthias.de>
Subject: [PATCH 2/6] drivers: usb: core: file.c: moved asterisk to variable name
Date: Thu, 10 Oct 2013 23:41:28 +0200
Message-Id: <1381441292-6145-3-git-send-email-mail@beyermatthias.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381441292-6145-1-git-send-email-mail@beyermatthias.de>
References: <1381441292-6145-1-git-send-email-mail@beyermatthias.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
---
 drivers/usb/core/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/file.c b/drivers/usb/core/file.c
index 903c7ef..3bdfbf8 100644
--- a/drivers/usb/core/file.c
+++ b/drivers/usb/core/file.c
@@ -27,7 +27,7 @@
 static const struct file_operations *usb_minors[MAX_USB_MINORS];
 static DECLARE_RWSEM(minor_rwsem);
 
-static int usb_open(struct inode * inode, struct file * file)
+static int usb_open(struct inode *inode, struct file *file)
 {
 	int minor = iminor(inode);
 	const struct file_operations *c;
-- 
1.8.4

