Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbaGTOIP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:08:15 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:41144 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaGTOGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:06:49 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Asadi <asadi.samuel@gmail.com>
Subject: [PATCH 5/7] Staging: comedi: adv_pci1710: a line over 80 characters resolved
Date: Sun, 20 Jul 2014 17:06:22 +0300
Message-Id: <1405865185-8375-5-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405865185-8375-1-git-send-email-asadi.samuel@gmail.com>
References: <1405865185-8375-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An issue in 'line over 80 characters' fixed by taking back over-lined comment
a few characters.

Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>
---
 drivers/staging/comedi/drivers/adv_pci1710.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index bc73141..7ccd41b 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -1060,7 +1060,7 @@ static int pci171x_reset(struct comedi_device *dev)
 	if (this_board->n_aochan) {
 		/* set DACs to 0..5V */
 		outb(devpriv->da_ranges, dev->iobase + PCI171x_DAREF);
-		outw(0, dev->iobase + PCI171x_DA1);	/*  set DA outputs to 0V */
+		outw(0, dev->iobase + PCI171x_DA1); /* set DA outputs to 0V */
 		devpriv->ao_data[0] = 0x0000;
 		if (this_board->n_aochan > 1) {
 			outw(0, dev->iobase + PCI171x_DA2);
-- 
1.7.10.4

