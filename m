Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbaJJTkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 15:40:21 -0400
Received: from sidious.london.02.net ([82.132.130.152]:35686 "EHLO
	mail.o2.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751703AbaJJTkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 15:40:19 -0400
Date: Fri, 10 Oct 2014 20:34:04 +0100
From: Bernd Porr <mail@berndporr.me.uk>
To: Ian Abbott <abbotti@mev.co.uk>,
        Hartley Sweeten <HartleyS@visionengravers.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH 2/3] staging: comedi: usbdux: updated contact details /
 comments
Message-ID: <20141010193404.GA29546@bp1-Dimension-9100>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've updated my contact details and removed obsolete comments. 

Signed-off-by: Bernd Porr <mail@berndporr.me.uk>
---
 drivers/staging/comedi/drivers/usbdux.c | 59 ++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 053bc50..24fa9f66 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -1,37 +1,34 @@
 /*
-   comedi/drivers/usbdux.c
-   Copyright (C) 2003-2007 Bernd Porr, Bernd.Porr@f2s.com
-
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License as published by
-   the Free Software Foundation; either version 2 of the License, or
-   (at your option) any later version.
-
-   This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU General Public License for more details.
+ * usbdux.c
+ * Copyright (C) 2003-2014 Bernd Porr, mail@berndporr.me.uk
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  */
+
 /*
-Driver: usbdux
-Description: University of Stirling USB DAQ & INCITE Technology Limited
-Devices: [ITL] USB-DUX (usbdux.o)
-Author: Bernd Porr <BerndPorr@f2s.com>
-Updated: 8 Dec 2008
-Status: Stable
-Configuration options:
-  You have to upload firmware with the -i option. The
-  firmware is usually installed under /usr/share/usb or
-  /usr/local/share/usb or /lib/firmware.
-
-Connection scheme for the counter at the digital port:
-  0=/CLK0, 1=UP/DOWN0, 2=RESET0, 4=/CLK1, 5=UP/DOWN1, 6=RESET1.
-  The sampling rate of the counter is approximately 500Hz.
-
-Please note that under USB2.0 the length of the channel list determines
-the max sampling rate. If you sample only one channel you get 8kHz
-sampling rate. If you sample two channels you get 4kHz and so on.
-*/
+ * Driver: usbdux
+ * Description: University of Stirling USB DAQ & INCITE Technology Limited
+ * Devices: (ITL) USB-DUX [usbdux]
+ * Author: Bernd Porr <mail@berndporr.me.uk>
+ * Updated: 10 Oct 2014
+ * Status: Stable
+ * Connection scheme for the counter at the digital port:
+ * 0=/CLK0, 1=UP/DOWN0, 2=RESET0, 4=/CLK1, 5=UP/DOWN1, 6=RESET1.
+ * The sampling rate of the counter is approximately 500Hz.
+ *
+ * Note that under USB2.0 the length of the channel list determines
+ * the max sampling rate. If you sample only one channel you get 8kHz
+ * sampling rate. If you sample two channels you get 4kHz and so on.
+ */
+
 /*
  * I must give credit here to Chris Baugher who
  * wrote the driver for AT-MIO-16d. I used some parts of this
-- 
1.9.1

