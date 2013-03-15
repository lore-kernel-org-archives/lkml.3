Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab3COIPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 04:15:09 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:64683 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab3COIPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 04:15:01 -0400
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: abbotti@mev.co.uk
Cc: fmhess@users.sourceforge.net, gregkh@linuxfoundation.org,
        hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: drivers: ni_atmio.c: Add a missing semicolon
Date: Fri, 15 Mar 2013 01:14:29 -0700
Message-Id: <1363335269-14903-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix a missing end-of-statement by adding a semicolon.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/staging/comedi/drivers/ni_atmio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_atmio.c b/drivers/staging/comedi/drivers/ni_atmio.c
index 279f2cd..37372a1 100644
--- a/drivers/staging/comedi/drivers/ni_atmio.c
+++ b/drivers/staging/comedi/drivers/ni_atmio.c
@@ -467,7 +467,7 @@ static int ni_atmio_attach(struct comedi_device *dev,
 		return -EIO;
 
 	dev->board_ptr = ni_boards + board;
-	boardtype = comedi_board(dev)
+	boardtype = comedi_board(dev);
 
 	printk(" %s", boardtype->name);
 	dev->board_name = boardtype->name;
-- 
1.7.9.5

