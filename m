Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbaGWCGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:06:54 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:64230 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaGWCGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:06:53 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Asadi <asadi.samuel@gmail.com>
Subject: [PATCH 1/1] Staging: comedi: amplc_pc236: a blank line inserted
Date: Wed, 23 Jul 2014 05:06:28 +0300
Message-Id: <1406081188-7619-1-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A 'Missing a blank line after declarations' warning fixed by inserting
a blank line after struct pointer declaration.

Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>
---
 drivers/staging/comedi/drivers/amplc_pc236.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index c9a96ad..d0f81f8 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -515,6 +515,7 @@ static void pc236_detach(struct comedi_device *dev)
 		comedi_legacy_detach(dev);
 	} else if (is_pci_board(thisboard)) {
 		struct pci_dev *pcidev = comedi_to_pci_dev(dev);
+
 		if (dev->irq)
 			free_irq(dev->irq, dev);
 		comedi_pci_disable(dev);
-- 
1.7.10.4

