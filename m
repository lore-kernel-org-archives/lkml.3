Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaGTOGy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:06:54 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:47839 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbaGTOGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:06:52 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Asadi <asadi.samuel@gmail.com>
Subject: [PATCH 4/7] Staging: comedi: adv_pci1710: a line over 80 characters fixed
Date: Sun, 20 Jul 2014 17:06:21 +0300
Message-Id: <1405865185-8375-4-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405865185-8375-1-git-send-email-asadi.samuel@gmail.com>
References: <1405865185-8375-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An issue in 'line over 80 characters' fixed and over-lined comment
removed to the previous line.

Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>
---
 drivers/staging/comedi/drivers/adv_pci1710.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 887aa7e..bc73141 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -1058,7 +1058,8 @@ static int pci171x_reset(struct comedi_device *dev)
 	pci171x_start_pacer(dev, false);
 	devpriv->da_ranges = 0;
 	if (this_board->n_aochan) {
-		outb(devpriv->da_ranges, dev->iobase + PCI171x_DAREF);	/*  set DACs to 0..5V */
+		/* set DACs to 0..5V */
+		outb(devpriv->da_ranges, dev->iobase + PCI171x_DAREF);
 		outw(0, dev->iobase + PCI171x_DA1);	/*  set DA outputs to 0V */
 		devpriv->ao_data[0] = 0x0000;
 		if (this_board->n_aochan > 1) {
-- 
1.7.10.4

