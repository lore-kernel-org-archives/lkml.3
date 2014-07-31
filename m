Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaGaNsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:48:17 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:57855 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbaGaNsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:48:08 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/18] staging: comedi: amplc_pci224: blank lines aren't necessary before a close brace '}'
Date: Thu, 31 Jul 2014 14:47:40 +0100
Message-Id: <1406814475-5923-4-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
References: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch issues: "CHECK: Blank lines aren't necessary before a
close brace '}'".

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci224.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index 6a570ef..e34bc5e 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -557,7 +557,6 @@ static void pci224_ao_handle_fifo(struct comedi_device *dev,
 		/* Fixed number of scans. */
 		if (num_scans > devpriv->ao_stop_count)
 			num_scans = devpriv->ao_stop_count;
-
 	}
 
 	/* Determine how much room is in the FIFO (in samples). */
@@ -644,7 +643,6 @@ static void pci224_ao_handle_fifo(struct comedi_device *dev,
 				trig = PCI224_DACCON_TRIG_EXTN;
 			else
 				trig = PCI224_DACCON_TRIG_EXTP;
-
 		}
 		devpriv->daccon = COMBINE(devpriv->daccon, trig,
 					  PCI224_DACCON_TRIG_MASK);
@@ -908,7 +906,6 @@ static int pci224_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		for (j = 0; j < cmd->chanlist_len; j++) {
 			if (CR_CHAN(cmd->chanlist[j]) < ch)
 				rank++;
-
 		}
 		devpriv->ao_scan_order[rank] = i;
 	}
@@ -1002,7 +999,6 @@ pci224_ao_munge(struct comedi_device *dev, struct comedi_subdevice *s,
 	/* Munge the data. */
 	for (i = 0; i < length; i++)
 		array[i] = (array[i] << shift) - offset;
-
 }
 
 /*
@@ -1038,11 +1034,9 @@ static irqreturn_t pci224_interrupt(int irq, void *d)
 					pci224_ao_start(dev, s);
 				else if (cmd->stop_src == TRIG_EXT)
 					pci224_ao_stop(dev, s);
-
 			}
 			if (valid_intstat & PCI224_INTR_DAC)
 				pci224_ao_handle_fifo(dev, s);
-
 		}
 		/* Reenable interrupt sources. */
 		spin_lock_irqsave(&devpriv->ao_spinlock, flags);
-- 
2.0.0

