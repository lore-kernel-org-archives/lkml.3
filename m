Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaILJMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:12:36 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:52326 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934AbaILJLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:11:32 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: remove comedi_board()
Date: Fri, 12 Sep 2014 10:11:20 +0100
Message-Id: <1410513080-29968-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All calls to the inline function `comedi_board()` in "comedidev.h" have
been removed, so remove the function.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedidev.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index bda5304..7f4d7e5 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -269,11 +269,6 @@ struct comedi_device {
 	void (*close)(struct comedi_device *dev);
 };
 
-static inline const void *comedi_board(const struct comedi_device *dev)
-{
-	return dev->board_ptr;
-}
-
 /*
  * function prototypes
  */
-- 
2.1.0

