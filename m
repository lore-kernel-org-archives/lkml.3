Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaG2L6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:58:53 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51661 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbaG2L6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:58:46 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/19] staging: comedi: amplc_pci230: remove PCI230_TEST_BIT()
Date: Tue, 29 Jul 2014 12:58:17 +0100
Message-Id: <1406635107-27950-10-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
References: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The `PCI230_TEST_BIT()` macro is never used.  Remove it.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index e6744a5..f94b542 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -423,9 +423,6 @@
 /* For PCI230+ hardware version 2 when DAC FIFO enabled. */
 #define PCI230P2_INT_DAC		(1<<4)
 
-/* Assumes bits numbered with zero offset, ie. 0-15 */
-#define PCI230_TEST_BIT(val, n)	((val>>n)&1)
-
 /*
  * (Potentially) shared resources and their owners
  */
-- 
2.0.0

