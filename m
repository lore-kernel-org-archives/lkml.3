Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbaGTBQf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 21:16:35 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:59877 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaGTBQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 21:16:34 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Asadi <asadi.samuel@gmail.com>
Subject: [PATCH 2/2] Staging: comedi: adv_pci1710.c line over 80 fixed
Date: Sun, 20 Jul 2014 04:15:50 +0300
Message-Id: <1405818950-9858-1-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A line over 80 issue fixed, which is a comment.

Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>
---
 drivers/staging/comedi/drivers/adv_pci1710.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 602b7a1..13ff78c 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -723,7 +723,8 @@ static int pci171x_ai_cancel(struct comedi_device *dev,
 		devpriv->CntrlReg &= Control_CNT0;
 		devpriv->CntrlReg |= Control_SW;
 
-		outw(devpriv->CntrlReg, dev->iobase + PCI171x_CONTROL);	/*  reset any operations */
+		outw(devpriv->CntrlReg, dev->iobase + PCI171x_CONTROL);
+						/* reset any operations */
 		pci171x_start_pacer(dev, false);
 		outb(0, dev->iobase + PCI171x_CLRFIFO);
 		outb(0, dev->iobase + PCI171x_CLRINT);
-- 
1.9.1

