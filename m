Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750942AbaHQEZl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 00:25:41 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:47096 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaHQEZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 00:25:39 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 1/3] staging: comedi: addi_apci_1564: add whitespace to subdevice init
Date: Sat, 16 Aug 2014 23:25:16 -0500
Message-Id: <1408249516-32636-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For purely aesthetic purposes, add some whitespace to subdevice initialization.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/addi_apci_1564.c | 78 ++++++++++++-------------
 1 file changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index 16c02c8..ce82645 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -377,52 +377,52 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 
 	/*  Allocate and Initialise DI Subdevice Structures */
 	s = &dev->subdevices[0];
-	s->type = COMEDI_SUBD_DI;
-	s->subdev_flags = SDF_READABLE;
-	s->n_chan = 32;
-	s->maxdata = 1;
-	s->range_table = &range_digital;
-	s->insn_bits = apci1564_di_insn_bits;
+	s->type		= COMEDI_SUBD_DI;
+	s->subdev_flags	= SDF_READABLE;
+	s->n_chan	= 32;
+	s->maxdata	= 1;
+	s->range_table	= &range_digital;
+	s->insn_bits	= apci1564_di_insn_bits;
 
 	/*  Allocate and Initialise DO Subdevice Structures */
 	s = &dev->subdevices[1];
-	s->type = COMEDI_SUBD_DO;
-	s->subdev_flags = SDF_WRITEABLE;
-	s->n_chan = 32;
-	s->maxdata = 1;
-	s->range_table = &range_digital;
-	s->insn_bits = apci1564_do_insn_bits;
+	s->type		= COMEDI_SUBD_DO;
+	s->subdev_flags	= SDF_WRITEABLE;
+	s->n_chan	= 32;
+	s->maxdata	= 1;
+	s->range_table	= &range_digital;
+	s->insn_bits	= apci1564_do_insn_bits;
 
 	/* Change-Of-State (COS) interrupt subdevice */
 	s = &dev->subdevices[2];
 	if (dev->irq) {
 		dev->read_subdev = s;
-		s->type = COMEDI_SUBD_DI;
-		s->subdev_flags = SDF_READABLE | SDF_CMD_READ;
-		s->n_chan = 1;
-		s->maxdata = 1;
-		s->range_table = &range_digital;
-		s->len_chanlist = 1;
-		s->insn_config = apci1564_cos_insn_config;
-		s->insn_bits = apci1564_cos_insn_bits;
-		s->do_cmdtest = apci1564_cos_cmdtest;
-		s->do_cmd = apci1564_cos_cmd;
-		s->cancel = apci1564_cos_cancel;
+		s->type		= COMEDI_SUBD_DI;
+		s->subdev_flags	= SDF_READABLE | SDF_CMD_READ;
+		s->n_chan	= 1;
+		s->maxdata	= 1;
+		s->range_table	= &range_digital;
+		s->len_chanlist	= 1;
+		s->insn_config	= apci1564_cos_insn_config;
+		s->insn_bits	= apci1564_cos_insn_bits;
+		s->do_cmdtest	= apci1564_cos_cmdtest;
+		s->do_cmd	= apci1564_cos_cmd;
+		s->cancel	= apci1564_cos_cancel;
 	} else {
-		s->type = COMEDI_SUBD_UNUSED;
+		s->type		= COMEDI_SUBD_UNUSED;
 	}
 
 	/*  Allocate and Initialise Timer Subdevice Structures */
 	s = &dev->subdevices[3];
-	s->type = COMEDI_SUBD_TIMER;
-	s->subdev_flags = SDF_WRITEABLE;
-	s->n_chan = 1;
-	s->maxdata = 0;
-	s->len_chanlist = 1;
-	s->range_table = &range_digital;
-	s->insn_write = apci1564_timer_write;
-	s->insn_read = apci1564_timer_read;
-	s->insn_config = apci1564_timer_config;
+	s->type		= COMEDI_SUBD_TIMER;
+	s->subdev_flags	= SDF_WRITEABLE;
+	s->n_chan	= 1;
+	s->maxdata	= 0;
+	s->len_chanlist	= 1;
+	s->range_table	= &range_digital;
+	s->insn_write	= apci1564_timer_write;
+	s->insn_read	= apci1564_timer_read;
+	s->insn_config	= apci1564_timer_config;
 
 	/* Initialize the watchdog subdevice */
 	s = &dev->subdevices[4];
@@ -432,12 +432,12 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 
 	/* Initialize the diagnostic status subdevice */
 	s = &dev->subdevices[5];
-	s->type = COMEDI_SUBD_DI;
-	s->subdev_flags = SDF_READABLE;
-	s->n_chan = 2;
-	s->maxdata = 1;
-	s->range_table = &range_digital;
-	s->insn_bits = apci1564_diag_insn_bits;
+	s->type		= COMEDI_SUBD_DI;
+	s->subdev_flags	= SDF_READABLE;
+	s->n_chan	= 2;
+	s->maxdata	= 1;
+	s->range_table	= &range_digital;
+	s->insn_bits	= apci1564_diag_insn_bits;
 
 	return 0;
 }
-- 
2.0.4

