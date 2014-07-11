Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbaGKKXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:23:36 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33105 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbaGKKXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:23:34 -0400
Date: Fri, 11 Jul 2014 19:22:21 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com
Cc: markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] staging: dgap: remove unused variable in dgap_param()
Message-ID: <20140711102221.GA22316@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "ts" is not used in dgap_param().

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 79ea116..ad7b462 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -5068,7 +5068,6 @@ static void dgap_firmware_reset_port(struct channel_t *ch)
  *=======================================================================*/
 static int dgap_param(struct tty_struct *tty)
 {
-	struct ktermios *ts;
 	struct board_t *bd;
 	struct channel_t *ch;
 	struct bs_t __iomem *bs;
@@ -5098,8 +5097,6 @@ static int dgap_param(struct tty_struct *tty)
 	if (!bs)
 		return -EIO;
 
-	ts = &tty->termios;
-
 	/*
 	 * If baud rate is zero, flush queues, and set mval to drop DTR.
 	 */
-- 
1.7.1

