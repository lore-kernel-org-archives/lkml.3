Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaGaNw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:52:59 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:57868 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbaGaNsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:48:09 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/18] staging: comedi: amplc_pci224: add whitespace to pci224_boards[]
Date: Thu, 31 Jul 2014 14:47:43 +0100
Message-Id: <1406814475-5923-7-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
References: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a bit of whitespace to the initializer of `pci224_boards[]` for
aesthetic reasons.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci224.c | 32 +++++++++++++--------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index dfeb70c..8ce0f4f 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -341,24 +341,24 @@ struct pci224_board {
 
 static const struct pci224_board pci224_boards[] = {
 	{
-	 .name = "pci224",
-	 .devid = PCI_DEVICE_ID_AMPLICON_PCI224,
-	 .model = pci224_model,
-	 .ao_chans = 16,
-	 .ao_bits = 12,
-	 },
+		.name		= "pci224",
+		.devid		= PCI_DEVICE_ID_AMPLICON_PCI224,
+		.model		= pci224_model,
+		.ao_chans	= 16,
+		.ao_bits	= 12,
+	},
 	{
-	 .name = "pci234",
-	 .devid = PCI_DEVICE_ID_AMPLICON_PCI234,
-	 .model = pci234_model,
-	 .ao_chans = 4,
-	 .ao_bits = 16,
-	 },
+		.name		= "pci234",
+		.devid		= PCI_DEVICE_ID_AMPLICON_PCI234,
+		.model		= pci234_model,
+		.ao_chans	= 4,
+		.ao_bits	= 16,
+	},
 	{
-	 .name = "amplc_pci224",
-	 .devid = PCI_DEVICE_ID_INVALID,
-	 .model = any_model,	/* wildcard */
-	 },
+		.name		= "amplc_pci224",
+		.devid		= PCI_DEVICE_ID_INVALID,
+		.model		= any_model,	/* wildcard */
+	},
 };
 
 struct pci224_private {
-- 
2.0.0

