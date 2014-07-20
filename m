Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbaGTEuH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 00:50:07 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:35736 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaGTEuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 00:50:05 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Asadi <asadi.samuel@gmail.com>
Subject: [PATCH 1/1] Staging: comedi: adv_pci1710: a line over 80 fixed
Date: Sun, 20 Jul 2014 07:49:39 +0300
Message-Id: <1405831779-12435-1-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a line over 80 issue fixed by removing the cross-lined comment
to the previous line.

Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>
---
 drivers/staging/comedi/drivers/adv_pci1710.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 602b7a1..040a5cb 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -722,8 +722,9 @@ static int pci171x_ai_cancel(struct comedi_device *dev,
 	default:
 		devpriv->CntrlReg &= Control_CNT0;
 		devpriv->CntrlReg |= Control_SW;
-
-		outw(devpriv->CntrlReg, dev->iobase + PCI171x_CONTROL);	/*  reset any operations */
+
+		/* reset any operations */
+		outw(devpriv->CntrlReg, dev->iobase + PCI171x_CONTROL);
 		pci171x_start_pacer(dev, false);
 		outb(0, dev->iobase + PCI171x_CLRFIFO);
 		outb(0, dev->iobase + PCI171x_CLRINT);
-- 
1.7.10.4

