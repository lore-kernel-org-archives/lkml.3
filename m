Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933343Ab3JKUVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:21:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207Ab3JKTks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:40:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        David Herrmann <dh.herrmann@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [ 107/110] HID: uhid: add devname module alias
Date: Fri, 11 Oct 2013 12:39:27 -0700
Message-Id: <20131011193819.429854878@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193807.584188672@linuxfoundation.org>
References: <20131011193807.584188672@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcel Holtmann <marcel@holtmann.org>

commit 60cbd53e4bf623fe978e6f23a6da642e730fde3a upstream.

For simple device node creation, add the devname module alias.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/uhid.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -659,3 +659,4 @@ module_exit(uhid_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("David Herrmann <dh.herrmann@gmail.com>");
 MODULE_DESCRIPTION("User-space I/O driver support for HID subsystem");
+MODULE_ALIAS("devname:" UHID_NAME);


