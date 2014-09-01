Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaIADgE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 23:36:04 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:43979 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbaIADgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 23:36:03 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH] staging: comedi: hwdrv_apci035: remove useless return statement
Date: Sun, 31 Aug 2014 22:35:49 -0500
Message-Id: <1409542549-27350-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checkpatch pointed out a void function with a return statement.  It can be
removed.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
index cad33f1..53bb51b 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
@@ -477,6 +477,4 @@ static void apci035_interrupt(int irq, void *d)
 		/*  send signal to the sample */
 		send_sig(SIGIO, devpriv->tsk_Current, 0);
 	}
-
-	return;
 }
-- 
2.1.0

