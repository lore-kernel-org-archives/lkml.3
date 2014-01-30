Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbaA3CEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 21:04:23 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:53898 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaA3CEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 21:04:21 -0500
Date: Wed, 29 Jan 2014 21:04:17 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        mkrufky@linuxtv.org
Subject: [PATCH] update Michael Krufky's email address
Message-ID: <20140129210417.71833f4b@vujade>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am no longer available at the kernellabs.com or m1k.net email
addresses.  Update each instance of my email to my linuxtv.org
account.

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>

diff --git a/Documentation/dvb/contributors.txt
b/Documentation/dvb/contributors.txt index 47c3009..731a009 100644
--- a/Documentation/dvb/contributors.txt
+++ b/Documentation/dvb/contributors.txt
@@ -78,7 +78,7 @@ Peter Beutner <p.beutner@gmx.net>
 Wilson Michaels <wilsonmichaels@earthlink.net>
   for the lgdt330x frontend driver, and various bugfixes
 
-Michael Krufky <mkrufky@m1k.net>
+Michael Krufky <mkrufky@linuxtv.org>
   for maintaining v4l/dvb inter-tree dependencies
 
 Taylor Jacob <rtjacob@earthlink.net>
diff --git a/drivers/media/dvb-frontends/nxt200x.c
b/drivers/media/dvb-frontends/nxt200x.c index fbca985..67bdb5b 100644
--- a/drivers/media/dvb-frontends/nxt200x.c
+++ b/drivers/media/dvb-frontends/nxt200x.c
@@ -2,7 +2,7 @@
  *    Support for NXT2002 and NXT2004 - VSB/QAM
  *
  *    Copyright (C) 2005 Kirk Lapray <kirk.lapray@gmail.com>
- *    Copyright (C) 2006 Michael Krufky <mkrufky@m1k.net>
+ *    Copyright (C) 2006-2014 Michael Krufky <mkrufky@linuxtv.org>
  *    based on nxt2002 by Taylor Jacob <rtjacob@earthlink.net>
  *    and nxt2004 by Jean-Francois Thibert <jeanfrancois@sagetv.com>
  *
diff --git a/drivers/media/pci/bt8xx/bttv-cards.c
b/drivers/media/pci/bt8xx/bttv-cards.c index d85cb0a..6662b49 100644
--- a/drivers/media/pci/bt8xx/bttv-cards.c
+++ b/drivers/media/pci/bt8xx/bttv-cards.c
@@ -2426,7 +2426,7 @@ struct tvcard bttv_tvcards[] = {
 	},
 		/* ---- card 0x87---------------------------------- */
 	[BTTV_BOARD_DVICO_FUSIONHDTV_5_LITE] = {
-		/* Michael Krufky <mkrufky@m1k.net> */
+		/* Michael Krufky <mkrufky@linuxtv.org> */
 		.name           = "DViCO FusionHDTV 5 Lite",
 		.tuner_type     = TUNER_LG_TDVS_H06XF, /* TDVS-H064F */
 		.tuner_addr	= ADDR_UNSET,
diff --git a/drivers/media/pci/saa7134/saa7134-cards.c
b/drivers/media/pci/saa7134/saa7134-cards.c index d45e7f6..c9b2350
100644 --- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -2590,7 +2590,7 @@ struct saa7134_board saa7134_boards[] = {
 		}},
 	},
 	[SAA7134_BOARD_AVERMEDIA_AVERTVHD_A180] = {
-		/* Michael Krufky <mkrufky@m1k.net>
+		/* Michael Krufky <mkrufky@linuxtv.org>
 		 * Uses Alps Electric TDHU2, containing NXT2004 ATSC
Decoder
 		 * AFAIK, there is no analog demod, thus,
 		 * no support for analog television.
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c
b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c index d83df4b..0a98d04
100644 --- a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c
@@ -1,7 +1,7 @@
 /*
  *  mxl111sf-demod.c - driver for the MaxLinear MXL111SF DVB-T
demodulator *
- *  Copyright (C) 2010 Michael Krufky <mkrufky@kernellabs.com>
+ *  Copyright (C) 2010-2014 Michael Krufky <mkrufky@linuxtv.org>
  *
  *  This program is free software; you can redistribute it and/or
modify
  *  it under the terms of the GNU General Public License as published
by @@ -601,7 +601,7 @@ struct dvb_frontend
*mxl111sf_demod_attach(struct mxl111sf_state *mxl_state,
EXPORT_SYMBOL_GPL(mxl111sf_demod_attach); 
 MODULE_DESCRIPTION("MaxLinear MxL111SF DVB-T demodulator driver");
-MODULE_AUTHOR("Michael Krufky <mkrufky@kernellabs.com>");
+MODULE_AUTHOR("Michael Krufky <mkrufky@linuxtv.org>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("0.1");
 
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h
b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h index 3f3f8bf..2d4530f
100644 --- a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h
@@ -1,7 +1,7 @@
 /*
  *  mxl111sf-demod.h - driver for the MaxLinear MXL111SF DVB-T
demodulator *
- *  Copyright (C) 2010 Michael Krufky <mkrufky@kernellabs.com>
+ *  Copyright (C) 2010-2014 Michael Krufky <mkrufky@linuxtv.org>
  *
  *  This program is free software; you can redistribute it and/or
modify
  *  it under the terms of the GNU General Public License as published
by diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.c
b/drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.c index e4121cb..a619410
100644 --- a/drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.c
@@ -1,7 +1,7 @@
 /*
  *  mxl111sf-gpio.c - driver for the MaxLinear MXL111SF
  *
- *  Copyright (C) 2010 Michael Krufky <mkrufky@kernellabs.com>
+ *  Copyright (C) 2010-2014 Michael Krufky <mkrufky@linuxtv.org>
  *
  *  This program is free software; you can redistribute it and/or
modify
  *  it under the terms of the GNU General Public License as published
by diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.h
b/drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.h index 0220f54..b85a577
100644 --- a/drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.h
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.h
@@ -1,7 +1,7 @@
 /*
  *  mxl111sf-gpio.h - driver for the MaxLinear MXL111SF
  *
- *  Copyright (C) 2010 Michael Krufky <mkrufky@kernellabs.com>
+ *  Copyright (C) 2010-2014 Michael Krufky <mkrufky@linuxtv.org>
  *
  *  This program is free software; you can redistribute it and/or
modify
  *  it under the terms of the GNU General Public License as published
by diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c
b/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c index 3443455..a101d06
100644 --- a/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c
@@ -1,7 +1,7 @@
 /*
  *  mxl111sf-i2c.c - driver for the MaxLinear MXL111SF
  *
- *  Copyright (C) 2010 Michael Krufky <mkrufky@kernellabs.com>
+ *  Copyright (C) 2010-2014 Michael Krufky <mkrufky@linuxtv.org>
  *
  *  This program is free software; you can redistribute it and/or
modify
  *  it under the terms of the GNU General Public License as published
by diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.h
b/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.h index a57a45f..4657621
100644 --- a/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.h
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.h
@@ -1,7 +1,7 @@
 /*
  *  mxl111sf-i2c.h - driver for the MaxLinear MXL111SF
  *
- *  Copyright (C) 2010 Michael Krufky <mkrufky@kernellabs.com>
+ *  Copyright (C) 2010-2014 Michael Krufky <mkrufky@linuxtv.org>
  *
  *  This program is free software; you can redistribute it and/or
modify
  *  it under the terms of the GNU General Public License as published
by diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-phy.c
b/drivers/media/usb/dvb-usb-v2/mxl111sf-phy.c index b741b3a..f6b3480
100644 --- a/drivers/media/usb/dvb-usb-v2/mxl111sf-phy.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-phy.c
@@ -1,7 +1,7 @@
 /*
  *  mxl111sf-phy.c - driver for the MaxLinear MXL111SF
  *
- *  Copyright (C) 2010 Michael Krufky <mkrufky@kernellabs.com>
+ *  Copyright (C) 2010-2014 Michael Krufky <mkrufky@linuxtv.org>
  *
  *  This program is free software; you can redistribute it and/or
modify
  *  it under the terms of the GNU General Public License as published
by diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-phy.h
b/drivers/media/usb/dvb-usb-v2/mxl111sf-phy.h index f075607..0643738
100644 --- a/drivers/media/usb/dvb-usb-v2/mxl111sf-phy.h
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-phy.h
@@ -1,7 +1,7 @@
 /*
  *  mxl111sf-phy.h - driver for the MaxLinear MXL111SF
  *
- *  Copyright (C) 2010 Michael Krufky <mkrufky@kernellabs.com>
+ *  Copyright (C) 2010-2014 Michael Krufky <mkrufky@linuxtv.org>
  *
  *  This program is free software; you can redistribute it and/or
modify
  *  it under the terms of the GNU General Public License as published
by diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-reg.h
b/drivers/media/usb/dvb-usb-v2/mxl111sf-reg.h index 17831b0..89bf115
100644 --- a/drivers/media/usb/dvb-usb-v2/mxl111sf-reg.h
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-reg.h
@@ -1,7 +1,7 @@
 /*
  *  mxl111sf-reg.h - driver for the MaxLinear MXL111SF
  *
- *  Copyright (C) 2010 Michael Krufky <mkrufky@kernellabs.com>
+ *  Copyright (C) 2010-2014 Michael Krufky <mkrufky@linuxtv.org>
  *
  *  This program is free software; you can redistribute it and/or
modify
  *  it under the terms of the GNU General Public License as published
by diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c
b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c index 879c529..a8d2c70
100644 --- a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c
@@ -1,7 +1,7 @@
 /*
  *  mxl111sf-tuner.c - driver for the MaxLinear MXL111SF CMOS tuner
  *
- *  Copyright (C) 2010 Michael Krufky <mkrufky@kernellabs.com>
+ *  Copyright (C) 2010-2014 Michael Krufky <mkrufky@linuxtv.org>
  *
  *  This program is free software; you can redistribute it and/or
modify
  *  it under the terms of the GNU General Public License as published
by @@ -512,7 +512,7 @@ struct dvb_frontend
*mxl111sf_tuner_attach(struct dvb_frontend *fe,
EXPORT_SYMBOL_GPL(mxl111sf_tuner_attach); 
 MODULE_DESCRIPTION("MaxLinear MxL111SF CMOS tuner driver");
-MODULE_AUTHOR("Michael Krufky <mkrufky@kernellabs.com>");
+MODULE_AUTHOR("Michael Krufky <mkrufky@linuxtv.org>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("0.1");
 
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h
b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h index 90f583e..5fc0121
100644 --- a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h
@@ -1,7 +1,7 @@
 /*
  *  mxl111sf-tuner.h - driver for the MaxLinear MXL111SF CMOS tuner
  *
- *  Copyright (C) 2010 Michael Krufky <mkrufky@kernellabs.com>
+ *  Copyright (C) 2010-2014 Michael Krufky <mkrufky@linuxtv.org>
  *
  *  This program is free software; you can redistribute it and/or
modify
  *  it under the terms of the GNU General Public License as published
by diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
b/drivers/media/usb/dvb-usb-v2/mxl111sf.c index 08240e4..8ceff42 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2010 Michael Krufky (mkrufky@kernellabs.com)
+ * Copyright (C) 2010-2014 Michael Krufky (mkrufky@linuxtv.org)
  *
  *   This program is free software; you can redistribute it and/or
modify it
  *   under the terms of the GNU General Public License as published by
the Free @@ -1421,7 +1421,7 @@ static struct usb_driver
mxl111sf_usb_driver = { 
 module_usb_driver(mxl111sf_usb_driver);
 
-MODULE_AUTHOR("Michael Krufky <mkrufky@kernellabs.com>");
+MODULE_AUTHOR("Michael Krufky <mkrufky@linuxtv.org>");
 MODULE_DESCRIPTION("Driver for MaxLinear MxL111SF");
 MODULE_VERSION("1.0");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.h
b/drivers/media/usb/dvb-usb-v2/mxl111sf.h index 9816de8..8516c01 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.h
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2010 Michael Krufky (mkrufky@kernellabs.com)
+ * Copyright (C) 2010-2014 Michael Krufky (mkrufky@linuxtv.org)
  *
  *   This program is free software; you can redistribute it and/or
modify it
  *   under the terms of the GNU General Public License as published by
the Free
