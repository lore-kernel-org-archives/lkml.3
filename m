Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333AbbAINux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 08:50:53 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:55158 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbbAINuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 08:50:52 -0500
Date: Fri, 9 Jan 2015 12:20:04 +0800
From: Simon Guo <wei.guo.simon@gmail.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        wei.guo.simon@gmail.com
Subject: [PATCH 3.19.0-rc3 1/1] STAGING: Fix pcl818.c coding style issue
Message-ID: <20150109042003.GA3970@thunderCat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct coding style problem in pcl818.c. The coding style problems(29 
warnings detected by checkpatch.pl) includes:
- line over 80 characters
- There is space before tabs
The changed file has been verified with checkpatch.pl to be clean for 
warnings/errors.

Signed-off-by: Simon Guo <wei.guo.simon@gmail.com>
---
 drivers/staging/comedi/drivers/pcl818.c | 50 ++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 8edea35..111bee1 100644
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
@@ -57,44 +57,44 @@ A word or two about DMA. Driver support DMA operations at two ways:
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
 	      3=             +/-1V
 	      4=             +/-0.5V
-	      5=  	     user defined bipolar
+	      5=	     user defined bipolar
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
 
@@ -309,11 +309,19 @@ struct pcl818_private {
 	unsigned long dmabuf[2];	/*  pointers to begin of DMA buffers */
 	unsigned int hwdmaptr[2];	/*  hardware address of DMA buffers */
 	int next_dma_buf;	/*  which DMA buffer will be used next round */
-	long dma_runs_to_end;	/*  how many we must permorm DMA transfer to end of record */
-	unsigned long last_dma_run;	/*  how many bytes we must transfer on last DMA page */
-	unsigned int ns_min;	/*  manimal allowed delay between samples (in us) for actual card */
+	long dma_runs_to_end;	/*  how many we must permorm DMA transfer
+				 *  to end of record
+				 */
+	unsigned long last_dma_run;	/*  how many bytes we must transfer
+					 *  on last DMA page
+					 */
+	unsigned int ns_min;	/*  manimal allowed delay between
+				 *  samples (in us) for actual card
+				 */
 	int i8253_osc_base;	/*  1/frequency of on board oscilator in ns */
-	unsigned int act_chanlist[16];	/*  MUX setting for actual AI operations */
+	unsigned int act_chanlist[16];	/*  MUX setting for actual
+					 *  AI operations
+					 */
 	unsigned int act_chanlist_len;	/*  how long is actual MUX list */
 	unsigned int act_chanlist_pos;	/*  actual position in MUX list */
 	unsigned int ai_data_len;	/*  len of data buffer */
@@ -687,7 +695,8 @@ static int check_channel_list(struct comedi_device *dev,
 				break;
 			nowmustbechan =
 			    (CR_CHAN(chansegment[i - 1]) + 1) % s->n_chan;
-			if (nowmustbechan != CR_CHAN(chanlist[i])) {	/*  channel list isn't continuous :-( */
+			if (nowmustbechan != CR_CHAN(chanlist[i])) {
+				/*  channel list isn't continuous :-( */
 				dev_dbg(dev->class_dev,
 					"channel list must be continuous! chanlist[%i]=%d but must be %d or %d!\n",
 					i, CR_CHAN(chanlist[i]), nowmustbechan,
@@ -1194,8 +1203,9 @@ static int pcl818_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	devpriv->ns_min = board->ns_min;
 
 	if (!board->is_818) {
+		/* extended PCL718 to 100kHz DAC */
 		if ((it->options[6] == 1) || (it->options[6] == 100))
-			devpriv->ns_min = 10000;	/* extended PCL718 to 100kHz DAC */
+			devpriv->ns_min = 10000;
 	}
 
 	pcl818_reset(dev);
-- 
1.8.1.2

