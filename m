Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbaHHLBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 07:01:35 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:50645 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbaHHLBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 07:01:34 -0400
From: Matthias Brugger <matthias.bgg@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, jslaby@suse.cz,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH] tty: fix typo in comment of tty_termios_encode_baud_rate
Date: Fri,  8 Aug 2014 13:01:21 +0200
Message-Id: <1407495681-23700-1-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 drivers/tty/tty_ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index 6fd60fe..cd1285c 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -402,7 +402,7 @@ void tty_termios_encode_baud_rate(struct ktermios *termios,
 
 #ifdef BOTHER
 	/* If the user asked for a precise weird speed give a precise weird
-	   answer. If they asked for a Bfoo speed they many have problems
+	   answer. If they asked for a Bfoo speed they may have problems
 	   digesting non-exact replies so fuzz a bit */
 
 	if ((termios->c_cflag & CBAUD) == BOTHER)
-- 
1.7.9.5

