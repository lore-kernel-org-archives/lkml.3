Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab3CGMMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 07:12:54 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:49739 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab3CGMMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 07:12:49 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: peter@hurleysoftware.com, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/16] crisv10: remove unused members
Date: Thu,  7 Mar 2013 13:12:37 +0100
Message-Id: <1362658360-26629-13-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
References: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, all those are unused. They were perhaps copied from generic
serial structure ages ago. Remove them for good.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/serial/crisv10.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/tty/serial/crisv10.h b/drivers/tty/serial/crisv10.h
index 7146ed2..59f70c4 100644
--- a/drivers/tty/serial/crisv10.h
+++ b/drivers/tty/serial/crisv10.h
@@ -86,15 +86,10 @@ struct e100_serial {
 
 	volatile int		tr_running; /* 1 if output is running */
 
-	struct tty_struct	*tty;
-	int			read_status_mask;
-	int			ignore_status_mask;
 	int			x_char;	/* xon/xoff character */
 	int			close_delay;
 	unsigned short		closing_wait;
-	unsigned short		closing_wait2;
 	unsigned long		event;
-	unsigned long		last_active;
 	int			line;
 	int			type;  /* PORT_ETRAX */
 	int			count;	    /* # of fd on device */
@@ -108,7 +103,6 @@ struct e100_serial {
 	struct work_struct	work;
 	struct async_icount	icount;   /* error-statistics etc.*/
 	struct ktermios		normal_termios;
-	struct ktermios		callout_termios;
 	wait_queue_head_t	open_wait;
 	wait_queue_head_t	close_wait;
 
-- 
1.8.1.4


