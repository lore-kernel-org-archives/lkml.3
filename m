Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaGTOIe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:08:34 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:41001 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaGTOGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:06:48 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Asadi <asadi.samuel@gmail.com>
Subject: [PATCH 6/7] Staging: comedi: adv_pci1710: an issue in line over 80 fixed
Date: Sun, 20 Jul 2014 17:06:23 +0300
Message-Id: <1405865185-8375-6-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405865185-8375-1-git-send-email-asadi.samuel@gmail.com>
References: <1405865185-8375-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An issue in 'line over 80 characters' fixed by removing over-lined comment
to the previous line.

Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>
---
 drivers/staging/comedi/drivers/adv_pci1710.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 7ccd41b..6bd5015 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -1080,8 +1080,8 @@ static int pci171x_reset(struct comedi_device *dev)
 static int pci1720_reset(struct comedi_device *dev)
 {
 	struct pci1710_private *devpriv = dev->private;
-
-	outb(Syncont_SC0, dev->iobase + PCI1720_SYNCONT);	/*  set synchronous output mode */
+	/* set synchronous output mode */
+	outb(Syncont_SC0, dev->iobase + PCI1720_SYNCONT);
 	devpriv->da_ranges = 0xAA;
 	outb(devpriv->da_ranges, dev->iobase + PCI1720_RANGE);	/*  set all ranges to +/-5V */
 	outw(0x0800, dev->iobase + PCI1720_DA0);	/*  set outputs to 0V */
-- 
1.7.10.4

