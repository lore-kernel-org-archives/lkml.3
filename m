Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaAFJI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 04:08:56 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:53514 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaAFJIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 04:08:50 -0500
X-Greylist: delayed 458 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jan 2014 04:08:50 EST
From: Aruna-Hewapathirane <aruna.hewapathirane@gmail.com>
To: abbotti@mev.co.uk
Cc: hsweeten@visionengravers.com, gregkh@linuxfoundation.org,
        peterhuewe@gmx.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Aruna-Hewapathirane <aruna.hewapathirane@gmail.com>
Subject: [PATCH] Staging: comedi: fixed style issue Fixed a coding style issue Signed-off-by: Aruna Hewapathirane <aruna.hewapathirane@gmail.com>
Date: Mon,  6 Jan 2014 04:00:39 -0500
Message-Id: <1388998839-28799-1-git-send-email-aruna.hewapathirane@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/comedi/drivers/ke_counter.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ke_counter.c b/drivers/staging/comedi/drivers/ke_counter.c
index 15589f6..cebf818 100644
--- a/drivers/staging/comedi/drivers/ke_counter.c
+++ b/drivers/staging/comedi/drivers/ke_counter.c
@@ -105,7 +105,7 @@ static int cnt_auto_attach(struct comedi_device *dev,
 	dev->read_subdev = s;
 	s->type = COMEDI_SUBD_COUNTER;
-	s->subdev_flags = SDF_READABLE /* | SDF_COMMON */ ;
+	s->subdev_flags = SDF_READABLE /* | SDF_COMMON */;
 	s->n_chan = 3;
 	s->maxdata = 0x00ffffff;
 	s->insn_read = cnt_rinsn;
@@ -120,7 +120,7 @@ static int cnt_auto_attach(struct comedi_device *dev,
 	outb(0, dev->iobase + 0x40);
 	dev_info(dev->class_dev, "%s: %s attached\n",
-		dev->driver->driver_name, dev->board_name);
+	dev->driver->driver_name, dev->board_name);
 	return 0;
 }
--
1.7.0.4

