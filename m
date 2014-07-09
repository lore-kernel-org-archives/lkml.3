Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbaGIHbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 03:31:13 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:60322 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbaGIHbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 03:31:11 -0400
Date: Wed, 9 Jul 2014 16:29:58 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com
Cc: markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging: dgap: remove redundant NULL check in
 dgap_tty_init()
Message-ID: <20140709072958.GA30050@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The brd is already checked by earlier function in dgap_init_one().

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 8e3fd87..b60995e 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -1363,9 +1363,6 @@ static int dgap_tty_init(struct board_t *brd)
 	struct cm_t __iomem *cm;
 	int ret;
 
-	if (!brd)
-		return -EIO;
-
 	/*
 	 * Initialize board structure elements.
 	 */
-- 
1.7.1

