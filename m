Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750930Ab3JNTrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 15:47:01 -0400
Received: from libra.uberspace.de ([95.143.172.171]:59371 "HELO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757257Ab3JNTq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 15:46:56 -0400
From: Matthias Beyer <mail@beyermatthias.de>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Beyer <mail@beyermatthias.de>
Subject: [PATCH v2 2/5] drivers: usb: core: devio.c: Spaces to tabs for proc_control_compat()
Date: Mon, 14 Oct 2013 21:46:37 +0200
Message-Id: <1381780000-23327-3-git-send-email-mail@beyermatthias.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381780000-23327-1-git-send-email-mail@beyermatthias.de>
References: <20131014181214.GB6023@kroah.com>
 <1381780000-23327-1-git-send-email-mail@beyermatthias.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced spaces by tabs for proc_control_compat() function.

Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
---
 drivers/usb/core/devio.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 6a2e567..d15aa51 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1649,19 +1649,19 @@ static int proc_control_compat(struct dev_state *ps,
 static int proc_bulk_compat(struct dev_state *ps,
 			struct usbdevfs_bulktransfer32 __user *p32)
 {
-        struct usbdevfs_bulktransfer __user *p;
-        compat_uint_t n;
-        compat_caddr_t addr;
+	struct usbdevfs_bulktransfer __user *p;
+	compat_uint_t n;
+	compat_caddr_t addr;
 
-        p = compat_alloc_user_space(sizeof(*p));
+	p = compat_alloc_user_space(sizeof(*p));
 
-        if (get_user(n, &p32->ep) || put_user(n, &p->ep) ||
-            get_user(n, &p32->len) || put_user(n, &p->len) ||
-            get_user(n, &p32->timeout) || put_user(n, &p->timeout) ||
-            get_user(addr, &p32->data) || put_user(compat_ptr(addr), &p->data))
-                return -EFAULT;
+	if (get_user(n, &p32->ep) || put_user(n, &p->ep) ||
+	    get_user(n, &p32->len) || put_user(n, &p->len) ||
+	    get_user(n, &p32->timeout) || put_user(n, &p->timeout) ||
+	    get_user(addr, &p32->data) || put_user(compat_ptr(addr), &p->data))
+		return -EFAULT;
 
-        return proc_bulk(ps, p);
+	return proc_bulk(ps, p);
 }
 static int proc_disconnectsignal_compat(struct dev_state *ps, void __user *arg)
 {
-- 
1.8.4

