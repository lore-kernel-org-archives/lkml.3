Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbaJJTiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 15:38:46 -0400
Received: from jabba.london.02.net ([82.132.130.169]:49851 "EHLO mail.o2.co.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754503AbaJJTin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 15:38:43 -0400
Date: Fri, 10 Oct 2014 20:32:42 +0100
From: Bernd Porr <mail@berndporr.me.uk>
To: Ian Abbott <abbotti@mev.co.uk>,
        Hartley Sweeten <HartleyS@visionengravers.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH 1/3] staging: comedi: usbduxsigma: updated contact details
 and status
Message-ID: <20141010193241.GA29530@bp1-Dimension-9100>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've updated my contact details of the driver. I've also tested it
thoroughly and it works perfectly. I've changed the status to stable. 

Signed-off-by: Bernd Porr <mail@berndporr.me.uk>
---
 drivers/staging/comedi/drivers/usbduxsigma.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
index 94a09c1..309878e 100644
--- a/drivers/staging/comedi/drivers/usbduxsigma.c
+++ b/drivers/staging/comedi/drivers/usbduxsigma.c
@@ -1,6 +1,6 @@
 /*
  * usbduxsigma.c
- * Copyright (C) 2011 Bernd Porr, Bernd.Porr@f2s.com
+ * Copyright (C) 2011-2014 Bernd Porr, mail@berndporr.me.uk
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -17,9 +17,9 @@
  * Driver: usbduxsigma
  * Description: University of Stirling USB DAQ & INCITE Technology Limited
  * Devices: (ITL) USB-DUX [usbduxsigma]
- * Author: Bernd Porr <BerndPorr@f2s.com>
- * Updated: 8 Nov 2011
- * Status: testing
+ * Author: Bernd Porr <mail@berndporr.me.uk>
+ * Updated: 10 Oct 2014
+ * Status: stable
  */
 
 /*
-- 
1.9.1

