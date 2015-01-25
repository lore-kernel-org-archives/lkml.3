Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbbAYJ2d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 04:28:33 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:36963 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbbAYJ2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 04:28:23 -0500
Date: Sun, 25 Jan 2015 17:28:17 +0800
From: Simon Guo <wei.guo.simon@gmail.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        wei.guo.simon@gmail.com
Subject: [PATCH 3.19.0-rc5 01/03] STAGING: Fix pcl818.c coding style issue:
 code indent should use tabs where possible
Message-ID: <20150125092816.GA4076@thunderCat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct one coding style problem(detected by checkpatch.pl) in pcl818.c.
- code indent should use tabs where possible

Signed-off-by: Simon Guo <wei.guo.simon@gmail.com>
---
 drivers/staging/comedi/drivers/pcl818.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index ba2e137..72a700c 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -45,11 +45,11 @@ A word or two about DMA. Driver support DMA operations at two ways:
     [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
     [2] - DMA	(0=disable, 1, 3)
     [3] - 0, 10=10MHz clock for 8254
-              1= 1MHz clock for 8254
+	      1= 1MHz clock for 8254
     [4] - 0,  5=A/D input  -5V.. +5V
-          1, 10=A/D input -10V..+10V
+	  1, 10=A/D input -10V..+10V
     [5] - 0,  5=D/A output 0-5V  (internal reference -5V)
-          1, 10=D/A output 0-10V (internal reference -10V)
+	  1, 10=D/A output 0-10V (internal reference -10V)
 	  2    =D/A output unknown (external reference)
 
    Options for PCL-818, PCL-818H:
@@ -57,28 +57,28 @@ A word or two about DMA. Driver support DMA operations at two ways:
     [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
     [2] - DMA	(0=disable, 1, 3)
     [3] - 0, 10=10MHz clock for 8254
-              1= 1MHz clock for 8254
+	      1= 1MHz clock for 8254
     [4] - 0,  5=D/A output 0-5V  (internal reference -5V)
-          1, 10=D/A output 0-10V (internal reference -10V)
+	  1, 10=D/A output 0-10V (internal reference -10V)
 	  2    =D/A output unknown (external reference)
 
    Options for PCL-818HD, PCL-818HG:
     [0] - IO Base
     [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
     [2] - DMA/FIFO  (-1=use FIFO, 0=disable both FIFO and DMA,
-                      1=use DMA ch 1, 3=use DMA ch 3)
+		      1=use DMA ch 1, 3=use DMA ch 3)
     [3] - 0, 10=10MHz clock for 8254
-              1= 1MHz clock for 8254
+	      1= 1MHz clock for 8254
     [4] - 0,  5=D/A output 0-5V  (internal reference -5V)
-          1, 10=D/A output 0-10V (internal reference -10V)
-   	  2    =D/A output unknown (external reference)
+	  1, 10=D/A output 0-10V (internal reference -10V)
+	  2    =D/A output unknown (external reference)
 
    Options for PCL-718:
     [0] - IO Base
     [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
     [2] - DMA	(0=disable, 1, 3)
     [3] - 0, 10=10MHz clock for 8254
-              1= 1MHz clock for 8254
+	      1= 1MHz clock for 8254
     [4] -     0=A/D Range is +/-10V
 	      1=             +/-5V
 	      2=             +/-2.5V
@@ -87,14 +87,14 @@ A word or two about DMA. Driver support DMA operations at two ways:
 	      5=  	     user defined bipolar
 	      6=	     0-10V
 	      7=	     0-5V
- 	      8=	     0-2V
+	      8=	     0-2V
 	      9=	     0-1V
 	     10=	     user defined unipolar
     [5] - 0,  5=D/A outputs 0-5V  (internal reference -5V)
-          1, 10=D/A outputs 0-10V (internal reference -10V)
+	  1, 10=D/A outputs 0-10V (internal reference -10V)
 	      2=D/A outputs unknown (external reference)
     [6] - 0, 60=max  60kHz A/D sampling
-          1,100=max 100kHz A/D sampling (PCL-718 with Option 001 installed)
+	  1,100=max 100kHz A/D sampling (PCL-718 with Option 001 installed)
 
 */
 
-- 
1.8.1.2

