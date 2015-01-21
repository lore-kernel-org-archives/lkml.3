Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbbAUKrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:47:20 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:47717 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbbAUKrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:47:10 -0500
Date: Wed, 21 Jan 2015 12:46:59 +0200
From: menna_tarek <mennatallah.dawood@gmail.com>
To: devel@driverdev.osuosl.org
Cc: lidza.louina@gmail.com, markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: dgnc: Fixing a warning of line over 80 characters
Message-ID: <20150121104659.GA7490@Menna-HP>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl warning:
WARNING: line over 80 characters

Signed-off-by: menna_tarek <mennatallah.dawood@gmail.com>
---
 drivers/staging/dgnc/dgnc_tty.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/dgnc/dgnc_tty.c b/drivers/staging/dgnc/dgnc_tty.c
index f81a375..f43a11b 100644
--- a/drivers/staging/dgnc/dgnc_tty.c
+++ b/drivers/staging/dgnc/dgnc_tty.c
@@ -1331,7 +1331,7 @@ static int dgnc_block_til_ready(struct tty_struct *tty, struct file *file, struc
 		spin_unlock_irqrestore(&ch->ch_lock, flags);
 
 		/*
-		 * Wait for something in the flags to change from the current value.
+		 * Wait for the flags to change from the current value.
 		 */
 		if (sleep_on_un_flags)
 			retval = wait_event_interruptible(un->un_flags_wait,
-- 
1.9.1

