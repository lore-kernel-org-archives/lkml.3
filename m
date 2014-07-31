Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaGaNw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:52:58 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:57867 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbaGaNsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:48:09 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/18] staging: comedi: amplc_pci224: fix spinlock_t definition without comment
Date: Thu, 31 Jul 2014 14:47:42 +0100
Message-Id: <1406814475-5923-6-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
References: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch issue: "CHECK: spinlock_t definition without comment".

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci224.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index 8e5d94a..dfeb70c 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -365,7 +365,7 @@ struct pci224_private {
 	const unsigned short *hwrange;
 	unsigned long iobase1;
 	unsigned long state;
-	spinlock_t ao_spinlock;
+	spinlock_t ao_spinlock;	/* spinlock for AO command handling */
 	unsigned int *ao_readback;
 	unsigned short *ao_scan_vals;
 	unsigned char *ao_scan_order;
-- 
2.0.0

