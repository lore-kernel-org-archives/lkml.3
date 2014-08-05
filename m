Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbaHEU67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 16:58:59 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:64200 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaHEU65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 16:58:57 -0400
From: Niklas Svensson <nks@flawful.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Niklas Svensson <nks@flawful.org>,
        Raghavendra Ganiga <ravi23ganiga@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/staging/comedi/drivers/comedi_test.c: fixed coding style problems
Date: Tue,  5 Aug 2014 22:58:03 +0200
Message-Id: <1407272283-4660-1-git-send-email-nks@flawful.org>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed checkpatch.pl warnings

Signed-off-by: Niklas Svensson <nks@flawful.org>
---
 drivers/staging/comedi/drivers/comedi_test.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/comedi_test.c b/drivers/staging/comedi/drivers/comedi_test.c
index 845a679..7aa23db 100644
--- a/drivers/staging/comedi/drivers/comedi_test.c
+++ b/drivers/staging/comedi/drivers/comedi_test.c
@@ -415,14 +415,14 @@ static int waveform_attach(struct comedi_device *dev,
 	for (i = 0; i < s->n_chan; i++)
 		devpriv->ao_loopbacks[i] = s->maxdata / 2;
 
-	init_timer(&(devpriv->timer));
+	init_timer(&devpriv->timer);
 	devpriv->timer.function = waveform_ai_interrupt;
 	devpriv->timer.data = (unsigned long)dev;
 
 	dev_info(dev->class_dev,
-		"%s: %i microvolt, %li microsecond waveform attached\n",
-		dev->board_name,
-		devpriv->uvolt_amplitude, devpriv->usec_period);
+		 "%s: %i microvolt, %li microsecond waveform attached\n",
+		 dev->board_name,
+		 devpriv->uvolt_amplitude, devpriv->usec_period);
 
 	return 0;
 }
-- 
2.0.4

