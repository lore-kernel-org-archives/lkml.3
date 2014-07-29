Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaG2MAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:00:33 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51681 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156AbaG2L6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:58:49 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 16/19] staging: comedi: amplc_pci230: add whitespace to pci230_boards[]
Date: Tue, 29 Jul 2014 12:58:24 +0100
Message-Id: <1406635107-27950-17-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
References: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a bit of whitespace to the initializer of `pci230_boards[]` for
aesthetic reasons.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 76 ++++++++++++++-------------
 1 file changed, 39 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 395eba2..47e10ba 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -467,49 +467,51 @@ struct pci230_board {
 	int have_dio;
 	unsigned int min_hwver;	/* Minimum hardware version supported. */
 };
+
 static const struct pci230_board pci230_boards[] = {
 	{
-	 .name = "pci230+",
-	 .id = PCI_DEVICE_ID_PCI230,
-	 .ai_chans = 16,
-	 .ai_bits = 16,
-	 .ao_chans = 2,
-	 .ao_bits = 12,
-	 .have_dio = 1,
-	 .min_hwver = 1,
-	 },
+		.name		= "pci230+",
+		.id		= PCI_DEVICE_ID_PCI230,
+		.ai_chans	= 16,
+		.ai_bits	= 16,
+		.ao_chans	= 2,
+		.ao_bits	= 12,
+		.have_dio	= 1,
+		.min_hwver	= 1,
+	},
 	{
-	 .name = "pci260+",
-	 .id = PCI_DEVICE_ID_PCI260,
-	 .ai_chans = 16,
-	 .ai_bits = 16,
-	 .ao_chans = 0,
-	 .ao_bits = 0,
-	 .have_dio = 0,
-	 .min_hwver = 1,
-	 },
+		.name		= "pci260+",
+		.id		= PCI_DEVICE_ID_PCI260,
+		.ai_chans	= 16,
+		.ai_bits	= 16,
+		.ao_chans	= 0,
+		.ao_bits	= 0,
+		.have_dio	= 0,
+		.min_hwver	= 1,
+	},
 	{
-	 .name = "pci230",
-	 .id = PCI_DEVICE_ID_PCI230,
-	 .ai_chans = 16,
-	 .ai_bits = 12,
-	 .ao_chans = 2,
-	 .ao_bits = 12,
-	 .have_dio = 1,
-	 },
+		.name		= "pci230",
+		.id		= PCI_DEVICE_ID_PCI230,
+		.ai_chans	= 16,
+		.ai_bits	= 12,
+		.ao_chans	= 2,
+		.ao_bits	= 12,
+		.have_dio	= 1,
+	},
 	{
-	 .name = "pci260",
-	 .id = PCI_DEVICE_ID_PCI260,
-	 .ai_chans = 16,
-	 .ai_bits = 12,
-	 .ao_chans = 0,
-	 .ao_bits = 0,
-	 .have_dio = 0,
-	 },
+		.name		= "pci260",
+		.id		= PCI_DEVICE_ID_PCI260,
+		.ai_chans	= 16,
+		.ai_bits	= 12,
+		.ao_chans	= 0,
+		.ao_bits	= 0,
+		.have_dio	= 0,
+	},
 	{
-	 .name = "amplc_pci230",	/* Wildcard matches any above */
-	 .id = PCI_DEVICE_ID_INVALID,
-	 },
+		/* Wildcard matches any above */
+		.name		= "amplc_pci230",
+		.id		= PCI_DEVICE_ID_INVALID,
+	},
 };
 
 /*
-- 
2.0.0

