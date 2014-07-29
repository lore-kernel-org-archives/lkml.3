Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbaG2MFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:05:32 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51653 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbaG2L6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:58:43 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/19] staging: comedi: amplc_pci230: blank lines aren't necessary before a close brace '}'
Date: Tue, 29 Jul 2014 12:58:12 +0100
Message-Id: <1406635107-27950-5-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
References: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch issues: "CHECK: Blank lines aren't necessary before a
close brace '}'".

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 0609e51..51f28b6 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -739,7 +739,6 @@ static void put_resources(struct comedi_device *dev, unsigned int res_mask,
 			res_mask &= ~b;
 			if (devpriv->res_owner[i] == owner)
 				devpriv->res_owner[i] = OWNER_NONE;
-
 		}
 	}
 	spin_unlock_irqrestore(&devpriv->res_spinlock, irqflags);
@@ -792,7 +791,6 @@ static unsigned int pci230_choose_clk_count(uint64_t ns, unsigned int *count,
 		cnt = divide_ns(ns, pci230_timebase[clk_src], flags);
 		if ((cnt <= 65536) || (clk_src == CLK_1KHZ))
 			break;
-
 	}
 	*count = cnt;
 	return clk_src;
@@ -1448,7 +1446,6 @@ static void pci230_ao_start(struct comedi_device *dev,
 					   & ~PCI230P2_DAC_TRIG_MASK) |
 			    scantrig;
 			outw(devpriv->daccon, dev->iobase + PCI230_DACCON);
-
 		}
 		switch (cmd->scan_begin_src) {
 		case TRIG_TIMER:
@@ -1512,7 +1509,6 @@ static int pci230_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		/* Claim Z2-CT1. */
 		if (!get_one_resource(dev, RES_Z2CT1, OWNER_AOCMD))
 			return -EBUSY;
-
 	}
 
 	/* Get number of scans required. */
-- 
2.0.0

