Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbaJJTip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 15:38:45 -0400
Received: from jabba.london.02.net ([82.132.130.169]:49845 "EHLO mail.o2.co.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751866AbaJJTin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 15:38:43 -0400
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Oct 2014 15:38:42 EDT
Date: Fri, 10 Oct 2014 20:35:11 +0100
From: Bernd Porr <mail@berndporr.me.uk>
To: Ian Abbott <abbotti@mev.co.uk>,
        Hartley Sweeten <HartleyS@visionengravers.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH 3/3] staging: comedi: usbduxfast: updated address details
Message-ID: <20141010193511.GA29558@bp1-Dimension-9100>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated the range of years, e-mail and added driver desription as
usually done in comedi. 

Signed-off-by: Bernd Porr <mail@berndporr.me.uk>
---
 drivers/staging/comedi/drivers/usbduxfast.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index f85818d..4f57321 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -1,5 +1,5 @@
 /*
- *  Copyright (C) 2004 Bernd Porr, Bernd.Porr@f2s.com
+ *  Copyright (C) 2004-2014 Bernd Porr, mail@berndporr.me.uk
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -12,6 +12,15 @@
  * GNU General Public License for more details.
  */
 
+/*                                                                             
+ * Driver: usbduxfast
+ * Description: University of Stirling USB DAQ & INCITE Technology Limited     
+ * Devices: (ITL) USB-DUX [usbduxfast]                                        
+ * Author: Bernd Porr <mail@berndporr.me.uk>
+ * Updated: 10 Oct 2014                                   
+ * Status: stable                                                         
+ */
+
 /*
  * I must give credit here to Chris Baugher who
  * wrote the driver for AT-MIO-16d. I used some parts of this
-- 
1.9.1

