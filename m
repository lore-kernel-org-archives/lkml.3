Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbaIALES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:04:18 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:38974 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbaIALEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:15 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/28] staging: comedi: amplc_pci230: update MODULE_DESCRIPTION()
Date: Mon,  1 Sep 2014 12:03:33 +0100
Message-Id: <1409569440-10979-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the generic, Comedi low-level driver module description string
with something more specific.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index cd63706..d077254 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -2869,5 +2869,5 @@ static struct pci_driver amplc_pci230_pci_driver = {
 module_comedi_pci_driver(amplc_pci230_driver, amplc_pci230_pci_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
-MODULE_DESCRIPTION("Comedi low-level driver");
+MODULE_DESCRIPTION("Comedi driver for Amplicon PCI230(+) and PCI260(+)");
 MODULE_LICENSE("GPL");
-- 
2.0.4

