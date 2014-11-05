Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaKERun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:50:43 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:51728 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751949AbaKERui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:50:38 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next v2 20/26] tty: Remove tty_unhangup() declaration
Date: Wed,  5 Nov 2014 12:13:03 -0500
Message-Id: <1415207589-15967-21-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
 <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty_unhangup() function is not defined.

Reviewed-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 include/linux/tty.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index 196c352..e33ea1a 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -435,7 +435,6 @@ extern int is_ignored(int sig);
 extern int tty_signal(int sig, struct tty_struct *tty);
 extern void tty_hangup(struct tty_struct *tty);
 extern void tty_vhangup(struct tty_struct *tty);
-extern void tty_unhangup(struct file *filp);
 extern int tty_hung_up_p(struct file *filp);
 extern void do_SAK(struct tty_struct *tty);
 extern void __do_SAK(struct tty_struct *tty);
-- 
2.1.3

