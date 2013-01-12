Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab3ALEBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 23:01:40 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:63517 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab3ALEBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 23:01:39 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH 2/2] tty: cleanup checkpatch warning in pty.c
Date: Sat, 12 Jan 2013 05:01:22 +0100
Message-Id: <1357963283-20119-2-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357963283-20119-1-git-send-email-dinggnu@gmail.com>
References: <1357963283-20119-1-git-send-email-dinggnu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spaces are used for indent in 3 places of tty/pty.c, we change it to tab.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/tty/pty.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 64fcbdb..358a5fe 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -55,9 +55,9 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
 		set_bit(TTY_OTHER_CLOSED, &tty->flags);
 #ifdef CONFIG_UNIX98_PTYS
 		if (tty->driver == ptm_driver) {
-		        mutex_lock(&devpts_mutex);
+			mutex_lock(&devpts_mutex);
 			devpts_pty_kill(tty->link->driver_data);
-		        mutex_unlock(&devpts_mutex);
+			mutex_unlock(&devpts_mutex);
 		}
 #endif
 		tty_unlock(tty);
@@ -661,7 +661,7 @@ static const struct tty_operations pty_unix98_ops = {
  *	Allocate a unix98 pty master device from the ptmx driver.
  *
  *	Locking: tty_mutex protects the init_dev work. tty->count should
- * 		protect the rest.
+ *		protect the rest.
  *		allocated_ptys_lock handles the list of free pty numbers
  */
 
-- 
1.7.10.4

