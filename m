Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbaIALMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:12:31 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:38981 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbaIALEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:15 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/28] staging: comedi: amplc_pci230: don't use multiple blank lines
Date: Mon,  1 Sep 2014 12:03:34 +0100
Message-Id: <1409569440-10979-3-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch issues: "CHECK: Please don't use multiple blank lines".

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index d077254..09b392b 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -864,7 +864,6 @@ static int pci230_ai_rinsn(struct comedi_device *dev,
 	else
 		adccon |= PCI230_ADC_IR_UNI;
 
-
 	/*
 	 * Enable only this channel in the scan list - otherwise by default
 	 * we'll get one sample from each channel.
@@ -2295,7 +2294,6 @@ static int pci230_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	if (!get_resources(dev, res_mask, OWNER_AICMD))
 		return -EBUSY;
 
-
 	/* Get number of scans required. */
 	if (cmd->stop_src == TRIG_COUNT)
 		devpriv->ai_scan_count = cmd->stop_arg;
@@ -2487,7 +2485,6 @@ static irqreturn_t pci230_interrupt(int irq, void *d)
 	if (status_int == PCI230_INT_DISABLE)
 		return IRQ_NONE;
 
-
 	spin_lock_irqsave(&devpriv->isr_spinlock, irqflags);
 	valid_status_int = devpriv->int_en & status_int;
 	/*
-- 
2.0.4

