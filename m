Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaGTOGt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:06:49 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:48379 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaGTOGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:06:48 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Asadi <asadi.samuel@gmail.com>
Subject: [PATCH 3/7] Staging: comedi: adv_pci1710: A line style issue fixed
Date: Sun, 20 Jul 2014 17:06:20 +0300
Message-Id: <1405865185-8375-3-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405865185-8375-1-git-send-email-asadi.samuel@gmail.com>
References: <1405865185-8375-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A 'line over 80 characters' fixed by removing over-lined comment
to previous line.

Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>
---
 drivers/staging/comedi/drivers/adv_pci1710.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index b4b8f85..887aa7e 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -1051,7 +1051,8 @@ static int pci171x_reset(struct comedi_device *dev)
 	outw(0x30, dev->iobase + PCI171x_CNTCTRL);
 	/* Software trigger, CNT0=external */
 	devpriv->CntrlReg = Control_SW | Control_CNT0;
-	outw(devpriv->CntrlReg, dev->iobase + PCI171x_CONTROL);	/*  reset any operations */
+	/* reset any operations */
+	outw(devpriv->CntrlReg, dev->iobase + PCI171x_CONTROL);
 	outb(0, dev->iobase + PCI171x_CLRFIFO);	/*  clear FIFO */
 	outb(0, dev->iobase + PCI171x_CLRINT);	/*  clear INT request */
 	pci171x_start_pacer(dev, false);
-- 
1.7.10.4

