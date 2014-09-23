Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbaIWAX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 20:23:28 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:48327 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbaIWAX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 20:23:27 -0400
Date: Tue, 23 Sep 2014 09:21:38 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] staging: dgap: remove unused 'runwait' variable
Message-ID: <20140923002138.GA20763@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    1 -
 drivers/staging/dgap/dgap.h |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index db8ccd1..779d144 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -742,7 +742,6 @@ static struct board_t *dgap_found_board(struct pci_dev *pdev, int id,
 
 	spin_lock_init(&brd->bd_lock);
 
-	brd->runwait		= 0;
 	brd->inhibit_poller	= FALSE;
 	brd->wait_for_bios	= 0;
 	brd->wait_for_fep	= 0;
diff --git a/drivers/staging/dgap/dgap.h b/drivers/staging/dgap/dgap.h
index ba05c65..14e2ed0 100644
--- a/drivers/staging/dgap/dgap.h
+++ b/drivers/staging/dgap/dgap.h
@@ -572,7 +572,6 @@ struct board_t {
 	u8 __iomem	*re_map_port;	/* Remapped io port of the card */
 	u8 __iomem	*re_map_membase;/* Remapped memory of the card */
 
-	u8		runwait;	/* # Processes waiting for FEP  */
 	u8		inhibit_poller; /* Tells the poller to leave us alone */
 
 	struct channel_t *channels[MAXPORTS]; /* array of pointers to our */
-- 
1.7.1

