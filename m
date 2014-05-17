Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbaEQBEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 21:04:14 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:56242 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbaEQBEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 21:04:13 -0400
From: Masaru Nomura <massa.nomura@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: dgnc: dgnc_tty: Remove a prohibited space
Date: Sat, 17 May 2014 02:04:10 +0100
Message-Id: <1400288650-9956-1-git-send-email-massa.nomura@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a prohibited space before a closed parenthesis of if statement
to meet kernel coding style.

Signed-off-by: Masaru Nomura <massa.nomura@gmail.com>
---
 drivers/staging/dgnc/dgnc_tty.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_tty.c b/drivers/staging/dgnc/dgnc_tty.c
index f0b17c3..13d7a14 100644
--- a/drivers/staging/dgnc/dgnc_tty.c
+++ b/drivers/staging/dgnc/dgnc_tty.c
@@ -1693,7 +1693,7 @@ static void dgnc_tty_close(struct tty_struct *tty, struct file *file)
 		/*
 		 * turn off print device when closing print device.
 		 */
-		if ((un->un_type == DGNC_PRINT) && (ch->ch_flags & CH_PRON) ) {
+		if ((un->un_type == DGNC_PRINT) && (ch->ch_flags & CH_PRON)) {
 			dgnc_wmove(ch, ch->ch_digi.digi_offstr,
 				(int) ch->ch_digi.digi_offlen);
 			ch->ch_flags &= ~CH_PRON;
@@ -1753,7 +1753,7 @@ static void dgnc_tty_close(struct tty_struct *tty, struct file *file)
 		/*
 		 * turn off print device when closing print device.
 		 */
-		if ((un->un_type == DGNC_PRINT) && (ch->ch_flags & CH_PRON) ) {
+		if ((un->un_type == DGNC_PRINT) && (ch->ch_flags & CH_PRON)) {
 			dgnc_wmove(ch, ch->ch_digi.digi_offstr,
 				(int) ch->ch_digi.digi_offlen);
 			ch->ch_flags &= ~CH_PRON;
@@ -1857,7 +1857,7 @@ static int dgnc_maxcps_room(struct tty_struct *tty, int bytes_available)
 	if (un->un_type != DGNC_PRINT)
 		return bytes_available;
 
-	if (ch->ch_digi.digi_maxcps > 0 && ch->ch_digi.digi_bufsize > 0 ) {
+	if (ch->ch_digi.digi_maxcps > 0 && ch->ch_digi.digi_bufsize > 0) {
 		int cps_limit = 0;
 		unsigned long current_time = jiffies;
 		unsigned long buffer_time = current_time +
-- 
1.7.9.5

