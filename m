Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab3ASGDY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 01:03:24 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:36301 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab3ASGDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 01:03:21 -0500
Date: Sat, 19 Jan 2013 01:03:32 -0500
From: Jake Champlin <jake.champlin.27@gmail.com>
To: abbotti@mev.co.uk
Cc: fmhess@users.sourceforge.net, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        hsweeten@visionengravers.com, jake.champlin.27@gmail.com
Subject: [PATCH] Staging: Comedi: pcl818: Fixed Coding Style Issues
Message-ID: <20130119060328.GA22447@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed single line if statement brace issues as well as pointer errors from
checkpatch.pl

Signed-off-by: Jake Champlin <jake.champlin.27@gmail.com>
---
 drivers/staging/comedi/drivers/pcl818.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 06127a5..b5af22e 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -243,8 +243,8 @@ static const struct comedi_lrange range_pcl818l_h_ai = { 4, {
 };
 
 static const struct comedi_lrange range718_bipolar1 = { 1, {BIP_RANGE(1),} };
-static const struct comedi_lrange range718_bipolar0_5 =
-    { 1, {BIP_RANGE(0.5),} };
+static const struct comedi_lrange range718_bipolar0_5 = {
+	1, {BIP_RANGE(0.5),} };
 static const struct comedi_lrange range718_unipolar2 = { 1, {UNI_RANGE(2),} };
 static const struct comedi_lrange range718_unipolar1 = { 1, {BIP_RANGE(1),} };
 
@@ -1005,17 +1005,14 @@ static int pcl818_ai_cmd_mode(int mode, struct comedi_device *dev,
 	switch (devpriv->dma) {
 	case 1:		/*  DMA */
 	case 3:
-		if (devpriv->dma_rtc == 0) {
+		if (devpriv->dma_rtc == 0)
 			pcl818_ai_mode13dma_int(mode, dev, s);
-		}
 #ifdef unused
-		else {
+		else
 			pcl818_ai_mode13dma_rtc(mode, dev, s);
-		}
 #else
-		else {
+		else
 			return -EINVAL;
-		}
 #endif
 		break;
 	case 0:
@@ -1069,7 +1066,7 @@ static int pcl818_ai_cmd_mode(int mode, struct comedi_device *dev,
 */
 #ifdef PCL818_MODE13_AO
 static int pcl818_ao_mode13(int mode, struct comedi_device *dev,
-			    struct comedi_subdevice *s, comedi_trig * it)
+			    struct comedi_subdevice *s, comedi_trig *it)
 {
 	struct pcl818_private *devpriv = dev->private;
 	int divisor1 = 0, divisor2 = 0;
@@ -1124,7 +1121,7 @@ static int pcl818_ao_mode13(int mode, struct comedi_device *dev,
    ANALOG OUTPUT MODE 1, 818 cards
 */
 static int pcl818_ao_mode1(struct comedi_device *dev,
-			   struct comedi_subdevice *s, comedi_trig * it)
+			   struct comedi_subdevice *s, comedi_trig *it)
 {
 	return pcl818_ao_mode13(1, dev, s, it);
 }
@@ -1134,7 +1131,7 @@ static int pcl818_ao_mode1(struct comedi_device *dev,
    ANALOG OUTPUT MODE 3, 818 cards
 */
 static int pcl818_ao_mode3(struct comedi_device *dev,
-			   struct comedi_subdevice *s, comedi_trig * it)
+			   struct comedi_subdevice *s, comedi_trig *it)
 {
 	return pcl818_ao_mode13(3, dev, s, it);
 }
-- 
1.8.1.1


-- 
Jake Champlin
jake.champlin.27@gmail.com
<MuttClient>
