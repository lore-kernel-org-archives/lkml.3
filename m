Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaGaNwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:52:23 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:57878 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbaGaNsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:48:11 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/18] staging: comedi: amplc_pci224: set a more descriptive MODULE_DESCRIPTION()
Date: Thu, 31 Jul 2014 14:47:44 +0100
Message-Id: <1406814475-5923-8-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
References: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci224.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index 8ce0f4f..f786237 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -1362,5 +1362,5 @@ static struct pci_driver amplc_pci224_pci_driver = {
 module_comedi_pci_driver(amplc_pci224_driver, amplc_pci224_pci_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
-MODULE_DESCRIPTION("Comedi low-level driver");
+MODULE_DESCRIPTION("Comedi driver for Amplicon PCI224 and PCI234 AO boards");
 MODULE_LICENSE("GPL");
-- 
2.0.0

