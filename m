Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbaKER06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:26:58 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:40560 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755338AbaKER0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:26:55 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 3/9] tty: Remove defunct pcxe_open() declaration
Date: Wed,  5 Nov 2014 12:26:26 -0500
Message-Id: <1415208392-16189-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415208392-16189-1-git-send-email-peter@hurleysoftware.com>
References: <1415208392-16189-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcxe_open() has no definition in mainline; remove declaration.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 include/linux/tty.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index f6835ea..97cfb31 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -621,10 +621,6 @@ extern long n_tty_compat_ioctl_helper(struct tty_struct *tty, struct file *file,
 
 extern void serial_console_init(void);
 
-/* pcxx.c */
-
-extern int pcxe_open(struct tty_struct *tty, struct file *filp);
-
 /* vt.c */
 
 extern int vt_ioctl(struct tty_struct *tty,
-- 
2.1.3

