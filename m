Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaAJEGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 23:06:44 -0500
Received: from nm30-vm1.bullet.mail.gq1.yahoo.com ([98.136.216.192]:37063 "EHLO
	nm30-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344AbaAJEGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 23:06:41 -0500
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jan 2014 23:06:41 EST
X-Yahoo-Newman-Id: 828182.28038.bm@smtp233.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: HzidybkVM1lqzT9kmsapuW3sqaUl00rSA865p679_tg7u1_
 8WB.5_fe9l7py29TdbS14RcjNim2PwhIbEskKnrUIC8SvQCwGx8J1feb0tus
 Fncz0pg.UgSr9avHcs92r9ctAxgCut._zv.3BSg6RbpaRMm_vA5FwAfZrpFa
 thdOY1xyCt1bZljFXg7Az6Mb3O3RRqCz8QrXeMw9LQ3Zq5rZ8.7FhcHpUOYR
 kYFX8XWMaxMul8gVGyFxEXNi6yR.vzPAoGxIgJVYCH_xecx9GVagCCaBdk8i
 N7cwIhDSD_5Y0ZtE0XM_3czQiyrdfzWhScaPnJofWRrvBO3.dphQP.UgEbXd
 V9TY2bZYdYb3KjbYRMTf4IwXNb_x..UyD_2VMwuOhNSJ_r.Amq_L8iumN._p
 HF2tO5raRq_encA0.xCef9ZTThvRWksMwFR63bY1nNZVulAeUlNHg_9HlDft
 IhorWOIagBW2gzmBkmp15UlMIKhUBxY076ZGPtqF4vLA2iRfQyVifbfLjHCk
 7HucEkeoRomvd_UCzx4qTmV1ZobmJxjjtQ68-
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.103.236.80 with plain [98.139.211.125])
        by smtp233.mail.gq1.yahoo.com with SMTP; 10 Jan 2014 03:59:47 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH] Staging: comedi: fix spacing coding style issue in 8255.c.
Date: Thu,  9 Jan 2014 21:59:41 -0600
Message-Id: <1389326381-8526-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch for 8255.c fixes a spacing warning found by checkpatch.pl.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
 drivers/staging/comedi/drivers/8255.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index b4009e8..48817f0 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -94,7 +94,7 @@ I/O port base address can be found in the output of 'lspci -v'.
 
 struct subdev_8255_private {
 	unsigned long iobase;
-	int (*io) (int, int, int, unsigned long);
+	int (*io)(int, int, int, unsigned long);
 };
 
 static int subdev_8255_io(int dir, int port, int data, unsigned long iobase)
@@ -262,7 +262,7 @@ static int subdev_8255_cancel(struct comedi_device *dev,
 }
 
 int subdev_8255_init(struct comedi_device *dev, struct comedi_subdevice *s,
-		     int (*io) (int, int, int, unsigned long),
+		     int (*io)(int, int, int, unsigned long),
 		     unsigned long iobase)
 {
 	struct subdev_8255_private *spriv;
@@ -289,7 +289,7 @@ int subdev_8255_init(struct comedi_device *dev, struct comedi_subdevice *s,
 EXPORT_SYMBOL_GPL(subdev_8255_init);
 
 int subdev_8255_init_irq(struct comedi_device *dev, struct comedi_subdevice *s,
-			 int (*io) (int, int, int, unsigned long),
+			 int (*io)(int, int, int, unsigned long),
 			 unsigned long iobase)
 {
 	int ret;
-- 
1.8.4.2

