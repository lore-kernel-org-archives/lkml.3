Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbaE2LQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 07:16:04 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:57158 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbaE2LQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 07:16:00 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Fred Brooks <frederick.brooks@microchip.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: comedi: ni_daq_700: update driver comment
Date: Thu, 29 May 2014 12:15:46 +0100
Message-Id: <1401362147-5965-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1401362147-5965-1-git-send-email-abbotti@mev.co.uk>
References: <1401362147-5965-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reformat the comment describing this comedi driver to use the usual
block comment format.

Also remove reference to digital I/O emulating an 8255, because it
doesn't, and remove "DIO only" from the "Description:" line as it also
supports analog inputs.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 51 ++++++++++++++---------------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 171a71d..55d80ef 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -18,32 +18,31 @@
  */
 
 /*
-Driver: ni_daq_700
-Description: National Instruments PCMCIA DAQCard-700 DIO only
-Author: Fred Brooks <nsaspook@nsaspook.com>,
-  based on ni_daq_dio24 by Daniel Vecino Castel <dvecino@able.es>
-Devices: [National Instruments] PCMCIA DAQ-Card-700 (ni_daq_700)
-Status: works
-Updated: Wed, 19 Sep 2012 12:07:20 +0000
-
-The daqcard-700 appears in Comedi as a  digital I/O subdevice (0) with
-16 channels and a analog input subdevice (1) with 16 single-ended channels.
-
-Digital:  The channel 0 corresponds to the daqcard-700's output
-port, bit 0; channel 8 corresponds to the input port, bit 0.
-
-Digital direction configuration: channels 0-7 output, 8-15 input (8225 device
-emu as port A output, port B input, port C N/A).
-
-Analog: The input  range is 0 to 4095 for -10 to +10 volts
-IRQ is assigned but not used.
-
-Version 0.1	Original DIO only driver
-Version 0.2	DIO and basic AI analog input support on 16 se channels
-
-Manuals:	Register level:	http://www.ni.com/pdf/manuals/340698.pdf
-		User Manual:	http://www.ni.com/pdf/manuals/320676d.pdf
-*/
+ * Driver: ni_daq_700
+ * Description: National Instruments PCMCIA DAQCard-700
+ * Author: Fred Brooks <nsaspook@nsaspook.com>,
+ *   based on ni_daq_dio24 by Daniel Vecino Castel <dvecino@able.es>
+ * Devices: [National Instruments] PCMCIA DAQ-Card-700 (ni_daq_700)
+ * Status: works
+ * Updated: Wed, 19 Sep 2012 12:07:20 +0000
+ *
+ * The daqcard-700 appears in Comedi as a  digital I/O subdevice (0) with
+ * 16 channels and a analog input subdevice (1) with 16 single-ended channels.
+ *
+ * Digital:  The channel 0 corresponds to the daqcard-700's output
+ * port, bit 0; channel 8 corresponds to the input port, bit 0.
+ *
+ * Digital direction configuration: channels 0-7 output, 8-15 input.
+ *
+ * Analog: The input  range is 0 to 4095 for -10 to +10 volts
+ * IRQ is assigned but not used.
+ *
+ * Version 0.1	Original DIO only driver
+ * Version 0.2	DIO and basic AI analog input support on 16 se channels
+ *
+ * Manuals:	Register level:	http://www.ni.com/pdf/manuals/340698.pdf
+ *		User Manual:	http://www.ni.com/pdf/manuals/320676d.pdf
+ */
 
 #include <linux/module.h>
 #include <linux/delay.h>
-- 
1.9.2

