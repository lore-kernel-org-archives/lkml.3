Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbaGJLqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:46:10 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:35452 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbaGJLqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:46:07 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging: comedi: ni_daq_700: remove MODULE_VERSION() and commentary
Date: Thu, 10 Jul 2014 12:45:44 +0100
Message-Id: <1404992744-3662-3-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404992744-3662-1-git-send-email-abbotti@mev.co.uk>
References: <1404992744-3662-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't module version numbers for in-kernel drivers.  The kernel
version number is sufficient information.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 3d841d4..5e472cb 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -43,12 +43,6 @@
  *
  * IRQ is assigned but not used.
  *
- * Version 0.1	Original DIO only driver
- * Version 0.2	DIO and basic AI analog input support on 16 se channels
- * Version 0.3	Add SE or DIFF mode and range switching +-10,+-5,+-2.5
- *		Clear the FIFO of data before the conversion to handle card
- *		mode switching glitches.
- *
  * Manuals:	Register level:	http://www.ni.com/pdf/manuals/340698.pdf
  *		User Manual:	http://www.ni.com/pdf/manuals/320676d.pdf
  */
@@ -295,5 +289,4 @@ module_comedi_pcmcia_driver(daq700_driver, daq700_cs_driver);
 MODULE_AUTHOR("Fred Brooks <nsaspook@nsaspook.com>");
 MODULE_DESCRIPTION(
 	"Comedi driver for National Instruments PCMCIA DAQCard-700 DIO/AI");
-MODULE_VERSION("0.3.00");
 MODULE_LICENSE("GPL");
-- 
2.0.0

