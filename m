Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbaG2L6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:58:54 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51667 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670AbaG2L6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:58:46 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/19] staging: comedi: amplc_pci230: alignment should match open parenthesis
Date: Tue, 29 Jul 2014 12:58:13 +0100
Message-Id: <1406635107-27950-6-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
References: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch issue: "CHECK: Alignment should match open parenthesis".

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 51f28b6..76c4625 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -2872,7 +2872,7 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 }
 
 static int pci230_auto_attach(struct comedi_device *dev,
-					unsigned long context_unused)
+			      unsigned long context_unused)
 {
 	struct pci_dev *pci_dev = comedi_to_pci_dev(dev);
 	int rc;
-- 
2.0.0

