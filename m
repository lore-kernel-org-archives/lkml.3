Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbaGaNsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:48:11 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:57838 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbaGaNsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:48:08 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/18] staging: comedi: amplc_pci224: fix checkpatch line over 80 characters
Date: Thu, 31 Jul 2014 14:47:39 +0100
Message-Id: <1406814475-5923-3-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
References: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci224.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index 72506bf..6a570ef 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -565,7 +565,8 @@ static void pci224_ao_handle_fifo(struct comedi_device *dev,
 	switch (dacstat & PCI224_DACCON_FIFOFL_MASK) {
 	case PCI224_DACCON_FIFOFL_EMPTY:
 		room = PCI224_FIFO_ROOM_EMPTY;
-		if (cmd->stop_src == TRIG_COUNT && devpriv->ao_stop_count == 0) {
+		if (cmd->stop_src == TRIG_COUNT &&
+		    devpriv->ao_stop_count == 0) {
 			/* FIFO empty at end of counted acquisition. */
 			s->async->events |= COMEDI_CB_EOA;
 			cfc_handle_events(dev, s);
-- 
2.0.0

