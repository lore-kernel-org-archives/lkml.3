Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbaGTOHt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:07:49 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:35366 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbaGTOGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:06:50 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Asadi <asadi.samuel@gmail.com>
Subject: [PATCH 7/7] Staging: comedi: adv_pci1710: an issue in code style fixed
Date: Sun, 20 Jul 2014 17:06:24 +0300
Message-Id: <1405865185-8375-7-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405865185-8375-1-git-send-email-asadi.samuel@gmail.com>
References: <1405865185-8375-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An issue in 'line over 80 characters' fixed by removing over-lined
comment to the previous line.

Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>
---
 drivers/staging/comedi/drivers/adv_pci1710.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 6bd5015..e19ab95 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -1083,7 +1083,8 @@ static int pci1720_reset(struct comedi_device *dev)
 	/* set synchronous output mode */
 	outb(Syncont_SC0, dev->iobase + PCI1720_SYNCONT);
 	devpriv->da_ranges = 0xAA;
-	outb(devpriv->da_ranges, dev->iobase + PCI1720_RANGE);	/*  set all ranges to +/-5V */
+	/* set all ranges to +/-5V */
+	outb(devpriv->da_ranges, dev->iobase + PCI1720_RANGE);
 	outw(0x0800, dev->iobase + PCI1720_DA0);	/*  set outputs to 0V */
 	outw(0x0800, dev->iobase + PCI1720_DA1);
 	outw(0x0800, dev->iobase + PCI1720_DA2);
-- 
1.7.10.4

