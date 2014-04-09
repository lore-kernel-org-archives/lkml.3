Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043AbaDILqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:46:07 -0400
Received: from relay02.alfahosting-server.de ([109.237.142.238]:38949 "EHLO
	relay02.alfahosting-server.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932694AbaDILqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:46:04 -0400
X-Greylist: delayed 618 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Apr 2014 07:46:04 EDT
X-Spam-DCC: : 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 09 Apr 2014 13:35:37 +0200
From: Richard Leitner <me@g0hl1n.net>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: =?UTF-8?Q?adl=5Fpci=39=31=31=38=3A=20fix?=
 =?UTF-8?Q?=20whitespace=20issues?=
Message-ID: <8d54353f462d3d5bf51ad68b32bd88bb@webmail-alfa3028.alfahosting-server.de>
User-Agent: Alfahosting Webmail/1.0
X-Virus-Checker-Version: clamassassin 1.2.4 with ClamAV 0.97.3/18762/Wed Apr  9 07:41:01 2014
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed not needed spaces and fixed too long lines

PS: this is an exercise to get into the "patch submitting workflow"

Signed-off-by: Richard Leitner <me@g0hl1n.net>
---
  drivers/staging/comedi/drivers/adl_pci9118.c |    8 ++++----
  1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c 
b/drivers/staging/comedi/drivers/adl_pci9118.c
index 3cfa175..d028d6b 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -96,7 +96,7 @@ Configuration options:
  				 * correct channel number on every 12 bit sample
  				 */

-#define IORANGE_9118 	64	/* I hope */
+#define IORANGE_9118	64	/* I hope */
  #define PCI9118_CHANLEN	255	/*
  				 * len of chanlist, some source say 256,
  				 * but reality looks like 255 :-(
@@ -356,7 +356,7 @@ struct pci9118_private {
  	unsigned int ai_data_len;
  	unsigned short ao_data[2];		/* data output buffer */
  	unsigned int ai_scans;			/* number of scans to do */
-	char dma_doublebuf;			/* we can use double buffering */
+	char dma_doublebuf;			/* we can use double buffering*/
  	unsigned int dma_actbuf;		/* which buffer is used now */
  	unsigned short *dmabuf_virt[2];		/*
  						 * pointers to begin of
@@ -383,7 +383,7 @@ struct pci9118_private {
  						 * users(0-AI, 1-AO, 2-DI, 3-DO)
  						 */
  	unsigned int cnt0_divisor;		/* actual CNT0 divisor */
-	void (*int_ai_func) (struct comedi_device *, struct comedi_subdevice 
*,
+	void (*int_ai_func)(struct comedi_device *, struct comedi_subdevice *,
  		unsigned short,
  		unsigned int,
  		unsigned short);	/*
@@ -1045,7 +1045,7 @@ static void interrupt_pci9118_ai_dma(struct 
comedi_device *dev,
  		move_block_from_dma(dev, s,
  				    devpriv->dmabuf_virt[devpriv->dma_actbuf],
  				    samplesinbuf);
-		m = m - sampls;		/* m= how many samples was transferred */
+		m = m - sampls;		/* m=how many samples was transferred */
  	}

  	if (!devpriv->ai_neverending) {
-- 
1.7.10.4

