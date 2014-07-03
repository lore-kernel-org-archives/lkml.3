Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973AbaGCKOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:14:36 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:59185 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964964AbaGCKOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 06:14:15 -0400
Date: Thu, 3 Jul 2014 19:13:06 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] staging: dgnc: removes unreachable code
Message-ID: <20140703101306.GA18967@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dgnc_tty_ioctl() cannot reach the end of function.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgnc/dgnc_tty.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_tty.c b/drivers/staging/dgnc/dgnc_tty.c
index f7409d9..c07ec74 100644
--- a/drivers/staging/dgnc/dgnc_tty.c
+++ b/drivers/staging/dgnc/dgnc_tty.c
@@ -3430,11 +3430,4 @@ static int dgnc_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 
 		return -ENOIOCTLCMD;
 	}
-
-	DGNC_UNLOCK(ch->ch_lock, lock_flags);
-
-	DPR_IOCTL(("dgnc_tty_ioctl end - cmd %s (%x), arg %lx\n",
-		dgnc_ioctl_name(cmd), cmd, arg));
-
-	return 0;
 }
-- 
1.7.1

