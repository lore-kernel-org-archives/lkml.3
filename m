Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaGTOGv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:06:51 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:43735 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaGTOGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:06:48 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Asadi <asadi.samuel@gmail.com>
Subject: [PATCH 1/7] Staging: comedi: adv_pci1710: a line over 80 fixed
Date: Sun, 20 Jul 2014 17:06:18 +0300
Message-Id: <1405865185-8375-1-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A 'line over 80' issue fixed, by removing comment to previous line. And
also, by this, 'a blank line' isssue resolved.

Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>
---
 drivers/staging/comedi/drivers/adv_pci1710.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 602b7a1..a15a552 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -722,8 +722,8 @@ static int pci171x_ai_cancel(struct comedi_device *dev,
 	default:
 		devpriv->CntrlReg &= Control_CNT0;
 		devpriv->CntrlReg |= Control_SW;
-
-		outw(devpriv->CntrlReg, dev->iobase + PCI171x_CONTROL);	/*  reset any operations */
+		/* reset any operations */
+		outw(devpriv->CntrlReg, dev->iobase + PCI171x_CONTROL);
 		pci171x_start_pacer(dev, false);
 		outb(0, dev->iobase + PCI171x_CLRFIFO);
 		outb(0, dev->iobase + PCI171x_CLRINT);
-- 
1.7.10.4

