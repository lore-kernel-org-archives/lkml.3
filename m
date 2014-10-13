Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbaJMMm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 08:42:28 -0400
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:39739 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753828AbaJMMlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 08:41:47 -0400
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] staging: comedi: cb_pcimdas: update driver comment
Date: Mon, 13 Oct 2014 13:41:21 +0100
Message-Id: <1413204082-14757-3-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413204082-14757-1-git-send-email-abbotti@mev.co.uk>
References: <1413204082-14757-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Comedi driver comment mentions a couple of manual configuration
options, but manual configuration via the COMEDI_DEVCONFIG ioctl and
comedi "attach" handler is no longer supported by this driver.  Update
the comment appropriately.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/cb_pcimdas.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index 804b3c3..433941a 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -27,8 +27,10 @@
  * Written to support the PCIM-DAS1602/16 on a 2.4 series kernel.
  *
  * Configuration Options:
- *     [0] - PCI bus number
- *     [1] - PCI slot number
+ *   none
+ *
+ * Manual configuration of PCI cards is not supported; they are configured
+ * automatically.
  *
  * Developed from cb_pcidas and skel by Richard Bytheway (mocelet@sucs.org).
  * Only supports DIO, AO and simple AI in it's present form.
-- 
2.1.1

