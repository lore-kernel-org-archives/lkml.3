Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaG2L6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:58:44 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51634 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbaG2L6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:58:41 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/19] staging: comedi: amplc_pci230: fix checkpatch line over 80 characters
Date: Tue, 29 Jul 2014 12:58:10 +0100
Message-Id: <1406635107-27950-3-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
References: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index cb86d04..c6c3c4a 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -664,10 +664,8 @@ static inline void pci230_ao_write_nofifo(struct comedi_device *dev,
 	devpriv->ao_readback[chan] = datum;
 
 	/* Write mangled datum to appropriate DACOUT register. */
-	outw(pci230_ao_mangle_datum(dev, datum), dev->iobase + (((chan) == 0)
-								? PCI230_DACOUT1
-								:
-								PCI230_DACOUT2));
+	outw(pci230_ao_mangle_datum(dev, datum),
+	     dev->iobase + (((chan) == 0) ? PCI230_DACOUT1 : PCI230_DACOUT2));
 }
 
 static inline void pci230_ao_write_fifo(struct comedi_device *dev,
-- 
2.0.0

