Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab3JNTsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 15:48:21 -0400
Received: from libra.uberspace.de ([95.143.172.171]:59361 "HELO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756857Ab3JNTqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 15:46:54 -0400
From: Matthias Beyer <mail@beyermatthias.de>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Beyer <mail@beyermatthias.de>
Subject: [PATCH v2 1/5] drivers: usb: core: devio.c: Spaces to tabs for proc_reapurbnonblock()
Date: Mon, 14 Oct 2013 21:46:36 +0200
Message-Id: <1381780000-23327-2-git-send-email-mail@beyermatthias.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381780000-23327-1-git-send-email-mail@beyermatthias.de>
References: <20131014181214.GB6023@kroah.com>
 <1381780000-23327-1-git-send-email-mail@beyermatthias.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced spaces by tabs for proc_reapurbnonblock() function.

Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
---
 drivers/usb/core/devio.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 71dc5d7..6a2e567 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1636,14 +1636,14 @@ static int proc_reapurbnonblock(struct dev_state *ps, void __user *arg)
 static int proc_control_compat(struct dev_state *ps,
 				struct usbdevfs_ctrltransfer32 __user *p32)
 {
-        struct usbdevfs_ctrltransfer __user *p;
-        __u32 udata;
-        p = compat_alloc_user_space(sizeof(*p));
-        if (copy_in_user(p, p32, (sizeof(*p32) - sizeof(compat_caddr_t))) ||
-            get_user(udata, &p32->data) ||
+	struct usbdevfs_ctrltransfer __user *p;
+	__u32 udata;
+	p = compat_alloc_user_space(sizeof(*p));
+	if (copy_in_user(p, p32, (sizeof(*p32) - sizeof(compat_caddr_t))) ||
+	    get_user(udata, &p32->data) ||
 	    put_user(compat_ptr(udata), &p->data))
 		return -EFAULT;
-        return proc_control(ps, p);
+	return proc_control(ps, p);
 }
 
 static int proc_bulk_compat(struct dev_state *ps,
-- 
1.8.4

