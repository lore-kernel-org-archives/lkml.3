Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbaKDA0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 19:26:11 -0500
Received: from smtprelay0032.hostedemail.com ([216.40.44.32]:40571 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751176AbaKDA0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 19:26:05 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:69:355:379:541:960:966:968:973:982:988:989:1042:1087:1260:1345:1359:1437:1605:1730:1747:1777:1792:1801:2194:2196:2198:2199:2200:2201:2393:2538:2539:2559:2562:2693:2731:2734:2737:2892:2896:2899:2900:2901:2902:2904:2924:2925:2926:3138:3139:3140:3141:3142:3855:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4384:4385:4395:4423:4605:4647:5007:6238:6261:6690:6755:7208:7875:7903:8603:8660:8829:8957:9010:9121:9165:9592:10004:10226:10848:10945:10946:11026:11232:11233:11657:11914:12043:12050:12219:12291:12294:12296:12438:12517:12519:12555:12663:12681:12683:12707:12737:12740:13138:13148:13230:13231:13972:14096:14394:21060:21063:21080:21088,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rest34_6e875470ebf61
X-Filterd-Recvd-Size: 180985
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org
Subject: [PATCH V2 1/2] staging: ft1000: Whitespace neatening
Date: Mon,  3 Nov 2014 16:25:43 -0800
Message-Id: <9fb3af7c697cf0659efecd863fbbb25c4afc486a.1415060503.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141104000656.GA17825@kroah.com>
References: <20141104000656.GA17825@kroah.com>
In-Reply-To: <cover.1415060503.git.joe@perches.com>
References: <cover.1415060503.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use normal kernel style, indentation and alignment.

git diff -w shows no difference

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/boot.h        |   34 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000.h      |   30 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c   |   50 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c |  204 ++--
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |  686 +++++------
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c   | 1190 ++++++++++----------
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |  300 ++---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |  244 ++--
 drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h   |   60 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |   14 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |    2 +-
 11 files changed, 1407 insertions(+), 1407 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/boot.h b/drivers/staging/ft1000/ft1000-pcmcia/boot.h
index 60c015c..e4a6985 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/boot.h
+++ b/drivers/staging/ft1000/ft1000-pcmcia/boot.h
@@ -1,28 +1,28 @@
 /*---------------------------------------------------------------------------
-   FT1000 driver for Flarion Flash OFDM NIC Device
+  FT1000 driver for Flarion Flash OFDM NIC Device
 
-   Copyright (C) 2002 Flarion Technologies, All rights reserved.
+  Copyright (C) 2002 Flarion Technologies, All rights reserved.
 
-   This program is free software; you can redistribute it and/or modify it
-   under the terms of the GNU General Public License as published by the Free
-   Software Foundation; either version 2 of the License, or (at your option) any
-   later version. This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
-   or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
-   more details. You should have received a copy of the GNU General Public
-   License along with this program; if not, write to the
-   Free Software Foundation, Inc., 59 Temple Place -
-   Suite 330, Boston, MA 02111-1307, USA.
+  This program is free software; you can redistribute it and/or modify it
+  under the terms of the GNU General Public License as published by the Free
+  Software Foundation; either version 2 of the License, or (at your option) any
+  later version. This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+  more details. You should have received a copy of the GNU General Public
+  License along with this program; if not, write to the
+  Free Software Foundation, Inc., 59 Temple Place -
+  Suite 330, Boston, MA 02111-1307, USA.
   ---------------------------------------------------------------------------
 
-   File:         boot.h
+  File:         boot.h
 
-   Description:    boatloader
+  Description:    boatloader
 
-   History:
-   1/11/05    Whc                Ported to Linux.
+  History:
+  1/11/05    Whc                Ported to Linux.
 
----------------------------------------------------------------------------*/
+  ---------------------------------------------------------------------------*/
 #ifndef _BOOTH_
 #define _BOOTH_
 
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
index 1d52738..5992670 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
@@ -1,21 +1,21 @@
 /*---------------------------------------------------------------------------
-   FT1000 driver for Flarion Flash OFDM NIC Device
+  FT1000 driver for Flarion Flash OFDM NIC Device
 
-   Copyright (C) 2002 Flarion Technologies, All rights reserved.
+  Copyright (C) 2002 Flarion Technologies, All rights reserved.
 
-   This program is free software; you can redistribute it and/or modify it
-   under the terms of the GNU General Public License as published by the Free
-   Software Foundation; either version 2 of the License, or (at your option) any
-   later version. This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
-   or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
-   more details. You should have received a copy of the GNU General Public
-   License along with this program; if not, write to the
-   Free Software Foundation, Inc., 59 Temple Place -
-   Suite 330, Boston, MA 02111-1307, USA.
----------------------------------------------------------------------------
-   Description:    Common structures and defines
----------------------------------------------------------------------------*/
+  This program is free software; you can redistribute it and/or modify it
+  under the terms of the GNU General Public License as published by the Free
+  Software Foundation; either version 2 of the License, or (at your option) any
+  later version. This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+  more details. You should have received a copy of the GNU General Public
+  License along with this program; if not, write to the
+  Free Software Foundation, Inc., 59 Temple Place -
+  Suite 330, Boston, MA 02111-1307, USA.
+  ---------------------------------------------------------------------------
+  Description:    Common structures and defines
+  ---------------------------------------------------------------------------*/
 #ifndef _FT1000H_
 #define _FT1000H_
 
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
index 1f8b3ca..922478e 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
@@ -1,30 +1,30 @@
 /*---------------------------------------------------------------------------
-   FT1000 driver for Flarion Flash OFDM NIC Device
+  FT1000 driver for Flarion Flash OFDM NIC Device
 
-   Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
-   Copyright (C) 2002 Flarion Technologies, All rights reserved.
-   Copyright (C) 2006 Patrik Ostrihon, All rights reserved.
-   Copyright (C) 2006 ProWeb Consulting, a.s, All rights reserved.
+  Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
+  Copyright (C) 2002 Flarion Technologies, All rights reserved.
+  Copyright (C) 2006 Patrik Ostrihon, All rights reserved.
+  Copyright (C) 2006 ProWeb Consulting, a.s, All rights reserved.
 
-   The initial developer of the original code is David A. Hinds
-   <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds.
+  The initial developer of the original code is David A. Hinds
+  <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds.
 
-   This file was modified to support the Flarion Flash OFDM NIC Device
-   by Wai Chan (w.chan@flarion.com).
+  This file was modified to support the Flarion Flash OFDM NIC Device
+  by Wai Chan (w.chan@flarion.com).
 
-   Port for kernel 2.6 created by Patrik Ostrihon (patrik.ostrihon@pwc.sk)
+  Port for kernel 2.6 created by Patrik Ostrihon (patrik.ostrihon@pwc.sk)
 
-   This program is free software; you can redistribute it and/or modify it
-   under the terms of the GNU General Public License as published by the Free
-   Software Foundation; either version 2 of the License, or (at your option) any
-   later version. This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
-   or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
-   more details. You should have received a copy of the GNU General Public
-   License along with this program; if not, write to the
-   Free Software Foundation, Inc., 59 Temple Place -
-   Suite 330, Boston, MA 02111-1307, USA.
------------------------------------------------------------------------------*/
+  This program is free software; you can redistribute it and/or modify it
+  under the terms of the GNU General Public License as published by the Free
+  Software Foundation; either version 2 of the License, or (at your option) any
+  later version. This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+  more details. You should have received a copy of the GNU General Public
+  License along with this program; if not, write to the
+  Free Software Foundation, Inc., 59 Temple Place -
+  Suite 330, Boston, MA 02111-1307, USA.
+  -----------------------------------------------------------------------------*/
 
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -80,11 +80,11 @@ static int ft1000_confcheck(struct pcmcia_device *link, void *priv_data)
 
 /*======================================================================
 
-    ft1000_config() is scheduled to run after a CARD_INSERTION event
-    is received, to configure the PCMCIA socket, and to make the
-    device available to the system.
+  ft1000_config() is scheduled to run after a CARD_INSERTION event
+  is received, to configure the PCMCIA socket, and to make the
+  device available to the system.
 
-======================================================================*/
+  ======================================================================*/
 
 static int ft1000_config(struct pcmcia_device *link)
 {
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
index c1856f7..deb1256 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
@@ -1,24 +1,24 @@
 /*---------------------------------------------------------------------------
-   FT1000 driver for Flarion Flash OFDM NIC Device
-
-   Copyright (C) 2002 Flarion Technologies, All rights reserved.
-
-   This program is free software; you can redistribute it and/or modify it
-   under the terms of the GNU General Public License as published by the Free
-   Software Foundation; either version 2 of the License, or (at your option) any
-   later version. This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
-   or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
-   more details. You should have received a copy of the GNU General Public
-   License along with this program; if not, write to the
-   Free Software Foundation, Inc., 59 Temple Place -
-   Suite 330, Boston, MA 02111-1307, USA.
+  FT1000 driver for Flarion Flash OFDM NIC Device
+
+  Copyright (C) 2002 Flarion Technologies, All rights reserved.
+
+  This program is free software; you can redistribute it and/or modify it
+  under the terms of the GNU General Public License as published by the Free
+  Software Foundation; either version 2 of the License, or (at your option) any
+  later version. This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+  more details. You should have received a copy of the GNU General Public
+  License along with this program; if not, write to the
+  Free Software Foundation, Inc., 59 Temple Place -
+  Suite 330, Boston, MA 02111-1307, USA.
   --------------------------------------------------------------------------
 
-   Description: This module will handshake with the DSP bootloader to
-		download the DSP runtime image.
+  Description: This module will handshake with the DSP bootloader to
+  download the DSP runtime image.
 
----------------------------------------------------------------------------*/
+  ---------------------------------------------------------------------------*/
 
 #define __KERNEL_SYSCALLS__
 
@@ -114,7 +114,7 @@ struct dsp_image_info {
 
 void card_bootload(struct net_device *dev)
 {
-	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev);
+	struct ft1000_info *info = (struct ft1000_info *)netdev_priv(dev);
 	unsigned long flags;
 	u32 *pdata;
 	u32 size;
@@ -123,7 +123,7 @@ void card_bootload(struct net_device *dev)
 
 	netdev_dbg(dev, "card_bootload is called\n");
 
-	pdata = (u32 *) bootimage;
+	pdata = (u32 *)bootimage;
 	size = sizeof(bootimage);
 
 	/* check for odd word */
@@ -146,7 +146,7 @@ void card_bootload(struct net_device *dev)
 
 u16 get_handshake(struct net_device *dev, u16 expected_value)
 {
-	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev);
+	struct ft1000_info *info = (struct ft1000_info *)netdev_priv(dev);
 	u16 handshake;
 	u32 tempx;
 	int loopcnt;
@@ -161,12 +161,12 @@ u16 get_handshake(struct net_device *dev, u16 expected_value)
 		} else {
 			tempx =
 				ntohl(ft1000_read_dpram_mag_32
-				  (dev, DWNLD_MAG_HANDSHAKE_LOC));
-			handshake = (u16) tempx;
+				      (dev, DWNLD_MAG_HANDSHAKE_LOC));
+			handshake = (u16)tempx;
 		}
 
 		if ((handshake == expected_value)
-			|| (handshake == HANDSHAKE_RESET_VALUE)) {
+		    || (handshake == HANDSHAKE_RESET_VALUE)) {
 			return handshake;
 		}
 		loopcnt++;
@@ -180,7 +180,7 @@ u16 get_handshake(struct net_device *dev, u16 expected_value)
 
 void put_handshake(struct net_device *dev, u16 handshake_value)
 {
-	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev);
+	struct ft1000_info *info = (struct ft1000_info *)netdev_priv(dev);
 	u32 tempx;
 
 	if (info->AsicID == ELECTRABUZZ_ID) {
@@ -188,7 +188,7 @@ void put_handshake(struct net_device *dev, u16 handshake_value)
 				 DWNLD_HANDSHAKE_LOC);
 		ft1000_write_reg(dev, FT1000_REG_DPRAM_DATA, handshake_value);	/* Handshake */
 	} else {
-		tempx = (u32) handshake_value;
+		tempx = (u32)handshake_value;
 		tempx = ntohl(tempx);
 		ft1000_write_dpram_mag_32(dev, DWNLD_MAG_HANDSHAKE_LOC, tempx);	/* Handshake */
 	}
@@ -196,7 +196,7 @@ void put_handshake(struct net_device *dev, u16 handshake_value)
 
 u16 get_request_type(struct net_device *dev)
 {
-	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev);
+	struct ft1000_info *info = (struct ft1000_info *)netdev_priv(dev);
 	u16 request_type;
 	u32 tempx;
 
@@ -206,7 +206,7 @@ u16 get_request_type(struct net_device *dev)
 	} else {
 		tempx = ft1000_read_dpram_mag_32(dev, DWNLD_MAG_TYPE_LOC);
 		tempx = ntohl(tempx);
-		request_type = (u16) tempx;
+		request_type = (u16)tempx;
 	}
 
 	return request_type;
@@ -215,7 +215,7 @@ u16 get_request_type(struct net_device *dev)
 
 long get_request_value(struct net_device *dev)
 {
-	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev);
+	struct ft1000_info *info = (struct ft1000_info *)netdev_priv(dev);
 	long value;
 	u16 w_val;
 
@@ -244,7 +244,7 @@ long get_request_value(struct net_device *dev)
 
 void put_request_value(struct net_device *dev, long lvalue)
 {
-	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev);
+	struct ft1000_info *info = (struct ft1000_info *)netdev_priv(dev);
 	u16 size;
 	u32 tempx;
 
@@ -271,11 +271,11 @@ void put_request_value(struct net_device *dev, long lvalue)
 
 u16 hdr_checksum(struct pseudo_hdr *pHdr)
 {
-	u16 *usPtr = (u16 *) pHdr;
+	u16 *usPtr = (u16 *)pHdr;
 	u16 chksum;
 
 	chksum = ((((((usPtr[0] ^ usPtr[1]) ^ usPtr[2]) ^ usPtr[3]) ^
-			usPtr[4]) ^ usPtr[5]) ^ usPtr[6]);
+		    usPtr[4]) ^ usPtr[5]) ^ usPtr[6]);
 
 	return chksum;
 }
@@ -283,7 +283,7 @@ u16 hdr_checksum(struct pseudo_hdr *pHdr)
 int card_download(struct net_device *dev, const u8 *pFileStart,
 		  size_t FileLength)
 {
-	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev);
+	struct ft1000_info *info = (struct ft1000_info *)netdev_priv(dev);
 	int Status = SUCCESS;
 	u32 uiState;
 	u16 handshake;
@@ -322,7 +322,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 
 	uiState = STATE_START_DWNLD;
 
-	pFileHdr5 = (struct dsp_file_hdr *) pFileStart;
+	pFileHdr5 = (struct dsp_file_hdr *)pFileStart;
 
 	pUsFile = (u16 *) ((long)pFileStart + pFileHdr5->loader_offset);
 	pUcFile = (u8 *) ((long)pFileStart + pFileHdr5->loader_offset);
@@ -376,7 +376,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 						break;
 					}
 					if ((word_length * 2 + (long)pUcFile) >
-						(long)pBootEnd) {
+					    (long)pBootEnd) {
 						/*
 						 * Error, beyond boot code range.
 						 */
@@ -390,8 +390,8 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 					 * Position ASIC DPRAM auto-increment pointer.
 					 */
 					outw(DWNLD_MAG_PS_HDR_LOC,
-						 dev->base_addr +
-						 FT1000_REG_DPRAM_ADDR);
+					     dev->base_addr +
+					     FT1000_REG_DPRAM_ADDR);
 					if (word_length & 0x01)
 						word_length++;
 					word_length = word_length / 2;
@@ -402,12 +402,12 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 							(*pUsFile++ << 16);
 						pUcFile += 4;
 						outl(templong,
-							 dev->base_addr +
-							 FT1000_REG_MAG_DPDATAL);
+						     dev->base_addr +
+						     FT1000_REG_MAG_DPDATAL);
 					}
 					spin_unlock_irqrestore(&info->
-								   dpram_lock,
-								   flags);
+							       dpram_lock,
+							       flags);
 					break;
 				default:
 					Status = FAILURE;
@@ -430,7 +430,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 				switch (request) {
 				case REQUEST_FILE_CHECKSUM:
 					netdev_dbg(dev,
-						  "ft1000_dnld: REQUEST_FOR_CHECKSUM\n");
+						   "ft1000_dnld: REQUEST_FOR_CHECKSUM\n");
 					put_request_value(dev, image_chksum);
 					break;
 				case REQUEST_RUN_ADDRESS:
@@ -468,7 +468,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 						break;
 					}
 					if ((word_length * 2 + (long)pUcFile) >
-						(long)pCodeEnd) {
+					    (long)pCodeEnd) {
 						/*
 						 * Error, beyond boot code range.
 						 */
@@ -479,8 +479,8 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 					 * Position ASIC DPRAM auto-increment pointer.
 					 */
 					outw(DWNLD_MAG_PS_HDR_LOC,
-						 dev->base_addr +
-						 FT1000_REG_DPRAM_ADDR);
+					     dev->base_addr +
+					     FT1000_REG_DPRAM_ADDR);
 					if (word_length & 0x01)
 						word_length++;
 					word_length = word_length / 2;
@@ -491,8 +491,8 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 							(*pUsFile++ << 16);
 						pUcFile += 4;
 						outl(templong,
-							 dev->base_addr +
-							 FT1000_REG_MAG_DPDATAL);
+						     dev->base_addr +
+						     FT1000_REG_MAG_DPDATAL);
 					}
 					break;
 
@@ -502,9 +502,9 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 						(long)(info->DSPInfoBlklen + 1) / 2;
 					put_request_value(dev, word_length);
 					pMailBoxData =
-						(struct drv_msg *) &info->DSPInfoBlk[0];
+						(struct drv_msg *)&info->DSPInfoBlk[0];
 					pUsData =
-						(u16 *) &pMailBoxData->data[0];
+						(u16 *)&pMailBoxData->data[0];
 					/* Provide mutual exclusive access while reading ASIC registers. */
 					spin_lock_irqsave(&info->dpram_lock,
 							  flags);
@@ -528,8 +528,8 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 						 * Position ASIC DPRAM auto-increment pointer.
 						 */
 						outw(DWNLD_MAG_PS_HDR_LOC,
-							 dev->base_addr +
-							 FT1000_REG_DPRAM_ADDR);
+						     dev->base_addr +
+						     FT1000_REG_DPRAM_ADDR);
 						if (word_length & 0x01)
 							word_length++;
 
@@ -540,13 +540,13 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 							templong |=
 								(*pUsData++ << 16);
 							outl(templong,
-								 dev->base_addr +
-								 FT1000_REG_MAG_DPDATAL);
+							     dev->base_addr +
+							     FT1000_REG_MAG_DPDATAL);
 						}
 					}
 					spin_unlock_irqrestore(&info->
-								   dpram_lock,
-								   flags);
+							       dpram_lock,
+							       flags);
 					break;
 
 				case REQUEST_VERSION_INFO:
@@ -555,8 +555,8 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 					put_request_value(dev, word_length);
 					pUsFile =
 						(u16 *) ((long)pFileStart +
-							pFileHdr5->
-							version_data_offset);
+							 pFileHdr5->
+							 version_data_offset);
 					/* Provide mutual exclusive access while reading ASIC registers. */
 					spin_lock_irqsave(&info->dpram_lock,
 							  flags);
@@ -564,8 +564,8 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 					 * Position ASIC DPRAM auto-increment pointer.
 					 */
 					outw(DWNLD_MAG_PS_HDR_LOC,
-						 dev->base_addr +
-						 FT1000_REG_DPRAM_ADDR);
+					     dev->base_addr +
+					     FT1000_REG_DPRAM_ADDR);
 					if (word_length & 0x01)
 						word_length++;
 					word_length = word_length / 2;
@@ -578,12 +578,12 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 						templong |=
 							(temp << 16);
 						outl(templong,
-							 dev->base_addr +
-							 FT1000_REG_MAG_DPDATAL);
+						     dev->base_addr +
+						     FT1000_REG_MAG_DPDATAL);
 					}
 					spin_unlock_irqrestore(&info->
-								   dpram_lock,
-								   flags);
+							       dpram_lock,
+							       flags);
 					break;
 
 				case REQUEST_CODE_BY_VERSION:
@@ -592,14 +592,14 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 						get_request_value(dev);
 					pDspImageInfoV6 =
 						(struct dsp_image_info *) ((long)
-								  pFileStart
-								  +
-								  sizeof
-								  (struct dsp_file_hdr));
+									   pFileStart
+									   +
+									   sizeof
+									   (struct dsp_file_hdr));
 					for (imageN = 0;
-						 imageN <
-						 pFileHdr5->nDspImages;
-						 imageN++) {
+					     imageN <
+						     pFileHdr5->nDspImages;
+					     imageN++) {
 						temp = (u16)
 							(pDspImageInfoV6->
 							 version);
@@ -610,30 +610,30 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 						templong |=
 							(temp << 16);
 						if (templong ==
-							requested_version) {
+						    requested_version) {
 							bGoodVersion =
 								true;
 							pUsFile =
 								(u16
 								 *) ((long)
-								 pFileStart
-								 +
-								 pDspImageInfoV6->
-								 begin_offset);
+								     pFileStart
+								     +
+								     pDspImageInfoV6->
+								     begin_offset);
 							pUcFile =
 								(u8
 								 *) ((long)
-								 pFileStart
-								 +
-								 pDspImageInfoV6->
-								 begin_offset);
+								     pFileStart
+								     +
+								     pDspImageInfoV6->
+								     begin_offset);
 							pCodeEnd =
 								(u8
 								 *) ((long)
-								 pFileStart
-								 +
-								 pDspImageInfoV6->
-								 end_offset);
+								     pFileStart
+								     +
+								     pDspImageInfoV6->
+								     end_offset);
 							run_address =
 								pDspImageInfoV6->
 								run_address;
@@ -645,10 +645,10 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 								pDspImageInfoV6->
 								checksum;
 							netdev_dbg(dev,
-								  "ft1000_dnld: image_chksum = 0x%8x\n",
-								  (unsigned
-								   int)
-								  image_chksum);
+								   "ft1000_dnld: image_chksum = 0x%8x\n",
+								   (unsigned
+								    int)
+								   image_chksum);
 							break;
 						}
 						pDspImageInfoV6++;
@@ -674,25 +674,25 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 			break;
 
 		case STATE_DONE_DWNLD:
-			if (((unsigned long) (pUcFile) - (unsigned long) pFileStart) >=
-				(unsigned long) FileLength) {
+			if (((unsigned long)(pUcFile) - (unsigned long) pFileStart) >=
+			    (unsigned long)FileLength) {
 				uiState = STATE_DONE_FILE;
 				break;
 			}
 
-			pHdr = (struct pseudo_hdr *) pUsFile;
+			pHdr = (struct pseudo_hdr *)pUsFile;
 
 			if (pHdr->portdest == 0x80	/* DspOAM */
-				&& (pHdr->portsrc == 0x00	/* Driver */
+			    && (pHdr->portsrc == 0x00	/* Driver */
 				|| pHdr->portsrc == 0x10 /* FMM */)) {
 				uiState = STATE_SECTION_PROV;
 			} else {
 				netdev_dbg(dev,
-					  "FT1000:download:Download error: Bad Port IDs in Pseudo Record\n");
+					   "FT1000:download:Download error: Bad Port IDs in Pseudo Record\n");
 				netdev_dbg(dev, "\t Port Source = 0x%2.2x\n",
-					  pHdr->portsrc);
+					   pHdr->portsrc);
 				netdev_dbg(dev, "\t Port Destination = 0x%2.2x\n",
-					  pHdr->portdest);
+					   pHdr->portdest);
 				Status = FAILURE;
 			}
 
@@ -700,7 +700,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 
 		case STATE_SECTION_PROV:
 
-			pHdr = (struct pseudo_hdr *) pUcFile;
+			pHdr = (struct pseudo_hdr *)pUcFile;
 
 			if (pHdr->checksum == hdr_checksum(pHdr)) {
 				if (pHdr->portdest != 0x80 /* Dsp OAM */) {
@@ -715,8 +715,8 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 						GFP_ATOMIC);
 				if (pbuffer) {
 					memcpy(pbuffer, (void *)pUcFile,
-						   (u32) (usHdrLength +
-							   sizeof(struct pseudo_hdr)));
+					       (u32) (usHdrLength +
+						      sizeof(struct pseudo_hdr)));
 					/* link provisioning data */
 					pprov_record =
 						kmalloc(sizeof(struct prov_record),
@@ -725,15 +725,15 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 						pprov_record->pprov_data =
 							pbuffer;
 						list_add_tail(&pprov_record->
-								  list,
-								  &info->prov_list);
+							      list,
+							      &info->prov_list);
 						/* Move to next entry if available */
 						pUcFile =
-							(u8 *) ((unsigned long) pUcFile +
-								   (unsigned long) ((usHdrLength + 1) & 0xFFFFFFFE) + sizeof(struct pseudo_hdr));
+							(u8 *)((unsigned long) pUcFile +
+							       (unsigned long) ((usHdrLength + 1) & 0xFFFFFFFE) + sizeof(struct pseudo_hdr));
 						if ((unsigned long) (pUcFile) -
-							(unsigned long) (pFileStart) >=
-							(unsigned long) FileLength) {
+						    (unsigned long) (pFileStart) >=
+						    (unsigned long)FileLength) {
 							uiState =
 								STATE_DONE_FILE;
 						}
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index 25b06d3..c6bee28 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -1,20 +1,20 @@
 /*---------------------------------------------------------------------------
-   FT1000 driver for Flarion Flash OFDM NIC Device
-
-   Copyright (C) 2002 Flarion Technologies, All rights reserved.
-   Copyright (C) 2006 Patrik Ostrihon, All rights reserved.
-   Copyright (C) 2006 ProWeb Consulting, a.s, All rights reserved.
-
-   This program is free software; you can redistribute it and/or modify it
-   under the terms of the GNU General Public License as published by the Free
-   Software Foundation; either version 2 of the License, or (at your option) any
-   later version. This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
-   or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
-   more details. You should have received a copy of the GNU General Public
-   License along with this program; if not, write to the
-   Free Software Foundation, Inc., 59 Temple Place -
-   Suite 330, Boston, MA 02111-1307, USA.
+  FT1000 driver for Flarion Flash OFDM NIC Device
+
+  Copyright (C) 2002 Flarion Technologies, All rights reserved.
+  Copyright (C) 2006 Patrik Ostrihon, All rights reserved.
+  Copyright (C) 2006 ProWeb Consulting, a.s, All rights reserved.
+
+  This program is free software; you can redistribute it and/or modify it
+  under the terms of the GNU General Public License as published by the Free
+  Software Foundation; either version 2 of the License, or (at your option) any
+  later version. This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+  more details. You should have received a copy of the GNU General Public
+  License along with this program; if not, write to the
+  Free Software Foundation, Inc., 59 Temple Place -
+  Suite 330, Boston, MA 02111-1307, USA.
   -------------------------------------------------------------------------*/
 
 #include <linux/kernel.h>
@@ -57,7 +57,7 @@ static const struct firmware *fw_entry;
 
 static void ft1000_hbchk(u_long data);
 static struct timer_list poll_timer = {
-      .function = ft1000_hbchk
+	.function = ft1000_hbchk
 };
 
 static u16 cmdbuffer[1024];
@@ -72,7 +72,7 @@ static void ft1000_disable_interrupts(struct net_device *dev);
 /* new kernel */
 MODULE_AUTHOR("");
 MODULE_DESCRIPTION
-    ("Support for Flarion Flash OFDM NIC Device. Support for PCMCIA when used with ft1000_cs.");
+("Support for Flarion Flash OFDM NIC Device. Support for PCMCIA when used with ft1000_cs.");
 MODULE_LICENSE("GPL");
 MODULE_SUPPORTED_DEVICE("FT1000");
 
@@ -80,15 +80,15 @@ MODULE_SUPPORTED_DEVICE("FT1000");
 
 /*---------------------------------------------------------------------------
 
-   Function:   ft1000_read_fifo_len
-   Description: This function will read the ASIC Uplink FIFO status register
-               which will return the number of bytes remaining in the Uplink FIFO.
-               Sixteen bytes are subtracted to make sure that the ASIC does not
-               reach its threshold.
-   Input:
-       dev    - network device structure
-   Output:
-       value  - number of bytes available in the ASIC Uplink FIFO.
+  Function:   ft1000_read_fifo_len
+  Description: This function will read the ASIC Uplink FIFO status register
+  which will return the number of bytes remaining in the Uplink FIFO.
+  Sixteen bytes are subtracted to make sure that the ASIC does not
+  reach its threshold.
+  Input:
+  dev    - network device structure
+  Output:
+  value  - number of bytes available in the ASIC Uplink FIFO.
 
   -------------------------------------------------------------------------*/
 static inline u16 ft1000_read_fifo_len(struct net_device *dev)
@@ -103,14 +103,14 @@ static inline u16 ft1000_read_fifo_len(struct net_device *dev)
 
 /*---------------------------------------------------------------------------
 
-   Function:   ft1000_read_dpram
-   Description: This function will read the specific area of dpram
-               (Electrabuzz ASIC only)
-   Input:
-       dev    - device structure
-       offset - index of dpram
-   Output:
-       value  - value of dpram
+  Function:   ft1000_read_dpram
+  Description: This function will read the specific area of dpram
+  (Electrabuzz ASIC only)
+  Input:
+  dev    - device structure
+  offset - index of dpram
+  Output:
+  value  - value of dpram
 
   -------------------------------------------------------------------------*/
 u16 ft1000_read_dpram(struct net_device *dev, int offset)
@@ -130,19 +130,19 @@ u16 ft1000_read_dpram(struct net_device *dev, int offset)
 
 /*---------------------------------------------------------------------------
 
-   Function:   ft1000_write_dpram
-   Description: This function will write to a specific area of dpram
-               (Electrabuzz ASIC only)
-   Input:
-       dev    - device structure
-       offset - index of dpram
-       value  - value to write
-   Output:
-       none.
+  Function:   ft1000_write_dpram
+  Description: This function will write to a specific area of dpram
+  (Electrabuzz ASIC only)
+  Input:
+  dev    - device structure
+  offset - index of dpram
+  value  - value to write
+  Output:
+  none.
 
   -------------------------------------------------------------------------*/
 static inline void ft1000_write_dpram(struct net_device *dev,
-					  int offset, u16 value)
+				      int offset, u16 value)
 {
 	struct ft1000_info *info = netdev_priv(dev);
 	unsigned long flags;
@@ -156,14 +156,14 @@ static inline void ft1000_write_dpram(struct net_device *dev,
 
 /*---------------------------------------------------------------------------
 
-   Function:   ft1000_read_dpram_mag_16
-   Description: This function will read the specific area of dpram
-               (Magnemite ASIC only)
-   Input:
-       dev    - device structure
-       offset - index of dpram
-   Output:
-       value  - value of dpram
+  Function:   ft1000_read_dpram_mag_16
+  Description: This function will read the specific area of dpram
+  (Magnemite ASIC only)
+  Input:
+  dev    - device structure
+  offset - index of dpram
+  Output:
+  value  - value of dpram
 
   -------------------------------------------------------------------------*/
 u16 ft1000_read_dpram_mag_16(struct net_device *dev, int offset, int Index)
@@ -188,19 +188,19 @@ u16 ft1000_read_dpram_mag_16(struct net_device *dev, int offset, int Index)
 
 /*---------------------------------------------------------------------------
 
-   Function:   ft1000_write_dpram_mag_16
-   Description: This function will write to a specific area of dpram
-               (Magnemite ASIC only)
-   Input:
-       dev    - device structure
-       offset - index of dpram
-       value  - value to write
-   Output:
-       none.
+  Function:   ft1000_write_dpram_mag_16
+  Description: This function will write to a specific area of dpram
+  (Magnemite ASIC only)
+  Input:
+  dev    - device structure
+  offset - index of dpram
+  value  - value to write
+  Output:
+  none.
 
   -------------------------------------------------------------------------*/
 static inline void ft1000_write_dpram_mag_16(struct net_device *dev,
-						 int offset, u16 value, int Index)
+					     int offset, u16 value, int Index)
 {
 	struct ft1000_info *info = netdev_priv(dev);
 	unsigned long flags;
@@ -218,14 +218,14 @@ static inline void ft1000_write_dpram_mag_16(struct net_device *dev,
 
 /*---------------------------------------------------------------------------
 
-   Function:   ft1000_read_dpram_mag_32
-   Description: This function will read the specific area of dpram
-               (Magnemite ASIC only)
-   Input:
-       dev    - device structure
-       offset - index of dpram
-   Output:
-       value  - value of dpram
+  Function:   ft1000_read_dpram_mag_32
+  Description: This function will read the specific area of dpram
+  (Magnemite ASIC only)
+  Input:
+  dev    - device structure
+  offset - index of dpram
+  Output:
+  value  - value of dpram
 
   -------------------------------------------------------------------------*/
 u32 ft1000_read_dpram_mag_32(struct net_device *dev, int offset)
@@ -245,15 +245,15 @@ u32 ft1000_read_dpram_mag_32(struct net_device *dev, int offset)
 
 /*---------------------------------------------------------------------------
 
-   Function:   ft1000_write_dpram_mag_32
-   Description: This function will write to a specific area of dpram
-               (Magnemite ASIC only)
-   Input:
-       dev    - device structure
-       offset - index of dpram
-       value  - value to write
-   Output:
-       none.
+  Function:   ft1000_write_dpram_mag_32
+  Description: This function will write to a specific area of dpram
+  (Magnemite ASIC only)
+  Input:
+  dev    - device structure
+  offset - index of dpram
+  value  - value to write
+  Output:
+  none.
 
   -------------------------------------------------------------------------*/
 void ft1000_write_dpram_mag_32(struct net_device *dev, int offset, u32 value)
@@ -270,12 +270,12 @@ void ft1000_write_dpram_mag_32(struct net_device *dev, int offset, u32 value)
 
 /*---------------------------------------------------------------------------
 
-   Function:   ft1000_enable_interrupts
-   Description: This function will enable interrupts base on the current interrupt mask.
-   Input:
-       dev    - device structure
-   Output:
-       None.
+  Function:   ft1000_enable_interrupts
+  Description: This function will enable interrupts base on the current interrupt mask.
+  Input:
+  dev    - device structure
+  Output:
+  None.
 
   -------------------------------------------------------------------------*/
 static void ft1000_enable_interrupts(struct net_device *dev)
@@ -286,18 +286,18 @@ static void ft1000_enable_interrupts(struct net_device *dev)
 	ft1000_write_reg(dev, FT1000_REG_SUP_IMASK, ISR_DEFAULT_MASK);
 	tempword = ft1000_read_reg(dev, FT1000_REG_SUP_IMASK);
 	DEBUG(1,
-		  "ft1000_hw:ft1000_enable_interrupts:current interrupt enable mask = 0x%x\n",
-		  tempword);
+	      "ft1000_hw:ft1000_enable_interrupts:current interrupt enable mask = 0x%x\n",
+	      tempword);
 }
 
 /*---------------------------------------------------------------------------
 
-   Function:   ft1000_disable_interrupts
-   Description: This function will disable all interrupts.
-   Input:
-       dev    - device structure
-   Output:
-       None.
+  Function:   ft1000_disable_interrupts
+  Description: This function will disable all interrupts.
+  Input:
+  dev    - device structure
+  Output:
+  None.
 
   -------------------------------------------------------------------------*/
 static void ft1000_disable_interrupts(struct net_device *dev)
@@ -308,19 +308,19 @@ static void ft1000_disable_interrupts(struct net_device *dev)
 	ft1000_write_reg(dev, FT1000_REG_SUP_IMASK, ISR_MASK_ALL);
 	tempword = ft1000_read_reg(dev, FT1000_REG_SUP_IMASK);
 	DEBUG(1,
-		  "ft1000_hw:ft1000_disable_interrupts:current interrupt enable mask = 0x%x\n",
-		  tempword);
+	      "ft1000_hw:ft1000_disable_interrupts:current interrupt enable mask = 0x%x\n",
+	      tempword);
 }
 
 /*---------------------------------------------------------------------------
 
-   Function:   ft1000_reset_asic
-   Description: This function will call the Card Service function to reset the
-               ASIC.
-   Input:
-       dev    - device structure
-   Output:
-       none
+  Function:   ft1000_reset_asic
+  Description: This function will call the Card Service function to reset the
+  ASIC.
+  Input:
+  dev    - device structure
+  Output:
+  none
 
   -------------------------------------------------------------------------*/
 static void ft1000_reset_asic(struct net_device *dev)
@@ -360,13 +360,13 @@ static void ft1000_reset_asic(struct net_device *dev)
 
 /*---------------------------------------------------------------------------
 
-   Function:   ft1000_reset_card
-   Description: This function will reset the card
-   Input:
-       dev    - device structure
-   Output:
-       status - false (card reset fail)
-                true  (card reset successful)
+  Function:   ft1000_reset_card
+  Description: This function will reset the card
+  Input:
+  dev    - device structure
+  Output:
+  status - false (card reset fail)
+  true  (card reset successful)
 
   -------------------------------------------------------------------------*/
 static int ft1000_reset_card(struct net_device *dev)
@@ -389,7 +389,7 @@ static int ft1000_reset_card(struct net_device *dev)
 	/* Make sure we free any memory reserve for provisioning */
 	while (list_empty(&info->prov_list) == 0) {
 		DEBUG(0,
-			  "ft1000_hw:ft1000_reset_card:deleting provisioning record\n");
+		      "ft1000_hw:ft1000_reset_card:deleting provisioning record\n");
 		ptr = list_entry(info->prov_list.next, struct prov_record, list);
 		list_del(&ptr->list);
 		kfree(ptr->pprov_data);
@@ -401,7 +401,7 @@ static int ft1000_reset_card(struct net_device *dev)
 		ft1000_write_reg(dev, FT1000_REG_RESET, DSP_RESET_BIT);
 	} else {
 		DEBUG(1,
-			  "ft1000_hw:ft1000_reset_card:resetting ASIC and DSP\n");
+		      "ft1000_hw:ft1000_reset_card:resetting ASIC and DSP\n");
 		ft1000_write_reg(dev, FT1000_REG_RESET,
 				 (DSP_RESET_BIT | ASIC_RESET_BIT));
 	}
@@ -438,7 +438,7 @@ static int ft1000_reset_card(struct net_device *dev)
 	if (info->AsicID == MAGNEMITE_ID) {
 		/* Put dsp in reset and take ASIC out of reset */
 		DEBUG(0,
-			  "ft1000_hw:ft1000_reset_card:Put DSP in reset and take ASIC out of reset\n");
+		      "ft1000_hw:ft1000_reset_card:Put DSP in reset and take ASIC out of reset\n");
 		ft1000_write_reg(dev, FT1000_REG_RESET, DSP_RESET_BIT);
 
 		/* Setting MAGNEMITE ASIC to big endian mode */
@@ -465,7 +465,7 @@ static int ft1000_reset_card(struct net_device *dev)
 
 		if (i == 50) {
 			DEBUG(0,
-				  "ft1000_hw:ft1000_reset_card:No FEFE detected from DSP\n");
+			      "ft1000_hw:ft1000_reset_card:No FEFE detected from DSP\n");
 			return false;
 		}
 
@@ -495,7 +495,7 @@ static int ft1000_reset_card(struct net_device *dev)
 		ft1000_write_dpram(dev, FT1000_HI_HO, ho);
 		tempword = ft1000_read_dpram(dev, FT1000_HI_HO);
 		DEBUG(1, "ft1000_hw:ft1000_reset_asic:hi_ho value = 0x%x\n",
-			  tempword);
+		      tempword);
 	} else {
 		/* Initialize DSP heartbeat area to ho */
 		ft1000_write_dpram_mag_16(dev, FT1000_MAG_HI_HO, ho_mag,
@@ -504,7 +504,7 @@ static int ft1000_reset_card(struct net_device *dev)
 			ft1000_read_dpram_mag_16(dev, FT1000_MAG_HI_HO,
 						 FT1000_MAG_HI_HO_INDX);
 		DEBUG(1, "ft1000_hw:ft1000_reset_card:hi_ho value = 0x%x\n",
-			  tempword);
+		      tempword);
 	}
 
 	info->CardReady = 1;
@@ -521,14 +521,14 @@ static int ft1000_reset_card(struct net_device *dev)
 
 /*---------------------------------------------------------------------------
 
-   Function:   ft1000_chkcard
-   Description: This function will check if the device is presently available on
-               the system.
-   Input:
-       dev    - device structure
-   Output:
-       status - false (device is not present)
-                true  (device is present)
+  Function:   ft1000_chkcard
+  Description: This function will check if the device is presently available on
+  the system.
+  Input:
+  dev    - device structure
+  Output:
+  status - false (device is not present)
+  true  (device is present)
 
   -------------------------------------------------------------------------*/
 static int ft1000_chkcard(struct net_device *dev)
@@ -542,7 +542,7 @@ static int ft1000_chkcard(struct net_device *dev)
 	tempword = ft1000_read_reg(dev, FT1000_REG_SUP_IMASK);
 	if (tempword == 0) {
 		DEBUG(1,
-			  "ft1000_hw:ft1000_chkcard: IMASK = 0 Card not detected\n");
+		      "ft1000_hw:ft1000_chkcard: IMASK = 0 Card not detected\n");
 		return false;
 	}
 	/*
@@ -552,7 +552,7 @@ static int ft1000_chkcard(struct net_device *dev)
 	tempword = ft1000_read_reg(dev, FT1000_REG_ASIC_ID);
 	if (tempword == 0xffff) {
 		DEBUG(1,
-			  "ft1000_hw:ft1000_chkcard: Version = 0xffff Card not detected\n");
+		      "ft1000_hw:ft1000_chkcard: Version = 0xffff Card not detected\n");
 		return false;
 	}
 	return true;
@@ -561,13 +561,13 @@ static int ft1000_chkcard(struct net_device *dev)
 
 /*---------------------------------------------------------------------------
 
-   Function:   ft1000_hbchk
-   Description: This function will perform the heart beat check of the DSP as
-               well as the ASIC.
-   Input:
-       dev    - device structure
-   Output:
-       none
+  Function:   ft1000_hbchk
+  Description: This function will perform the heart beat check of the DSP as
+  well as the ASIC.
+  Input:
+  dev    - device structure
+  Output:
+  none
 
   -------------------------------------------------------------------------*/
 static void ft1000_hbchk(u_long data)
@@ -586,11 +586,11 @@ static void ft1000_hbchk(u_long data)
 		} else {
 			tempword =
 				ntohs(ft1000_read_dpram_mag_16
-				  (dev, FT1000_MAG_HI_HO,
-				   FT1000_MAG_HI_HO_INDX));
+				      (dev, FT1000_MAG_HI_HO,
+				       FT1000_MAG_HI_HO_INDX));
 		}
 		DEBUG(1, "ft1000_hw:ft1000_hbchk:hi_ho value = 0x%x\n",
-			  tempword);
+		      tempword);
 		/* Let's perform another check if ho is not detected */
 		if (tempword != ho) {
 			if (info->AsicID == ELECTRABUZZ_ID) {
@@ -602,7 +602,7 @@ static void ft1000_hbchk(u_long data)
 		}
 		if (tempword != ho) {
 			printk(KERN_INFO
-				   "ft1000: heartbeat failed - no ho detected\n");
+			       "ft1000: heartbeat failed - no ho detected\n");
 			if (info->AsicID == ELECTRABUZZ_ID) {
 				info->DSP_TIME[0] =
 					ft1000_read_dpram(dev, FT1000_DSP_TIMER0);
@@ -633,7 +633,7 @@ static void ft1000_hbchk(u_long data)
 			info->DrvErrNum = DSP_HB_INFO;
 			if (ft1000_reset_card(dev) == 0) {
 				printk(KERN_INFO
-					   "ft1000: Hardware Failure Detected - PC Card disabled\n");
+				       "ft1000: Hardware Failure Detected - PC Card disabled\n");
 				info->ProgConStat = 0xff;
 				return;
 			}
@@ -651,7 +651,7 @@ static void ft1000_hbchk(u_long data)
 		}
 		if (tempword & FT1000_DB_HB) {
 			printk(KERN_INFO
-				   "ft1000: heartbeat doorbell not clear by firmware\n");
+			       "ft1000: heartbeat doorbell not clear by firmware\n");
 			if (info->AsicID == ELECTRABUZZ_ID) {
 				info->DSP_TIME[0] =
 					ft1000_read_dpram(dev, FT1000_DSP_TIMER0);
@@ -682,7 +682,7 @@ static void ft1000_hbchk(u_long data)
 			info->DrvErrNum = DSP_HB_INFO;
 			if (ft1000_reset_card(dev) == 0) {
 				printk(KERN_INFO
-					   "ft1000: Hardware Failure Detected - PC Card disabled\n");
+				       "ft1000: Hardware Failure Detected - PC Card disabled\n");
 				info->ProgConStat = 0xff;
 				return;
 			}
@@ -708,8 +708,8 @@ static void ft1000_hbchk(u_long data)
 		} else {
 			tempword =
 				ntohs(ft1000_read_dpram_mag_16
-				  (dev, FT1000_MAG_HI_HO,
-				   FT1000_MAG_HI_HO_INDX));
+				      (dev, FT1000_MAG_HI_HO,
+				       FT1000_MAG_HI_HO_INDX));
 		}
 		/* Let's write hi again if fail */
 		if (tempword != hi) {
@@ -731,7 +731,7 @@ static void ft1000_hbchk(u_long data)
 
 		if (tempword != hi) {
 			printk(KERN_INFO
-				   "ft1000: heartbeat failed - cannot write hi into DPRAM\n");
+			       "ft1000: heartbeat failed - cannot write hi into DPRAM\n");
 			if (info->AsicID == ELECTRABUZZ_ID) {
 				info->DSP_TIME[0] =
 					ft1000_read_dpram(dev, FT1000_DSP_TIMER0);
@@ -762,7 +762,7 @@ static void ft1000_hbchk(u_long data)
 			info->DrvErrNum = DSP_HB_INFO;
 			if (ft1000_reset_card(dev) == 0) {
 				printk(KERN_INFO
-					   "ft1000: Hardware Failure Detected - PC Card disabled\n");
+				       "ft1000: Hardware Failure Detected - PC Card disabled\n");
 				info->ProgConStat = 0xff;
 				return;
 			}
@@ -778,19 +778,19 @@ static void ft1000_hbchk(u_long data)
 
 	/* Schedule this module to run every 2 seconds */
 	poll_timer.expires = jiffies + (2 * HZ);
-	poll_timer.data = (u_long) dev;
+	poll_timer.data = (u_long)dev;
 	add_timer(&poll_timer);
 }
 
 /*---------------------------------------------------------------------------
 
-   Function:   ft1000_send_cmd
-   Description:
-   Input:
-   Output:
+  Function:   ft1000_send_cmd
+  Description:
+  Input:
+  Output:
 
   -------------------------------------------------------------------------*/
-static void ft1000_send_cmd (struct net_device *dev, u16 *ptempbuffer, int size, u16 qtype)
+static void ft1000_send_cmd(struct net_device *dev, u16 *ptempbuffer, int size, u16 qtype)
 {
 	struct ft1000_info *info = netdev_priv(dev);
 	int i;
@@ -831,7 +831,7 @@ static void ft1000_send_cmd (struct net_device *dev, u16 *ptempbuffer, int size,
 		/* Write pseudo header and messgae body */
 		for (i = 0; i < (size >> 1); i++) {
 			DEBUG(1, "FT1000:ft1000_send_cmd:data %d = 0x%x\n", i,
-				  *ptempbuffer);
+			      *ptempbuffer);
 			tempword = htons(*ptempbuffer++);
 			ft1000_write_reg(dev, FT1000_REG_DPRAM_DATA, tempword);
 		}
@@ -845,13 +845,13 @@ static void ft1000_send_cmd (struct net_device *dev, u16 *ptempbuffer, int size,
 				 FT1000_DPRAM_MAG_TX_BASE + 1);
 		for (i = 0; i < (size >> 2); i++) {
 			DEBUG(1, "FT1000:ft1000_send_cmd:data = 0x%x\n",
-				  *ptempbuffer);
+			      *ptempbuffer);
 			outw(*ptempbuffer++,
-				 dev->base_addr + FT1000_REG_MAG_DPDATAL);
+			     dev->base_addr + FT1000_REG_MAG_DPDATAL);
 			DEBUG(1, "FT1000:ft1000_send_cmd:data = 0x%x\n",
-				  *ptempbuffer);
+			      *ptempbuffer);
 			outw(*ptempbuffer++,
-				 dev->base_addr + FT1000_REG_MAG_DPDATAH);
+			     dev->base_addr + FT1000_REG_MAG_DPDATAH);
 		}
 		DEBUG(1, "FT1000:ft1000_send_cmd:data = 0x%x\n", *ptempbuffer);
 		outw(*ptempbuffer++, dev->base_addr + FT1000_REG_MAG_DPDATAL);
@@ -866,19 +866,19 @@ static void ft1000_send_cmd (struct net_device *dev, u16 *ptempbuffer, int size,
 
 /*---------------------------------------------------------------------------
 
-   Function:   ft1000_receive_cmd
-   Description: This function will read a message from the dpram area.
-   Input:
-      dev - network device structure
-      pbuffer - caller supply address to buffer
-      pnxtph - pointer to next pseudo header
-   Output:
-     Status = 0 (unsuccessful)
-            = 1 (successful)
+  Function:   ft1000_receive_cmd
+  Description: This function will read a message from the dpram area.
+  Input:
+  dev - network device structure
+  pbuffer - caller supply address to buffer
+  pnxtph - pointer to next pseudo header
+  Output:
+  Status = 0 (unsuccessful)
+  = 1 (successful)
 
   -------------------------------------------------------------------------*/
 static bool ft1000_receive_cmd(struct net_device *dev, u16 *pbuffer,
-				int maxsz, u16 *pnxtph)
+			       int maxsz, u16 *pnxtph)
 {
 	struct ft1000_info *info = netdev_priv(dev);
 	u16 size;
@@ -888,20 +888,20 @@ static bool ft1000_receive_cmd(struct net_device *dev, u16 *pbuffer,
 	unsigned long flags;
 
 	if (info->AsicID == ELECTRABUZZ_ID) {
-		size = ( ft1000_read_dpram(dev, *pnxtph) ) + sizeof(struct pseudo_hdr);
+		size = (ft1000_read_dpram(dev, *pnxtph)) + sizeof(struct pseudo_hdr);
 	} else {
 		size =
 			ntohs(ft1000_read_dpram_mag_16
-			  (dev, FT1000_MAG_PH_LEN,
-			   FT1000_MAG_PH_LEN_INDX)) + sizeof(struct pseudo_hdr);
+			      (dev, FT1000_MAG_PH_LEN,
+			       FT1000_MAG_PH_LEN_INDX)) + sizeof(struct pseudo_hdr);
 	}
 	if (size > maxsz) {
 		DEBUG(1,
-			  "FT1000:ft1000_receive_cmd:Invalid command length = %d\n",
-			  size);
+		      "FT1000:ft1000_receive_cmd:Invalid command length = %d\n",
+		      size);
 		return false;
 	} else {
-		ppseudohdr = (u16 *) pbuffer;
+		ppseudohdr = (u16 *)pbuffer;
 		spin_lock_irqsave(&info->dpram_lock, flags);
 		if (info->AsicID == ELECTRABUZZ_ID) {
 			ft1000_write_reg(dev, FT1000_REG_DPRAM_ADDR,
@@ -922,11 +922,11 @@ static bool ft1000_receive_cmd(struct net_device *dev, u16 *pbuffer,
 			for (i = 0; i <= (size >> 2); i++) {
 				*pbuffer =
 					inw(dev->base_addr +
-					FT1000_REG_MAG_DPDATAL);
+					    FT1000_REG_MAG_DPDATAL);
 				pbuffer++;
 				*pbuffer =
 					inw(dev->base_addr +
-					FT1000_REG_MAG_DPDATAH);
+					    FT1000_REG_MAG_DPDATAH);
 				pbuffer++;
 			}
 			/* copy odd aligned word */
@@ -954,7 +954,7 @@ static bool ft1000_receive_cmd(struct net_device *dev, u16 *pbuffer,
 		}
 		if ((tempword != *ppseudohdr)) {
 			DEBUG(1,
-				  "FT1000:ft1000_receive_cmd:Pseudo header checksum mismatch\n");
+			      "FT1000:ft1000_receive_cmd:Pseudo header checksum mismatch\n");
 			/* Drop this message */
 			return false;
 		}
@@ -964,13 +964,13 @@ static bool ft1000_receive_cmd(struct net_device *dev, u16 *pbuffer,
 
 /*---------------------------------------------------------------------------
 
-   Function:   ft1000_proc_drvmsg
-   Description: This function will process the various driver messages.
-   Input:
-       dev    - device structure
-       pnxtph - pointer to next pseudo header
-   Output:
-       none
+  Function:   ft1000_proc_drvmsg
+  Description: This function will process the various driver messages.
+  Input:
+  dev    - device structure
+  pnxtph - pointer to next pseudo header
+  Output:
+  none
 
   -------------------------------------------------------------------------*/
 static void ft1000_proc_drvmsg(struct net_device *dev)
@@ -992,22 +992,22 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 		u16 wrd;
 	} convert;
 
-    if (info->AsicID == ELECTRABUZZ_ID) {
-        tempword = FT1000_DPRAM_RX_BASE+2;
-    }
-    else {
-        tempword = FT1000_DPRAM_MAG_RX_BASE;
-		}
-		if (ft1000_receive_cmd(dev, &cmdbuffer[0], MAX_CMD_SQSIZE, &tempword)) {
+	if (info->AsicID == ELECTRABUZZ_ID) {
+		tempword = FT1000_DPRAM_RX_BASE+2;
+	}
+	else {
+		tempword = FT1000_DPRAM_MAG_RX_BASE;
+	}
+	if (ft1000_receive_cmd(dev, &cmdbuffer[0], MAX_CMD_SQSIZE, &tempword)) {
 
 		/* Get the message type which is total_len + PSEUDO header + msgtype + message body */
-		pdrvmsg = (struct drv_msg *) & cmdbuffer[0];
+		pdrvmsg = (struct drv_msg *)&cmdbuffer[0];
 		msgtype = ntohs(pdrvmsg->type);
 		DEBUG(1, "Command message type = 0x%x\n", msgtype);
 		switch (msgtype) {
 		case DSP_PROVISION:
 			DEBUG(0,
-				  "Got a provisioning request message from DSP\n");
+			      "Got a provisioning request message from DSP\n");
 			mdelay(25);
 			while (list_empty(&info->prov_list) == 0) {
 				DEBUG(0, "Sending a provisioning message\n");
@@ -1025,25 +1025,25 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 				ptr =
 					list_entry(info->prov_list.next,
 						   struct prov_record, list);
-				len = *(u16 *) ptr->pprov_data;
+				len = *(u16 *)ptr->pprov_data;
 				len = htons(len);
 
-				pmsg = (u16 *) ptr->pprov_data;
-				ppseudo_hdr = (struct pseudo_hdr *) pmsg;
+				pmsg = (u16 *)ptr->pprov_data;
+				ppseudo_hdr = (struct pseudo_hdr *)pmsg;
 				/* Insert slow queue sequence number */
 				ppseudo_hdr->seq_num = info->squeseqnum++;
 				ppseudo_hdr->portsrc = 0;
 				/* Calculate new checksum */
 				ppseudo_hdr->checksum = *pmsg++;
 				DEBUG(1, "checksum = 0x%x\n",
-					  ppseudo_hdr->checksum);
+				      ppseudo_hdr->checksum);
 				for (i = 1; i < 7; i++) {
 					ppseudo_hdr->checksum ^= *pmsg++;
 					DEBUG(1, "checksum = 0x%x\n",
-						  ppseudo_hdr->checksum);
+					      ppseudo_hdr->checksum);
 				}
 
-				ft1000_send_cmd (dev, (u16 *)ptr->pprov_data, len, SLOWQ_TYPE);
+				ft1000_send_cmd(dev, (u16 *)ptr->pprov_data, len, SLOWQ_TYPE);
 				list_del(&ptr->list);
 				kfree(ptr->pprov_data);
 				kfree(ptr);
@@ -1055,18 +1055,28 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 			info->CardReady = 1;
 			break;
 		case MEDIA_STATE:
-			pmediamsg = (struct media_msg *) & cmdbuffer[0];
+			pmediamsg = (struct media_msg *)&cmdbuffer[0];
 			if (info->ProgConStat != 0xFF) {
-			if (pmediamsg->state) {
-				DEBUG(1, "Media is up\n");
-				if (info->mediastate == 0) {
-					netif_carrier_on(dev);
-					netif_wake_queue(dev);
-					info->mediastate = 1;
-					do_gettimeofday(&tv);
-					info->ConTm = tv.tv_sec;
+				if (pmediamsg->state) {
+					DEBUG(1, "Media is up\n");
+					if (info->mediastate == 0) {
+						netif_carrier_on(dev);
+						netif_wake_queue(dev);
+						info->mediastate = 1;
+						do_gettimeofday(&tv);
+						info->ConTm = tv.tv_sec;
+					}
+				} else {
+					DEBUG(1, "Media is down\n");
+					if (info->mediastate == 1) {
+						info->mediastate = 0;
+						netif_carrier_off(dev);
+						netif_stop_queue(dev);
+						info->ConTm = 0;
+					}
 				}
-			} else {
+			}
+			else {
 				DEBUG(1, "Media is down\n");
 				if (info->mediastate == 1) {
 					info->mediastate = 0;
@@ -1075,25 +1085,15 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 					info->ConTm = 0;
 				}
 			}
-            }
-            else {
-                DEBUG(1, "Media is down\n");
-                if (info->mediastate == 1) {
-                    info->mediastate = 0;
-                    netif_carrier_off(dev);
-                    netif_stop_queue(dev);
-                    info->ConTm = 0;
-                }
-            }
 			break;
 		case DSP_INIT_MSG:
-			pdspinitmsg = (struct dsp_init_msg *) & cmdbuffer[0];
+			pdspinitmsg = (struct dsp_init_msg *)&cmdbuffer[0];
 			memcpy(info->DspVer, pdspinitmsg->DspVer, DSPVERSZ);
 			DEBUG(1, "DSPVER = 0x%2x 0x%2x 0x%2x 0x%2x\n",
-				  info->DspVer[0], info->DspVer[1], info->DspVer[2],
-				   info->DspVer[3]);
+			      info->DspVer[0], info->DspVer[1], info->DspVer[2],
+			      info->DspVer[3]);
 			memcpy(info->HwSerNum, pdspinitmsg->HwSerNum,
-				   HWSERNUMSZ);
+			       HWSERNUMSZ);
 			memcpy(info->Sku, pdspinitmsg->Sku, SKUSZ);
 			memcpy(info->eui64, pdspinitmsg->eui64, EUISZ);
 			dev->dev_addr[0] = info->eui64[0];
@@ -1104,28 +1104,28 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 			dev->dev_addr[5] = info->eui64[7];
 
 			if (ntohs(pdspinitmsg->length) ==
-				(sizeof(struct dsp_init_msg) - 20)) {
+			    (sizeof(struct dsp_init_msg) - 20)) {
 				memcpy(info->ProductMode,
-					   pdspinitmsg->ProductMode, MODESZ);
+				       pdspinitmsg->ProductMode, MODESZ);
 				memcpy(info->RfCalVer, pdspinitmsg->RfCalVer,
-					   CALVERSZ);
+				       CALVERSZ);
 				memcpy(info->RfCalDate, pdspinitmsg->RfCalDate,
-					   CALDATESZ);
+				       CALDATESZ);
 				DEBUG(1, "RFCalVer = 0x%2x 0x%2x\n",
-					  info->RfCalVer[0], info->RfCalVer[1]);
+				      info->RfCalVer[0], info->RfCalVer[1]);
 			}
 
-			break ;
+			break;
 		case DSP_STORE_INFO:
 			DEBUG(1, "FT1000:drivermsg:Got DSP_STORE_INFO\n");
 			tempword = ntohs(pdrvmsg->length);
 			info->DSPInfoBlklen = tempword;
 			if (tempword < (MAX_DSP_SESS_REC - 4)) {
-				pmsg = (u16 *) & pdrvmsg->data[0];
+				pmsg = (u16 *)&pdrvmsg->data[0];
 				for (i = 0; i < ((tempword + 1) / 2); i++) {
 					DEBUG(1,
-						  "FT1000:drivermsg:dsp info data = 0x%x\n",
-						  *pmsg);
+					      "FT1000:drivermsg:dsp info data = 0x%x\n",
+					      *pmsg);
 					info->DSPInfoBlk[i + 10] = *pmsg++;
 				}
 			}
@@ -1152,8 +1152,8 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 				 * Put message into Slow Queue
 				 * Form Pseudo header
 				 */
-				pmsg = (u16 *) info->DSPInfoBlk;
-				ppseudo_hdr = (struct pseudo_hdr *) pmsg;
+				pmsg = (u16 *)info->DSPInfoBlk;
+				ppseudo_hdr = (struct pseudo_hdr *)pmsg;
 				ppseudo_hdr->length =
 					htons(info->DSPInfoBlklen + 4);
 				ppseudo_hdr->source = 0x10;
@@ -1177,7 +1177,7 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 				info->DSPInfoBlk[8] = 0x7200;
 				info->DSPInfoBlk[9] =
 					htons(info->DSPInfoBlklen);
-				ft1000_send_cmd (dev, (u16 *)info->DSPInfoBlk, (u16)(info->DSPInfoBlklen+4), 0);
+				ft1000_send_cmd(dev, (u16 *)info->DSPInfoBlk, (u16)(info->DSPInfoBlklen+4), 0);
 			}
 
 			break;
@@ -1203,8 +1203,8 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 				 * Put message into Slow Queue
 				 * Form Pseudo header
 				 */
-				pmsg = (u16 *) & tempbuffer[0];
-				ppseudo_hdr = (struct pseudo_hdr *) pmsg;
+				pmsg = (u16 *)&tempbuffer[0];
+				ppseudo_hdr = (struct pseudo_hdr *)pmsg;
 				ppseudo_hdr->length = htons(0x0012);
 				ppseudo_hdr->source = 0x10;
 				ppseudo_hdr->destination = 0x20;
@@ -1220,11 +1220,11 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 				/* Insert application id */
 				ppseudo_hdr->portsrc = 0;
 				/* Calculate new checksum */
-                ppseudo_hdr->checksum = *pmsg++;
-                for (i=1; i<7; i++) {
-                    ppseudo_hdr->checksum ^= *pmsg++;
-                }
-				pmsg = (u16 *) &tempbuffer[16];
+				ppseudo_hdr->checksum = *pmsg++;
+				for (i = 1; i < 7; i++) {
+					ppseudo_hdr->checksum ^= *pmsg++;
+				}
+				pmsg = (u16 *)&tempbuffer[16];
 				*pmsg++ = htons(RSP_DRV_ERR_RPT_MSG);
 				*pmsg++ = htons(0x000e);
 				*pmsg++ = htons(info->DSP_TIME[0]);
@@ -1239,7 +1239,7 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 				*pmsg++ = convert.wrd;
 				*pmsg++ = htons(info->DrvErrNum);
 
-				ft1000_send_cmd (dev, (u16 *)&tempbuffer[0], (u16)(0x0012), 0);
+				ft1000_send_cmd(dev, (u16 *)&tempbuffer[0], (u16)(0x0012), 0);
 				info->DrvErrNum = 0;
 			}
 
@@ -1252,14 +1252,14 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 
 /*---------------------------------------------------------------------------
 
-   Function:   ft1000_parse_dpram_msg
-   Description: This function will parse the message received from the DSP
-               via the DPRAM interface.
-   Input:
-       dev    - device structure
-   Output:
-       status - FAILURE
-                SUCCESS
+  Function:   ft1000_parse_dpram_msg
+  Description: This function will parse the message received from the DSP
+  via the DPRAM interface.
+  Input:
+  dev    - device structure
+  Output:
+  status - FAILURE
+  SUCCESS
 
   -------------------------------------------------------------------------*/
 static int ft1000_parse_dpram_msg(struct net_device *dev)
@@ -1290,7 +1290,7 @@ static int ft1000_parse_dpram_msg(struct net_device *dev)
 					 FT1000_DPRAM_MAG_RX_BASE);
 			for (i = 0; i < MAX_DSP_SESS_REC / 2; i++) {
 				outl(info->DSPSess.MagRec[i],
-					 dev->base_addr + FT1000_REG_MAG_DPDATA);
+				     dev->base_addr + FT1000_REG_MAG_DPDATA);
 			}
 		}
 		spin_unlock_irqrestore(&info->dpram_lock, flags);
@@ -1311,7 +1311,7 @@ static int ft1000_parse_dpram_msg(struct net_device *dev)
 
 	if (doorbell & FT1000_DSP_ASIC_RESET) {
 		DEBUG(0,
-			  "FT1000:ft1000_parse_dpram_msg: Got a dsp ASIC reset message\n");
+		      "FT1000:ft1000_parse_dpram_msg: Got a dsp ASIC reset message\n");
 		ft1000_write_reg(dev, FT1000_REG_DOORBELL,
 				 FT1000_DSP_ASIC_RESET);
 		udelay(200);
@@ -1320,7 +1320,7 @@ static int ft1000_parse_dpram_msg(struct net_device *dev)
 
 	if (doorbell & FT1000_DB_DPRAM_RX) {
 		DEBUG(1,
-			  "FT1000:ft1000_parse_dpram_msg: Got a slow queue message\n");
+		      "FT1000:ft1000_parse_dpram_msg: Got a slow queue message\n");
 		nxtph = FT1000_DPRAM_RX_BASE + 2;
 		if (info->AsicID == ELECTRABUZZ_ID) {
 			total_len =
@@ -1328,13 +1328,13 @@ static int ft1000_parse_dpram_msg(struct net_device *dev)
 		} else {
 			total_len =
 				ntohs(ft1000_read_dpram_mag_16
-				  (dev, FT1000_MAG_TOTAL_LEN,
-				   FT1000_MAG_TOTAL_LEN_INDX));
+				      (dev, FT1000_MAG_TOTAL_LEN,
+				       FT1000_MAG_TOTAL_LEN_INDX));
 		}
 		DEBUG(1, "FT1000:ft1000_parse_dpram_msg:total length = %d\n",
-			  total_len);
+		      total_len);
 		if ((total_len < MAX_CMD_SQSIZE) && (total_len > sizeof(struct pseudo_hdr))) {
-            total_len += nxtph;
+			total_len += nxtph;
 			/*
 			 * ft1000_read_reg will return a value that needs to be byteswap
 			 * in order to get DSP_QID_OFFSET.
@@ -1395,7 +1395,7 @@ static int ft1000_parse_dpram_msg(struct net_device *dev)
 	/* let's clear any unexpected doorbells from DSP */
 	doorbell =
 		doorbell & ~(FT1000_DB_DPRAM_RX | FT1000_ASIC_RESET_REQ |
-			 FT1000_DB_COND_RESET | 0xff00);
+			     FT1000_DB_COND_RESET | 0xff00);
 	if (doorbell) {
 		DEBUG(1, "Clearing unexpected doorbell = 0x%x\n", doorbell);
 		ft1000_write_reg(dev, FT1000_REG_DOORBELL, doorbell);
@@ -1407,14 +1407,14 @@ static int ft1000_parse_dpram_msg(struct net_device *dev)
 
 /*---------------------------------------------------------------------------
 
-   Function:   ft1000_flush_fifo
-   Description: This function will flush one packet from the downlink
-               FIFO.
-   Input:
-       dev      - device structure
-       drv_err  - driver error causing the flush fifo
-   Output:
-       None.
+  Function:   ft1000_flush_fifo
+  Description: This function will flush one packet from the downlink
+  FIFO.
+  Input:
+  dev      - device structure
+  drv_err  - driver error causing the flush fifo
+  Output:
+  None.
 
   -------------------------------------------------------------------------*/
 static void ft1000_flush_fifo(struct net_device *dev, u16 DrvErrNum)
@@ -1512,7 +1512,7 @@ static void ft1000_flush_fifo(struct net_device *dev, u16 DrvErrNum)
 					 */
 					tempword =
 						inw(dev->base_addr +
-						FT1000_REG_SUP_IMASK);
+						    FT1000_REG_SUP_IMASK);
 					if (tempword == 0) {
 						/* This indicates that we can not communicate with the ASIC */
 						info->DrvErrNum =
@@ -1557,15 +1557,15 @@ static void ft1000_flush_fifo(struct net_device *dev, u16 DrvErrNum)
 
 /*---------------------------------------------------------------------------
 
-   Function:   ft1000_copy_up_pkt
-   Description: This function will pull Flarion packets out of the Downlink
-               FIFO and convert it to an ethernet packet.  The ethernet packet will
-               then be deliver to the TCP/IP stack.
-   Input:
-       dev    - device structure
-   Output:
-       status - FAILURE
-                SUCCESS
+  Function:   ft1000_copy_up_pkt
+  Description: This function will pull Flarion packets out of the Downlink
+  FIFO and convert it to an ethernet packet.  The ethernet packet will
+  then be deliver to the TCP/IP stack.
+  Input:
+  dev    - device structure
+  Output:
+  status - FAILURE
+  SUCCESS
 
   -------------------------------------------------------------------------*/
 static int ft1000_copy_up_pkt(struct net_device *dev)
@@ -1616,7 +1616,7 @@ static int ft1000_copy_up_pkt(struct net_device *dev)
 		info->stats.rx_errors++;
 		return FAILURE;
 	}
-	pbuffer = (u8 *) skb_put(skb, len + 12);
+	pbuffer = (u8 *)skb_put(skb, len + 12);
 
 	/* Pseudo header */
 	if (info->AsicID == ELECTRABUZZ_ID) {
@@ -1658,7 +1658,7 @@ static int ft1000_copy_up_pkt(struct net_device *dev)
 
 	if (chksum != tempword) {
 		DEBUG(0, "Packet checksum mismatch 0x%x 0x%x\n", chksum,
-			  tempword);
+		      tempword);
 		ft1000_flush_fifo(dev, DSP_PKTPHCKSUM_INFO);
 		info->stats.rx_errors++;
 		kfree_skb(skb);
@@ -1685,7 +1685,7 @@ static int ft1000_copy_up_pkt(struct net_device *dev)
 		for (i = 0; i < len / 2; i++) {
 			tempword = ft1000_read_reg(dev, FT1000_REG_DFIFO);
 			*pbuffer++ = (u8) (tempword >> 8);
-			*pbuffer++ = (u8) tempword;
+			*pbuffer++ = (u8)tempword;
 			if (ft1000_chkcard(dev) == false) {
 				kfree_skb(skb);
 				return FAILURE;
@@ -1698,7 +1698,7 @@ static int ft1000_copy_up_pkt(struct net_device *dev)
 			*pbuffer++ = (u8) (tempword >> 8);
 		}
 	} else {
-		ptemplong = (u32 *) pbuffer;
+		ptemplong = (u32 *)pbuffer;
 		for (i = 0; i < len / 4; i++) {
 			templong = inl(dev->base_addr + FT1000_REG_MAG_DFR);
 			DEBUG(1, "Data = 0x%8x\n", templong);
@@ -1743,17 +1743,17 @@ static int ft1000_copy_up_pkt(struct net_device *dev)
 
 /*---------------------------------------------------------------------------
 
-   Function:   ft1000_copy_down_pkt
-   Description: This function will take an ethernet packet and convert it to
-               a Flarion packet prior to sending it to the ASIC Downlink
-               FIFO.
-   Input:
-       dev    - device structure
-       packet - address of ethernet packet
-       len    - length of IP packet
-   Output:
-       status - FAILURE
-                SUCCESS
+  Function:   ft1000_copy_down_pkt
+  Description: This function will take an ethernet packet and convert it to
+  a Flarion packet prior to sending it to the ASIC Downlink
+  FIFO.
+  Input:
+  dev    - device structure
+  packet - address of ethernet packet
+  len    - length of IP packet
+  Output:
+  status - FAILURE
+  SUCCESS
 
   -------------------------------------------------------------------------*/
 static int ft1000_copy_down_pkt(struct net_device *dev, u16 *packet, u16 len)
@@ -1790,7 +1790,7 @@ static int ft1000_copy_down_pkt(struct net_device *dev, u16 *packet, u16 len)
 		}
 		if (len > ft1000_read_fifo_len(dev)) {
 			DEBUG(1,
-				  "ft1000_hw:ft1000_copy_down_pkt:Transmit FIFO is fulli - pkt drop\n");
+			      "ft1000_hw:ft1000_copy_down_pkt:Transmit FIFO is fulli - pkt drop\n");
 			info->stats.tx_errors++;
 			return SUCCESS;
 		}
@@ -1822,38 +1822,38 @@ static int ft1000_copy_down_pkt(struct net_device *dev, u16 *packet, u16 len)
 		/* copy first word to UFIFO_BEG reg */
 		ft1000_write_reg(dev, FT1000_REG_UFIFO_BEG, pseudo.buff[0]);
 		DEBUG(1, "ft1000_hw:ft1000_copy_down_pkt:data 0 BEG = 0x%04x\n",
-			  pseudo.buff[0]);
+		      pseudo.buff[0]);
 
 		/* copy subsequent words to UFIFO_MID reg */
 		ft1000_write_reg(dev, FT1000_REG_UFIFO_MID, pseudo.buff[1]);
 		DEBUG(1, "ft1000_hw:ft1000_copy_down_pkt:data 1 MID = 0x%04x\n",
-			  pseudo.buff[1]);
+		      pseudo.buff[1]);
 		ft1000_write_reg(dev, FT1000_REG_UFIFO_MID, pseudo.buff[2]);
 		DEBUG(1, "ft1000_hw:ft1000_copy_down_pkt:data 2 MID = 0x%04x\n",
-			  pseudo.buff[2]);
+		      pseudo.buff[2]);
 		ft1000_write_reg(dev, FT1000_REG_UFIFO_MID, pseudo.buff[3]);
 		DEBUG(1, "ft1000_hw:ft1000_copy_down_pkt:data 3 MID = 0x%04x\n",
-			  pseudo.buff[3]);
+		      pseudo.buff[3]);
 		ft1000_write_reg(dev, FT1000_REG_UFIFO_MID, pseudo.buff[4]);
 		DEBUG(1, "ft1000_hw:ft1000_copy_down_pkt:data 4 MID = 0x%04x\n",
-			  pseudo.buff[4]);
+		      pseudo.buff[4]);
 		ft1000_write_reg(dev, FT1000_REG_UFIFO_MID, pseudo.buff[5]);
 		DEBUG(1, "ft1000_hw:ft1000_copy_down_pkt:data 5 MID = 0x%04x\n",
-			  pseudo.buff[5]);
+		      pseudo.buff[5]);
 		ft1000_write_reg(dev, FT1000_REG_UFIFO_MID, pseudo.buff[6]);
 		DEBUG(1, "ft1000_hw:ft1000_copy_down_pkt:data 6 MID = 0x%04x\n",
-			  pseudo.buff[6]);
+		      pseudo.buff[6]);
 		ft1000_write_reg(dev, FT1000_REG_UFIFO_MID, pseudo.buff[7]);
 		DEBUG(1, "ft1000_hw:ft1000_copy_down_pkt:data 7 MID = 0x%04x\n",
-			  pseudo.buff[7]);
+		      pseudo.buff[7]);
 
 		/* Write PPP type + IP Packet into Downlink FIFO */
 		for (i = 0; i < (len >> 1) - 1; i++) {
 			ft1000_write_reg(dev, FT1000_REG_UFIFO_MID,
 					 htons(*packet));
 			DEBUG(1,
-				  "ft1000_hw:ft1000_copy_down_pkt:data %d MID = 0x%04x\n",
-				  i + 8, htons(*packet));
+			      "ft1000_hw:ft1000_copy_down_pkt:data %d MID = 0x%04x\n",
+			      i + 8, htons(*packet));
 			packet++;
 		}
 
@@ -1862,40 +1862,40 @@ static int ft1000_copy_down_pkt(struct net_device *dev, u16 *packet, u16 len)
 			ft1000_write_reg(dev, FT1000_REG_UFIFO_MID,
 					 htons(*packet));
 			DEBUG(1,
-				  "ft1000_hw:ft1000_copy_down_pkt:data MID = 0x%04x\n",
-				  htons(*packet));
+			      "ft1000_hw:ft1000_copy_down_pkt:data MID = 0x%04x\n",
+			      htons(*packet));
 			packet++;
 			ft1000_write_reg(dev, FT1000_REG_UFIFO_END,
 					 htons(*packet));
 			DEBUG(1,
-				  "ft1000_hw:ft1000_copy_down_pkt:data %d MID = 0x%04x\n",
-				  i + 8, htons(*packet));
+			      "ft1000_hw:ft1000_copy_down_pkt:data %d MID = 0x%04x\n",
+			      i + 8, htons(*packet));
 		} else {
 			ft1000_write_reg(dev, FT1000_REG_UFIFO_END,
 					 htons(*packet));
 			DEBUG(1,
-				  "ft1000_hw:ft1000_copy_down_pkt:data %d MID = 0x%04x\n",
-				  i + 8, htons(*packet));
+			      "ft1000_hw:ft1000_copy_down_pkt:data %d MID = 0x%04x\n",
+			      i + 8, htons(*packet));
 		}
 	} else {
-		outl(*(u32 *) & pseudo.buff[0],
-			 dev->base_addr + FT1000_REG_MAG_UFDR);
+		outl(*(u32 *)&pseudo.buff[0],
+		     dev->base_addr + FT1000_REG_MAG_UFDR);
 		DEBUG(1, "ft1000_copy_down_pkt: Pseudo = 0x%8x\n",
-			  *(u32 *) & pseudo.buff[0]);
-		outl(*(u32 *) & pseudo.buff[2],
-			 dev->base_addr + FT1000_REG_MAG_UFDR);
+		      *(u32 *)&pseudo.buff[0]);
+		outl(*(u32 *)&pseudo.buff[2],
+		     dev->base_addr + FT1000_REG_MAG_UFDR);
 		DEBUG(1, "ft1000_copy_down_pkt: Pseudo = 0x%8x\n",
-			  *(u32 *) & pseudo.buff[2]);
-		outl(*(u32 *) & pseudo.buff[4],
-			 dev->base_addr + FT1000_REG_MAG_UFDR);
+		      *(u32 *)&pseudo.buff[2]);
+		outl(*(u32 *)&pseudo.buff[4],
+		     dev->base_addr + FT1000_REG_MAG_UFDR);
 		DEBUG(1, "ft1000_copy_down_pkt: Pseudo = 0x%8x\n",
-			  *(u32 *) & pseudo.buff[4]);
-		outl(*(u32 *) & pseudo.buff[6],
-			 dev->base_addr + FT1000_REG_MAG_UFDR);
+		      *(u32 *)&pseudo.buff[4]);
+		outl(*(u32 *)&pseudo.buff[6],
+		     dev->base_addr + FT1000_REG_MAG_UFDR);
 		DEBUG(1, "ft1000_copy_down_pkt: Pseudo = 0x%8x\n",
-			  *(u32 *) & pseudo.buff[6]);
+		      *(u32 *)&pseudo.buff[6]);
 
-		plong = (u32 *) packet;
+		plong = (u32 *)packet;
 		/* Write PPP type + IP Packet into Downlink FIFO */
 		for (i = 0; i < (len >> 2); i++) {
 			outl(*plong++, dev->base_addr + FT1000_REG_MAG_UFDR);
@@ -1904,8 +1904,8 @@ static int ft1000_copy_down_pkt(struct net_device *dev, u16 *packet, u16 len)
 		/* Check for odd alignment */
 		if (len & 0x0003) {
 			DEBUG(1,
-				  "ft1000_hw:ft1000_copy_down_pkt:data = 0x%8x\n",
-				  *plong);
+			      "ft1000_hw:ft1000_copy_down_pkt:data = 0x%8x\n",
+			      *plong);
 			outl(*plong++, dev->base_addr + FT1000_REG_MAG_UFDR);
 		}
 		outl(1, dev->base_addr + FT1000_REG_MAG_UFER);
@@ -1935,7 +1935,7 @@ static int ft1000_open(struct net_device *dev)
 	/* schedule ft1000_hbchk to perform periodic heartbeat checks on DSP and ASIC */
 	init_timer(&poll_timer);
 	poll_timer.expires = jiffies + (2 * HZ);
-	poll_timer.data = (u_long) dev;
+	poll_timer.data = (u_long)dev;
 	add_timer(&poll_timer);
 
 	DEBUG(0, "ft1000_hw: ft1000_open is ended2\n");
@@ -1976,9 +1976,9 @@ static int ft1000_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	DEBUG(1, "ft1000_hw: ft1000_start_xmit:length of packet = %d\n",
-		  skb->len);
+	      skb->len);
 
-	pdata = (u8 *) skb->data;
+	pdata = (u8 *)skb->data;
 
 	if (info->mediastate == 0) {
 		/* Drop packet is mediastate is down */
@@ -1989,11 +1989,11 @@ static int ft1000_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	if ((skb->len < ENET_HEADER_SIZE) || (skb->len > ENET_MAX_SIZE)) {
 		/* Drop packet which has invalid size */
 		DEBUG(1,
-			  "ft1000_hw:ft1000_copy_down_pkt:invalid ethernet length\n");
+		      "ft1000_hw:ft1000_copy_down_pkt:invalid ethernet length\n");
 		return SUCCESS;
 	}
 	ft1000_copy_down_pkt(dev, (u16 *) (pdata + ENET_HEADER_SIZE - 2),
-				 skb->len - ENET_HEADER_SIZE + 2);
+			     skb->len - ENET_HEADER_SIZE + 2);
 
 	dev_kfree_skb(skb);
 
@@ -2038,12 +2038,12 @@ static irqreturn_t ft1000_interrupt(int irq, void *dev_id)
 				/* Check if we have packets in the Downlink FIFO */
 				if (info->AsicID == ELECTRABUZZ_ID) {
 					tempword =
-					ft1000_read_reg(dev,
-							FT1000_REG_DFIFO_STAT);
+						ft1000_read_reg(dev,
+								FT1000_REG_DFIFO_STAT);
 				} else {
 					tempword =
-					ft1000_read_reg(dev,
-							FT1000_REG_MAG_DFSR);
+						ft1000_read_reg(dev,
+								FT1000_REG_MAG_DFSR);
 				}
 				if (tempword & 0x1f) {
 					ft1000_copy_up_pkt(dev);
@@ -2060,7 +2060,7 @@ static irqreturn_t ft1000_interrupt(int irq, void *dev_id)
 		ft1000_write_reg(dev, FT1000_REG_SUP_ISR, tempword);
 
 		/* Read interrupt type */
-		inttype = ft1000_read_reg (dev, FT1000_REG_SUP_ISR);
+		inttype = ft1000_read_reg(dev, FT1000_REG_SUP_ISR);
 		DEBUG(1, "ft1000_hw: interrupt status register after clear = 0x%x\n", inttype);
 	}
 	ft1000_enable_interrupts(dev);
@@ -2103,7 +2103,7 @@ void stop_ft1000_card(struct net_device *dev)
 }
 
 static void ft1000_get_drvinfo(struct net_device *dev,
-				   struct ethtool_drvinfo *info)
+			       struct ethtool_drvinfo *info)
 {
 	struct ft1000_info *ft_info;
 	ft_info = netdev_priv(dev);
@@ -2129,19 +2129,19 @@ static const struct ethtool_ops ops = {
 };
 
 struct net_device *init_ft1000_card(struct pcmcia_device *link,
-						void *ft1000_reset)
+				    void *ft1000_reset)
 {
 	struct ft1000_info *info;
 	struct ft1000_pcmcia *pcmcia;
 	struct net_device *dev;
 
 	static const struct net_device_ops ft1000ops =		/* Slavius 21.10.2009 due to kernel changes */
-	{
-		.ndo_open = &ft1000_open,
-		.ndo_stop = &ft1000_close,
-		.ndo_start_xmit = &ft1000_start_xmit,
-		.ndo_get_stats = &ft1000_stats,
-	};
+		{
+			.ndo_open = &ft1000_open,
+			.ndo_stop = &ft1000_close,
+			.ndo_start_xmit = &ft1000_start_xmit,
+			.ndo_get_stats = &ft1000_stats,
+		};
 
 	DEBUG(1, "ft1000_hw: init_ft1000_card()\n");
 	DEBUG(1, "ft1000_hw: irq = %d\n", link->irq);
@@ -2153,7 +2153,7 @@ struct net_device *init_ft1000_card(struct pcmcia_device *link,
 		flarion_ft1000_cnt--;
 
 		dev_info(&link->dev,
-			   "This driver can not support more than one instance\n");
+			 "This driver can not support more than one instance\n");
 		return NULL;
 	}
 
@@ -2168,8 +2168,8 @@ struct net_device *init_ft1000_card(struct pcmcia_device *link,
 
 	memset(info, 0, sizeof(struct ft1000_info));
 
-	DEBUG(1, "address of dev = 0x%8x\n", (u32) dev);
-	DEBUG(1, "address of dev info = 0x%8x\n", (u32) info);
+	DEBUG(1, "address of dev = 0x%8x\n", (u32)dev);
+	DEBUG(1, "address of dev info = 0x%8x\n", (u32)info);
 	DEBUG(0, "device name = %s\n", dev->name);
 
 	memset(&info->stats, 0, sizeof(struct net_device_stats));
@@ -2246,7 +2246,7 @@ struct net_device *init_ft1000_card(struct pcmcia_device *link,
 	ft1000_card_present = 1;
 	dev->ethtool_ops = &ops;
 	printk(KERN_INFO "ft1000: %s: addr 0x%04lx irq %d, MAC addr %pM\n",
-			dev->name, dev->base_addr, dev->irq, dev->dev_addr);
+	       dev->name, dev->base_addr, dev->irq, dev->dev_addr);
 	return dev;
 
 err_unreg:
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
index 4397ada..658f3ca 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
@@ -1,31 +1,31 @@
 /*
-*---------------------------------------------------------------------------
-* FT1000 driver for Flarion Flash OFDM NIC Device
-*
-* Copyright (C) 2006 Flarion Technologies, All rights reserved.
-*
-* This program is free software; you can redistribute it and/or modify it
-* under the terms of the GNU General Public License as published by the Free
-* Software Foundation; either version 2 of the License, or (at your option) any
-* later version. This program is distributed in the hope that it will be useful,
-* but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
-* or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
-* more details. You should have received a copy of the GNU General Public
-* License along with this program; if not, write to the
-* Free Software Foundation, Inc., 59 Temple Place -
-* Suite 330, Boston, MA 02111-1307, USA.
-*---------------------------------------------------------------------------
-*
-* File:         ft1000_chdev.c
-*
-* Description:  Custom character device dispatch routines.
-*
-* History:
-* 8/29/02    Whc                Ported to Linux.
-* 6/05/06    Whc                Porting to Linux 2.6.9
-*
-*---------------------------------------------------------------------------
-*/
+ *---------------------------------------------------------------------------
+ * FT1000 driver for Flarion Flash OFDM NIC Device
+ *
+ * Copyright (C) 2006 Flarion Technologies, All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option) any
+ * later version. This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details. You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place -
+ * Suite 330, Boston, MA 02111-1307, USA.
+ *---------------------------------------------------------------------------
+ *
+ * File:         ft1000_chdev.c
+ *
+ * Description:  Custom character device dispatch routines.
+ *
+ * History:
+ * 8/29/02    Whc                Ported to Linux.
+ * 6/05/06    Whc                Porting to Linux 2.6.9
+ *
+ *---------------------------------------------------------------------------
+ */
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -43,7 +43,7 @@ static int ft1000_flarion_cnt;
 static int ft1000_open(struct inode *inode, struct file *file);
 static unsigned int ft1000_poll_dev(struct file *file, poll_table *wait);
 static long ft1000_ioctl(struct file *file, unsigned int command,
-                           unsigned long argument);
+			 unsigned long argument);
 static int ft1000_release(struct inode *inode, struct file *file);
 
 /* List to free receive command buffer pool */
@@ -55,8 +55,8 @@ spinlock_t free_buff_lock;
 int numofmsgbuf = 0;
 
 /*
-* Table of entry-point routines for char device
-*/
+ * Table of entry-point routines for char device
+ */
 static const struct file_operations ft1000fops = {
 	.unlocked_ioctl	= ft1000_ioctl,
 	.poll		= ft1000_poll_dev,
@@ -66,104 +66,104 @@ static const struct file_operations ft1000fops = {
 };
 
 /*
----------------------------------------------------------------------------
-* Function:    ft1000_get_buffer
-*
-* Parameters:
-*
-* Returns:
-*
-* Description:
-*
-* Notes:
-*
-*---------------------------------------------------------------------------
-*/
+  ---------------------------------------------------------------------------
+  * Function:    ft1000_get_buffer
+  *
+  * Parameters:
+  *
+  * Returns:
+  *
+  * Description:
+  *
+  * Notes:
+  *
+  *---------------------------------------------------------------------------
+  */
 struct dpram_blk *ft1000_get_buffer(struct list_head *bufflist)
 {
-    unsigned long flags;
+	unsigned long flags;
 	struct dpram_blk *ptr;
 
-    spin_lock_irqsave(&free_buff_lock, flags);
-    /* Check if buffer is available */
-    if (list_empty(bufflist)) {
-        DEBUG("ft1000_get_buffer:  No more buffer - %d\n", numofmsgbuf);
-        ptr = NULL;
-    } else {
-        numofmsgbuf--;
-	ptr = list_entry(bufflist->next, struct dpram_blk, list);
-        list_del(&ptr->list);
-        /* DEBUG("ft1000_get_buffer: number of free msg buffers = %d\n", numofmsgbuf); */
-    }
-    spin_unlock_irqrestore(&free_buff_lock, flags);
-
-    return ptr;
+	spin_lock_irqsave(&free_buff_lock, flags);
+	/* Check if buffer is available */
+	if (list_empty(bufflist)) {
+		DEBUG("ft1000_get_buffer:  No more buffer - %d\n", numofmsgbuf);
+		ptr = NULL;
+	} else {
+		numofmsgbuf--;
+		ptr = list_entry(bufflist->next, struct dpram_blk, list);
+		list_del(&ptr->list);
+		/* DEBUG("ft1000_get_buffer: number of free msg buffers = %d\n", numofmsgbuf); */
+	}
+	spin_unlock_irqrestore(&free_buff_lock, flags);
+
+	return ptr;
 }
 
 
 
 
 /*
-*---------------------------------------------------------------------------
-* Function:    ft1000_free_buffer
-*
-* Parameters:
-*
-* Returns:
-*
-* Description:
-*
-* Notes:
-*
-*---------------------------------------------------------------------------
-*/
+ *---------------------------------------------------------------------------
+ * Function:    ft1000_free_buffer
+ *
+ * Parameters:
+ *
+ * Returns:
+ *
+ * Description:
+ *
+ * Notes:
+ *
+ *---------------------------------------------------------------------------
+ */
 void ft1000_free_buffer(struct dpram_blk *pdpram_blk, struct list_head *plist)
 {
-    unsigned long flags;
-
-    spin_lock_irqsave(&free_buff_lock, flags);
-    /* Put memory back to list */
-    list_add_tail(&pdpram_blk->list, plist);
-    numofmsgbuf++;
-    /*DEBUG("ft1000_free_buffer: number of free msg buffers = %d\n", numofmsgbuf); */
-    spin_unlock_irqrestore(&free_buff_lock, flags);
+	unsigned long flags;
+
+	spin_lock_irqsave(&free_buff_lock, flags);
+	/* Put memory back to list */
+	list_add_tail(&pdpram_blk->list, plist);
+	numofmsgbuf++;
+	/*DEBUG("ft1000_free_buffer: number of free msg buffers = %d\n", numofmsgbuf); */
+	spin_unlock_irqrestore(&free_buff_lock, flags);
 }
 
 /*
-*---------------------------------------------------------------------------
-* Function:    ft1000_CreateDevice
-*
-* Parameters:  dev - pointer to adapter object
-*
-* Returns:     0 if successful
-*
-* Description: Creates a private char device.
-*
-* Notes:       Only called by init_module().
-*
-*---------------------------------------------------------------------------
-*/
+ *---------------------------------------------------------------------------
+ * Function:    ft1000_CreateDevice
+ *
+ * Parameters:  dev - pointer to adapter object
+ *
+ * Returns:     0 if successful
+ *
+ * Description: Creates a private char device.
+ *
+ * Notes:       Only called by init_module().
+ *
+ *---------------------------------------------------------------------------
+ */
 int ft1000_create_dev(struct ft1000_usb *dev)
 {
-    int result;
-    int i;
+	int result;
+	int i;
 	struct dentry *dir, *file;
 	struct ft1000_debug_dirs *tmp;
 
-    /* make a new device name */
-    sprintf(dev->DeviceName, "%s%d", "FT1000_", dev->CardNumber);
+	/* make a new device name */
+	sprintf(dev->DeviceName, "%s%d", "FT1000_", dev->CardNumber);
 
-    DEBUG("%s: number of instance = %d\n", __func__, ft1000_flarion_cnt);
-    DEBUG("DeviceCreated = %x\n", dev->DeviceCreated);
+	DEBUG("%s: number of instance = %d\n", __func__, ft1000_flarion_cnt);
+	DEBUG("DeviceCreated = %x\n", dev->DeviceCreated);
 
-    if (dev->DeviceCreated) {
-	DEBUG("%s: \"%s\" already registered\n", __func__, dev->DeviceName);
-	return -EIO;
-    }
+	if (dev->DeviceCreated) {
+		DEBUG("%s: \"%s\" already registered\n", __func__, dev->DeviceName);
+		return -EIO;
+	}
 
 
-    /* register the device */
-    DEBUG("%s: \"%s\" debugfs device registration\n", __func__, dev->DeviceName);
+	/* register the device */
+	DEBUG("%s: \"%s\" debugfs device registration\n", __func__, dev->DeviceName);
 
 	tmp = kmalloc(sizeof(struct ft1000_debug_dirs), GFP_KERNEL);
 	if (tmp == NULL) {
@@ -178,7 +178,7 @@ int ft1000_create_dev(struct ft1000_usb *dev)
 	}
 
 	file = debugfs_create_file("device", S_IRUGO | S_IWUSR, dir,
-					dev, &ft1000fops);
+				   dev, &ft1000fops);
 	if (IS_ERR(file)) {
 		result = PTR_ERR(file);
 		goto debug_file_fail;
@@ -189,25 +189,25 @@ int ft1000_create_dev(struct ft1000_usb *dev)
 	tmp->int_number = dev->CardNumber;
 	list_add(&(tmp->list), &(dev->nodes.list));
 
-    DEBUG("%s: registered debugfs directory \"%s\"\n", __func__, dev->DeviceName);
-
-    /* initialize application information */
-    dev->appcnt = 0;
-    for (i=0; i<MAX_NUM_APP; i++) {
-        dev->app_info[i].nTxMsg = 0;
-        dev->app_info[i].nRxMsg = 0;
-        dev->app_info[i].nTxMsgReject = 0;
-        dev->app_info[i].nRxMsgMiss = 0;
-        dev->app_info[i].fileobject = NULL;
-        dev->app_info[i].app_id = i+1;
-        dev->app_info[i].DspBCMsgFlag = 0;
-        dev->app_info[i].NumOfMsg = 0;
-        init_waitqueue_head(&dev->app_info[i].wait_dpram_msg);
-        INIT_LIST_HEAD(&dev->app_info[i].app_sqlist);
-    }
-
-    dev->DeviceCreated = TRUE;
-    ft1000_flarion_cnt++;
+	DEBUG("%s: registered debugfs directory \"%s\"\n", __func__, dev->DeviceName);
+
+	/* initialize application information */
+	dev->appcnt = 0;
+	for (i = 0; i < MAX_NUM_APP; i++) {
+		dev->app_info[i].nTxMsg = 0;
+		dev->app_info[i].nRxMsg = 0;
+		dev->app_info[i].nTxMsgReject = 0;
+		dev->app_info[i].nRxMsgMiss = 0;
+		dev->app_info[i].fileobject = NULL;
+		dev->app_info[i].app_id = i+1;
+		dev->app_info[i].DspBCMsgFlag = 0;
+		dev->app_info[i].NumOfMsg = 0;
+		init_waitqueue_head(&dev->app_info[i].wait_dpram_msg);
+		INIT_LIST_HEAD(&dev->app_info[i].app_sqlist);
+	}
+
+	dev->DeviceCreated = TRUE;
+	ft1000_flarion_cnt++;
 
 	return 0;
 
@@ -220,33 +220,33 @@ fail:
 }
 
 /*
-*---------------------------------------------------------------------------
-* Function:    ft1000_DestroyDeviceDEBUG
-*
-* Parameters:  dev - pointer to adapter object
-*
-* Description: Destroys a private char device.
-*
-* Notes:       Only called by cleanup_module().
-*
-*---------------------------------------------------------------------------
-*/
+ *---------------------------------------------------------------------------
+ * Function:    ft1000_DestroyDeviceDEBUG
+ *
+ * Parameters:  dev - pointer to adapter object
+ *
+ * Description: Destroys a private char device.
+ *
+ * Notes:       Only called by cleanup_module().
+ *
+ *---------------------------------------------------------------------------
+ */
 void ft1000_destroy_dev(struct net_device *netdev)
 {
 	struct ft1000_info *info = netdev_priv(netdev);
 	struct ft1000_usb *dev = info->priv;
-		int i;
+	int i;
 	struct dpram_blk *pdpram_blk;
 	struct dpram_blk *ptr;
 	struct list_head *pos, *q;
 	struct ft1000_debug_dirs *dir;
 
-    DEBUG("%s called\n", __func__);
+	DEBUG("%s called\n", __func__);
 
 
 
-    if (dev->DeviceCreated) {
-        ft1000_flarion_cnt--;
+	if (dev->DeviceCreated) {
+		ft1000_flarion_cnt--;
 		list_for_each_safe(pos, q, &dev->nodes.list) {
 			dir = list_entry(pos, struct ft1000_debug_dirs, list);
 			if (dir->int_number == dev->CardNumber) {
@@ -257,28 +257,28 @@ void ft1000_destroy_dev(struct net_device *netdev)
 			}
 		}
 		DEBUG("%s: unregistered device \"%s\"\n", __func__,
-					   dev->DeviceName);
-
-        /* Make sure we free any memory reserve for slow Queue */
-        for (i=0; i<MAX_NUM_APP; i++) {
-            while (list_empty(&dev->app_info[i].app_sqlist) == 0) {
-                pdpram_blk = list_entry(dev->app_info[i].app_sqlist.next, struct dpram_blk, list);
-                list_del(&pdpram_blk->list);
-                ft1000_free_buffer(pdpram_blk, &freercvpool);
-
-            }
-            wake_up_interruptible(&dev->app_info[i].wait_dpram_msg);
-        }
-
-        /* Remove buffer allocated for receive command data */
-        if (ft1000_flarion_cnt == 0) {
-            while (list_empty(&freercvpool) == 0) {
-		ptr = list_entry(freercvpool.next, struct dpram_blk, list);
-                list_del(&ptr->list);
-                kfree(ptr->pbuffer);
-                kfree(ptr);
-            }
-        }
+		      dev->DeviceName);
+
+		/* Make sure we free any memory reserve for slow Queue */
+		for (i = 0; i < MAX_NUM_APP; i++) {
+			while (list_empty(&dev->app_info[i].app_sqlist) == 0) {
+				pdpram_blk = list_entry(dev->app_info[i].app_sqlist.next, struct dpram_blk, list);
+				list_del(&pdpram_blk->list);
+				ft1000_free_buffer(pdpram_blk, &freercvpool);
+
+			}
+			wake_up_interruptible(&dev->app_info[i].wait_dpram_msg);
+		}
+
+		/* Remove buffer allocated for receive command data */
+		if (ft1000_flarion_cnt == 0) {
+			while (list_empty(&freercvpool) == 0) {
+				ptr = list_entry(freercvpool.next, struct dpram_blk, list);
+				list_del(&ptr->list);
+				kfree(ptr->pbuffer);
+				kfree(ptr);
+			}
+		}
 		dev->DeviceCreated = FALSE;
 	}
 
@@ -286,503 +286,503 @@ void ft1000_destroy_dev(struct net_device *netdev)
 }
 
 /*
-*---------------------------------------------------------------------------
-* Function:    ft1000_open
-*
-* Parameters:
-*
-* Description:
-*
-* Notes:
-*
-*---------------------------------------------------------------------------
-*/
+ *---------------------------------------------------------------------------
+ * Function:    ft1000_open
+ *
+ * Parameters:
+ *
+ * Description:
+ *
+ * Notes:
+ *
+ *---------------------------------------------------------------------------
+ */
 static int ft1000_open(struct inode *inode, struct file *file)
 {
 	struct ft1000_info *info;
 	struct ft1000_usb *dev = (struct ft1000_usb *)inode->i_private;
-    int i,num;
+	int i, num;
 
-    DEBUG("%s called\n", __func__);
-    num = (MINOR(inode->i_rdev) & 0xf);
-    DEBUG("ft1000_open: minor number=%d\n", num);
+	DEBUG("%s called\n", __func__);
+	num = (MINOR(inode->i_rdev) & 0xf);
+	DEBUG("ft1000_open: minor number=%d\n", num);
 
 	info = file->private_data = netdev_priv(dev->net);
 
-    DEBUG("f_owner = %p number of application = %d\n", (&file->f_owner), dev->appcnt);
-
-    /* Check if maximum number of application exceeded */
-    if (dev->appcnt > MAX_NUM_APP) {
-        DEBUG("Maximum number of application exceeded\n");
-        return -EACCES;
-    }
-
-    /* Search for available application info block */
-    for (i=0; i<MAX_NUM_APP; i++) {
-        if ((dev->app_info[i].fileobject == NULL)) {
-            break;
-        }
-    }
-
-    /* Fail due to lack of application info block */
-    if (i == MAX_NUM_APP) {
-        DEBUG("Could not find an application info block\n");
-        return -EACCES;
-    }
-
-    dev->appcnt++;
-    dev->app_info[i].fileobject = &file->f_owner;
-    dev->app_info[i].nTxMsg = 0;
-    dev->app_info[i].nRxMsg = 0;
-    dev->app_info[i].nTxMsgReject = 0;
-    dev->app_info[i].nRxMsgMiss = 0;
+	DEBUG("f_owner = %p number of application = %d\n", (&file->f_owner), dev->appcnt);
+
+	/* Check if maximum number of application exceeded */
+	if (dev->appcnt > MAX_NUM_APP) {
+		DEBUG("Maximum number of application exceeded\n");
+		return -EACCES;
+	}
+
+	/* Search for available application info block */
+	for (i = 0; i < MAX_NUM_APP; i++) {
+		if ((dev->app_info[i].fileobject == NULL)) {
+			break;
+		}
+	}
+
+	/* Fail due to lack of application info block */
+	if (i == MAX_NUM_APP) {
+		DEBUG("Could not find an application info block\n");
+		return -EACCES;
+	}
+
+	dev->appcnt++;
+	dev->app_info[i].fileobject = &file->f_owner;
+	dev->app_info[i].nTxMsg = 0;
+	dev->app_info[i].nRxMsg = 0;
+	dev->app_info[i].nTxMsgReject = 0;
+	dev->app_info[i].nRxMsgMiss = 0;
 
 	nonseekable_open(inode, file);
-    return 0;
+	return 0;
 }
 
 
 /*
-*---------------------------------------------------------------------------
-* Function:    ft1000_poll_dev
-*
-* Parameters:
-*
-* Description:
-*
-* Notes:
-*
-*---------------------------------------------------------------------------
-*/
+ *---------------------------------------------------------------------------
+ * Function:    ft1000_poll_dev
+ *
+ * Parameters:
+ *
+ * Description:
+ *
+ * Notes:
+ *
+ *---------------------------------------------------------------------------
+ */
 
 static unsigned int ft1000_poll_dev(struct file *file, poll_table *wait)
 {
-    struct net_device *netdev = file->private_data;
+	struct net_device *netdev = file->private_data;
 	struct ft1000_info *info = netdev_priv(netdev);
 	struct ft1000_usb *dev = info->priv;
-    int i;
-
-    /* DEBUG("ft1000_poll_dev called\n"); */
-    if (ft1000_flarion_cnt == 0) {
-        DEBUG("FT1000:ft1000_poll_dev called when ft1000_flarion_cnt is zero\n");
-        return -EBADF;
-    }
-
-    /* Search for matching file object */
-    for (i=0; i<MAX_NUM_APP; i++) {
-        if (dev->app_info[i].fileobject == &file->f_owner) {
-            /* DEBUG("FT1000:ft1000_ioctl: Message is for AppId = %d\n", dev->app_info[i].app_id); */
-            break;
-        }
-    }
-
-    /* Could not find application info block */
-    if (i == MAX_NUM_APP) {
-        DEBUG("FT1000:ft1000_ioctl:Could not find application info block\n");
-        return -EACCES;
-    }
-
-    if (list_empty(&dev->app_info[i].app_sqlist) == 0) {
-        DEBUG("FT1000:ft1000_poll_dev:Message detected in slow queue\n");
-        return(POLLIN | POLLRDNORM | POLLPRI);
-    }
-
-    poll_wait(file, &dev->app_info[i].wait_dpram_msg, wait);
-    /* DEBUG("FT1000:ft1000_poll_dev:Polling for data from DSP\n"); */
+	int i;
+
+	/* DEBUG("ft1000_poll_dev called\n"); */
+	if (ft1000_flarion_cnt == 0) {
+		DEBUG("FT1000:ft1000_poll_dev called when ft1000_flarion_cnt is zero\n");
+		return -EBADF;
+	}
+
+	/* Search for matching file object */
+	for (i = 0; i < MAX_NUM_APP; i++) {
+		if (dev->app_info[i].fileobject == &file->f_owner) {
+			/* DEBUG("FT1000:ft1000_ioctl: Message is for AppId = %d\n", dev->app_info[i].app_id); */
+			break;
+		}
+	}
+
+	/* Could not find application info block */
+	if (i == MAX_NUM_APP) {
+		DEBUG("FT1000:ft1000_ioctl:Could not find application info block\n");
+		return -EACCES;
+	}
+
+	if (list_empty(&dev->app_info[i].app_sqlist) == 0) {
+		DEBUG("FT1000:ft1000_poll_dev:Message detected in slow queue\n");
+		return(POLLIN | POLLRDNORM | POLLPRI);
+	}
+
+	poll_wait(file, &dev->app_info[i].wait_dpram_msg, wait);
+	/* DEBUG("FT1000:ft1000_poll_dev:Polling for data from DSP\n"); */
 
 	return 0;
 }
 
 /*
-*---------------------------------------------------------------------------
-* Function:    ft1000_ioctl
-*
-* Parameters:
-*
-* Description:
-*
-* Notes:
-*
-*---------------------------------------------------------------------------
-*/
+ *---------------------------------------------------------------------------
+ * Function:    ft1000_ioctl
+ *
+ * Parameters:
+ *
+ * Description:
+ *
+ * Notes:
+ *
+ *---------------------------------------------------------------------------
+ */
 static long ft1000_ioctl(struct file *file, unsigned int command,
-                           unsigned long argument)
+			 unsigned long argument)
 {
-    void __user *argp = (void __user *)argument;
+	void __user *argp = (void __user *)argument;
 	struct ft1000_info *info;
-    struct ft1000_usb *ft1000dev;
-    int result=0;
-    int cmd;
-    int i;
-    u16 tempword;
-    unsigned long flags;
-    struct timeval tv;
+	struct ft1000_usb *ft1000dev;
+	int result = 0;
+	int cmd;
+	int i;
+	u16 tempword;
+	unsigned long flags;
+	struct timeval tv;
 	struct IOCTL_GET_VER get_ver_data;
 	struct IOCTL_GET_DSP_STAT get_stat_data;
-    u8 ConnectionMsg[] = {0x00,0x44,0x10,0x20,0x80,0x00,0x00,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x93,0x64,
-                          0x00,0x00,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x05,0x00,0x00,0x00,0x0a,
-                          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-                          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x12,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-                          0x00,0x00,0x02,0x37,0x00,0x00,0x00,0x08,0x00,0x00,0x00,0x01,0x00,0x01,0x7f,0x00,
-                          0x00,0x01,0x00,0x00};
+	u8 ConnectionMsg[] = {0x00, 0x44, 0x10, 0x20, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x93, 0x64,
+			      0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 0x0a,
+			      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+			      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x12, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+			      0x00, 0x00, 0x02, 0x37, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x7f, 0x00,
+			      0x00, 0x01, 0x00, 0x00};
 
-    unsigned short ledStat=0;
-    unsigned short conStat=0;
+	unsigned short ledStat = 0;
+	unsigned short conStat = 0;
 
-    /* DEBUG("ft1000_ioctl called\n"); */
+	/* DEBUG("ft1000_ioctl called\n"); */
 
-    if (ft1000_flarion_cnt == 0) {
-        DEBUG("FT1000:ft1000_ioctl called when ft1000_flarion_cnt is zero\n");
-        return -EBADF;
-    }
+	if (ft1000_flarion_cnt == 0) {
+		DEBUG("FT1000:ft1000_ioctl called when ft1000_flarion_cnt is zero\n");
+		return -EBADF;
+	}
 
-    /* DEBUG("FT1000:ft1000_ioctl:command = 0x%x argument = 0x%8x\n", command, (u32)argument); */
+	/* DEBUG("FT1000:ft1000_ioctl:command = 0x%x argument = 0x%8x\n", command, (u32)argument); */
 
 	info = file->private_data;
 	ft1000dev = info->priv;
-    cmd = _IOC_NR(command);
-    /* DEBUG("FT1000:ft1000_ioctl:cmd = 0x%x\n", cmd); */
-
-    /* process the command */
-    switch (cmd) {
-    case IOCTL_REGISTER_CMD:
-            DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_REGISTER called\n");
-            result = get_user(tempword, (__u16 __user*)argp);
-            if (result) {
-                DEBUG("result = %d failed to get_user\n", result);
-                break;
-            }
-            if (tempword == DSPBCMSGID) {
-                /* Search for matching file object */
-                for (i=0; i<MAX_NUM_APP; i++) {
-                    if (ft1000dev->app_info[i].fileobject == &file->f_owner) {
-                        ft1000dev->app_info[i].DspBCMsgFlag = 1;
-                        DEBUG("FT1000:ft1000_ioctl:Registered for broadcast messages\n");
-                        break;
-                    }
-                }
-            }
-            break;
-
-    case IOCTL_GET_VER_CMD:
-        DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_GET_VER called\n");
-
-        get_ver_data.drv_ver = FT1000_DRV_VER;
-
-        if (copy_to_user(argp, &get_ver_data, sizeof(get_ver_data))) {
-            DEBUG("FT1000:ft1000_ioctl: copy fault occurred\n");
-            result = -EFAULT;
-            break;
-        }
-
-        DEBUG("FT1000:ft1000_ioctl:driver version = 0x%x\n",(unsigned int)get_ver_data.drv_ver);
-
-        break;
-    case IOCTL_CONNECT:
-        /* Connect Message */
-        DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_CONNECT\n");
-        ConnectionMsg[79] = 0xfc;
-			   result = card_send_command(ft1000dev, (unsigned short *)ConnectionMsg, 0x4c);
-
-        break;
-    case IOCTL_DISCONNECT:
-        /* Disconnect Message */
-        DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_DISCONNECT\n");
-        ConnectionMsg[79] = 0xfd;
-			   result = card_send_command(ft1000dev, (unsigned short *)ConnectionMsg, 0x4c);
-        break;
-    case IOCTL_GET_DSP_STAT_CMD:
-        /* DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_GET_DSP_STAT called\n"); */
-	memset(&get_stat_data, 0, sizeof(get_stat_data));
-        memcpy(get_stat_data.DspVer, info->DspVer, DSPVERSZ);
-        memcpy(get_stat_data.HwSerNum, info->HwSerNum, HWSERNUMSZ);
-        memcpy(get_stat_data.Sku, info->Sku, SKUSZ);
-        memcpy(get_stat_data.eui64, info->eui64, EUISZ);
-
-            if (info->ProgConStat != 0xFF) {
-                ft1000_read_dpram16(ft1000dev, FT1000_MAG_DSP_LED, (u8 *)&ledStat, FT1000_MAG_DSP_LED_INDX);
-                get_stat_data.LedStat = ntohs(ledStat);
-                DEBUG("FT1000:ft1000_ioctl: LedStat = 0x%x\n", get_stat_data.LedStat);
-                ft1000_read_dpram16(ft1000dev, FT1000_MAG_DSP_CON_STATE, (u8 *)&conStat, FT1000_MAG_DSP_CON_STATE_INDX);
-                get_stat_data.ConStat = ntohs(conStat);
-                DEBUG("FT1000:ft1000_ioctl: ConStat = 0x%x\n", get_stat_data.ConStat);
-            } else {
-                get_stat_data.ConStat = 0x0f;
-            }
-
-
-        get_stat_data.nTxPkts = info->stats.tx_packets;
-        get_stat_data.nRxPkts = info->stats.rx_packets;
-        get_stat_data.nTxBytes = info->stats.tx_bytes;
-        get_stat_data.nRxBytes = info->stats.rx_bytes;
-        do_gettimeofday(&tv);
-        get_stat_data.ConTm = (u32)(tv.tv_sec - info->ConTm);
-        DEBUG("Connection Time = %d\n", (int)get_stat_data.ConTm);
-        if (copy_to_user(argp, &get_stat_data, sizeof(get_stat_data))) {
-            DEBUG("FT1000:ft1000_ioctl: copy fault occurred\n");
-            result = -EFAULT;
-            break;
-        }
-        DEBUG("ft1000_chioctl: GET_DSP_STAT succeed\n");
-        break;
-    case IOCTL_SET_DPRAM_CMD:
-        {
+	cmd = _IOC_NR(command);
+	/* DEBUG("FT1000:ft1000_ioctl:cmd = 0x%x\n", cmd); */
+
+	/* process the command */
+	switch (cmd) {
+	case IOCTL_REGISTER_CMD:
+		DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_REGISTER called\n");
+		result = get_user(tempword, (__u16 __user *)argp);
+		if (result) {
+			DEBUG("result = %d failed to get_user\n", result);
+			break;
+		}
+		if (tempword == DSPBCMSGID) {
+			/* Search for matching file object */
+			for (i = 0; i < MAX_NUM_APP; i++) {
+				if (ft1000dev->app_info[i].fileobject == &file->f_owner) {
+					ft1000dev->app_info[i].DspBCMsgFlag = 1;
+					DEBUG("FT1000:ft1000_ioctl:Registered for broadcast messages\n");
+					break;
+				}
+			}
+		}
+		break;
+
+	case IOCTL_GET_VER_CMD:
+		DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_GET_VER called\n");
+
+		get_ver_data.drv_ver = FT1000_DRV_VER;
+
+		if (copy_to_user(argp, &get_ver_data, sizeof(get_ver_data))) {
+			DEBUG("FT1000:ft1000_ioctl: copy fault occurred\n");
+			result = -EFAULT;
+			break;
+		}
+
+		DEBUG("FT1000:ft1000_ioctl:driver version = 0x%x\n", (unsigned int)get_ver_data.drv_ver);
+
+		break;
+	case IOCTL_CONNECT:
+		/* Connect Message */
+		DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_CONNECT\n");
+		ConnectionMsg[79] = 0xfc;
+		result = card_send_command(ft1000dev, (unsigned short *)ConnectionMsg, 0x4c);
+
+		break;
+	case IOCTL_DISCONNECT:
+		/* Disconnect Message */
+		DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_DISCONNECT\n");
+		ConnectionMsg[79] = 0xfd;
+		result = card_send_command(ft1000dev, (unsigned short *)ConnectionMsg, 0x4c);
+		break;
+	case IOCTL_GET_DSP_STAT_CMD:
+		/* DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_GET_DSP_STAT called\n"); */
+		memset(&get_stat_data, 0, sizeof(get_stat_data));
+		memcpy(get_stat_data.DspVer, info->DspVer, DSPVERSZ);
+		memcpy(get_stat_data.HwSerNum, info->HwSerNum, HWSERNUMSZ);
+		memcpy(get_stat_data.Sku, info->Sku, SKUSZ);
+		memcpy(get_stat_data.eui64, info->eui64, EUISZ);
+
+		if (info->ProgConStat != 0xFF) {
+			ft1000_read_dpram16(ft1000dev, FT1000_MAG_DSP_LED, (u8 *)&ledStat, FT1000_MAG_DSP_LED_INDX);
+			get_stat_data.LedStat = ntohs(ledStat);
+			DEBUG("FT1000:ft1000_ioctl: LedStat = 0x%x\n", get_stat_data.LedStat);
+			ft1000_read_dpram16(ft1000dev, FT1000_MAG_DSP_CON_STATE, (u8 *)&conStat, FT1000_MAG_DSP_CON_STATE_INDX);
+			get_stat_data.ConStat = ntohs(conStat);
+			DEBUG("FT1000:ft1000_ioctl: ConStat = 0x%x\n", get_stat_data.ConStat);
+		} else {
+			get_stat_data.ConStat = 0x0f;
+		}
+
+
+		get_stat_data.nTxPkts = info->stats.tx_packets;
+		get_stat_data.nRxPkts = info->stats.rx_packets;
+		get_stat_data.nTxBytes = info->stats.tx_bytes;
+		get_stat_data.nRxBytes = info->stats.rx_bytes;
+		do_gettimeofday(&tv);
+		get_stat_data.ConTm = (u32)(tv.tv_sec - info->ConTm);
+		DEBUG("Connection Time = %d\n", (int)get_stat_data.ConTm);
+		if (copy_to_user(argp, &get_stat_data, sizeof(get_stat_data))) {
+			DEBUG("FT1000:ft1000_ioctl: copy fault occurred\n");
+			result = -EFAULT;
+			break;
+		}
+		DEBUG("ft1000_chioctl: GET_DSP_STAT succeed\n");
+		break;
+	case IOCTL_SET_DPRAM_CMD:
+	{
 		struct IOCTL_DPRAM_BLK *dpram_data = NULL;
 		/* struct IOCTL_DPRAM_COMMAND dpram_command; */
-            u16 qtype;
-            u16 msgsz;
+		u16 qtype;
+		u16 msgsz;
 		struct pseudo_hdr *ppseudo_hdr;
-            u16 *pmsg;
-            u16 total_len;
-            u16 app_index;
-            u16 status;
+		u16 *pmsg;
+		u16 total_len;
+		u16 app_index;
+		u16 status;
 
-            /* DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_SET_DPRAM called\n");*/
+		/* DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_SET_DPRAM called\n");*/
 
 
-            if (ft1000_flarion_cnt == 0)
-                return -EBADF;
+		if (ft1000_flarion_cnt == 0)
+			return -EBADF;
 
-            if (ft1000dev->DrvMsgPend)
-                return -ENOTTY;
+		if (ft1000dev->DrvMsgPend)
+			return -ENOTTY;
 
-            if (ft1000dev->fProvComplete == 0)
-                return -EACCES;
+		if (ft1000dev->fProvComplete == 0)
+			return -EACCES;
 
-            ft1000dev->fAppMsgPend = 1;
+		ft1000dev->fAppMsgPend = 1;
 
-            if (info->CardReady) {
+		if (info->CardReady) {
 
-               /* DEBUG("FT1000:ft1000_ioctl: try to SET_DPRAM \n"); */
+			/* DEBUG("FT1000:ft1000_ioctl: try to SET_DPRAM \n"); */
 
-                /* Get the length field to see how many bytes to copy */
-                result = get_user(msgsz, (__u16 __user *)argp);
-		if (result)
-			break;
-                msgsz = ntohs(msgsz);
-                /* DEBUG("FT1000:ft1000_ioctl: length of message = %d\n", msgsz); */
-
-                if (msgsz > MAX_CMD_SQSIZE) {
-                    DEBUG("FT1000:ft1000_ioctl: bad message length = %d\n", msgsz);
-                    result = -EINVAL;
-                    break;
-                }
-
-		result = -ENOMEM;
-		dpram_data = kmalloc(msgsz + 2, GFP_KERNEL);
-		if (!dpram_data)
-			break;
+			/* Get the length field to see how many bytes to copy */
+			result = get_user(msgsz, (__u16 __user *)argp);
+			if (result)
+				break;
+			msgsz = ntohs(msgsz);
+			/* DEBUG("FT1000:ft1000_ioctl: length of message = %d\n", msgsz); */
+
+			if (msgsz > MAX_CMD_SQSIZE) {
+				DEBUG("FT1000:ft1000_ioctl: bad message length = %d\n", msgsz);
+				result = -EINVAL;
+				break;
+			}
 
-                if (copy_from_user(dpram_data, argp, msgsz+2)) {
-                    DEBUG("FT1000:ft1000_ChIoctl: copy fault occurred\n");
-                    result = -EFAULT;
-                } else {
-                    /* Check if this message came from a registered application */
-                    for (i=0; i<MAX_NUM_APP; i++) {
-                        if (ft1000dev->app_info[i].fileobject == &file->f_owner) {
-                            break;
-                        }
-                    }
-                    if (i==MAX_NUM_APP) {
-                        DEBUG("FT1000:No matching application fileobject\n");
-                        result = -EINVAL;
-			kfree(dpram_data);
-                        break;
-                    }
-                    app_index = i;
-
-                    /* Check message qtype type which is the lower byte within qos_class */
-                    qtype = ntohs(dpram_data->pseudohdr.qos_class) & 0xff;
-                    /* DEBUG("FT1000_ft1000_ioctl: qtype = %d\n", qtype); */
-                    if (qtype) {
-                    } else {
-                        /* Put message into Slow Queue */
-                        /* Only put a message into the DPRAM if msg doorbell is available */
-                        status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
-                        /* DEBUG("FT1000_ft1000_ioctl: READ REGISTER tempword=%x\n", tempword); */
-                        if (tempword & FT1000_DB_DPRAM_TX) {
-                            /* Suspend for 2ms and try again due to DSP doorbell busy */
-                            mdelay(2);
-                            status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
-                            if (tempword & FT1000_DB_DPRAM_TX) {
-                                /* Suspend for 1ms and try again due to DSP doorbell busy */
-                                mdelay(1);
-                                status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
-                                if (tempword & FT1000_DB_DPRAM_TX) {
-                                    status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
-                                    if (tempword & FT1000_DB_DPRAM_TX) {
-                                        /* Suspend for 3ms and try again due to DSP doorbell busy */
-                                        mdelay(3);
-                                        status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
-                                        if (tempword & FT1000_DB_DPRAM_TX) {
-                                            DEBUG("FT1000:ft1000_ioctl:Doorbell not available\n");
-                                            result = -ENOTTY;
-						kfree(dpram_data);
-                                            break;
-                                        }
-                                    }
-                                }
-                            }
-                        }
-
-                        /*DEBUG("FT1000_ft1000_ioctl: finished reading register\n"); */
-
-                        /* Make sure we are within the limits of the slow queue memory limitation */
-                        if ((msgsz < MAX_CMD_SQSIZE) && (msgsz > PSEUDOSZ)) {
-                            /* Need to put sequence number plus new checksum for message */
-                            pmsg = (u16 *)&dpram_data->pseudohdr;
-				ppseudo_hdr = (struct pseudo_hdr *)pmsg;
-                            total_len = msgsz+2;
-                            if (total_len & 0x1) {
-                                total_len++;
-                            }
-
-                            /* Insert slow queue sequence number */
-                            ppseudo_hdr->seq_num = info->squeseqnum++;
-                            ppseudo_hdr->portsrc = ft1000dev->app_info[app_index].app_id;
-                            /* Calculate new checksum */
-                            ppseudo_hdr->checksum = *pmsg++;
-                            /* DEBUG("checksum = 0x%x\n", ppseudo_hdr->checksum); */
-                            for (i=1; i<7; i++) {
-                                ppseudo_hdr->checksum ^= *pmsg++;
-                                /* DEBUG("checksum = 0x%x\n", ppseudo_hdr->checksum); */
-                            }
-                            pmsg++;
-				ppseudo_hdr = (struct pseudo_hdr *)pmsg;
-                           result = card_send_command(ft1000dev,(unsigned short*)dpram_data,total_len+2);
-
-
-                            ft1000dev->app_info[app_index].nTxMsg++;
-                        } else {
-                            result = -EINVAL;
-                        }
-                    }
-                }
-            } else {
-                DEBUG("FT1000:ft1000_ioctl: Card not ready take messages\n");
-                result = -EACCES;
-            }
-	    kfree(dpram_data);
-
-        }
-        break;
-    case IOCTL_GET_DPRAM_CMD:
-        {
+			result = -ENOMEM;
+			dpram_data = kmalloc(msgsz + 2, GFP_KERNEL);
+			if (!dpram_data)
+				break;
+
+			if (copy_from_user(dpram_data, argp, msgsz+2)) {
+				DEBUG("FT1000:ft1000_ChIoctl: copy fault occurred\n");
+				result = -EFAULT;
+			} else {
+				/* Check if this message came from a registered application */
+				for (i = 0; i < MAX_NUM_APP; i++) {
+					if (ft1000dev->app_info[i].fileobject == &file->f_owner) {
+						break;
+					}
+				}
+				if (i == MAX_NUM_APP) {
+					DEBUG("FT1000:No matching application fileobject\n");
+					result = -EINVAL;
+					kfree(dpram_data);
+					break;
+				}
+				app_index = i;
+
+				/* Check message qtype type which is the lower byte within qos_class */
+				qtype = ntohs(dpram_data->pseudohdr.qos_class) & 0xff;
+				/* DEBUG("FT1000_ft1000_ioctl: qtype = %d\n", qtype); */
+				if (qtype) {
+				} else {
+					/* Put message into Slow Queue */
+					/* Only put a message into the DPRAM if msg doorbell is available */
+					status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
+					/* DEBUG("FT1000_ft1000_ioctl: READ REGISTER tempword=%x\n", tempword); */
+					if (tempword & FT1000_DB_DPRAM_TX) {
+						/* Suspend for 2ms and try again due to DSP doorbell busy */
+						mdelay(2);
+						status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
+						if (tempword & FT1000_DB_DPRAM_TX) {
+							/* Suspend for 1ms and try again due to DSP doorbell busy */
+							mdelay(1);
+							status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
+							if (tempword & FT1000_DB_DPRAM_TX) {
+								status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
+								if (tempword & FT1000_DB_DPRAM_TX) {
+									/* Suspend for 3ms and try again due to DSP doorbell busy */
+									mdelay(3);
+									status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
+									if (tempword & FT1000_DB_DPRAM_TX) {
+										DEBUG("FT1000:ft1000_ioctl:Doorbell not available\n");
+										result = -ENOTTY;
+										kfree(dpram_data);
+										break;
+									}
+								}
+							}
+						}
+					}
+
+					/*DEBUG("FT1000_ft1000_ioctl: finished reading register\n"); */
+
+					/* Make sure we are within the limits of the slow queue memory limitation */
+					if ((msgsz < MAX_CMD_SQSIZE) && (msgsz > PSEUDOSZ)) {
+						/* Need to put sequence number plus new checksum for message */
+						pmsg = (u16 *)&dpram_data->pseudohdr;
+						ppseudo_hdr = (struct pseudo_hdr *)pmsg;
+						total_len = msgsz+2;
+						if (total_len & 0x1) {
+							total_len++;
+						}
+
+						/* Insert slow queue sequence number */
+						ppseudo_hdr->seq_num = info->squeseqnum++;
+						ppseudo_hdr->portsrc = ft1000dev->app_info[app_index].app_id;
+						/* Calculate new checksum */
+						ppseudo_hdr->checksum = *pmsg++;
+						/* DEBUG("checksum = 0x%x\n", ppseudo_hdr->checksum); */
+						for (i = 1; i < 7; i++) {
+							ppseudo_hdr->checksum ^= *pmsg++;
+							/* DEBUG("checksum = 0x%x\n", ppseudo_hdr->checksum); */
+						}
+						pmsg++;
+						ppseudo_hdr = (struct pseudo_hdr *)pmsg;
+						result = card_send_command(ft1000dev, (unsigned short *)dpram_data, total_len+2);
+
+
+						ft1000dev->app_info[app_index].nTxMsg++;
+					} else {
+						result = -EINVAL;
+					}
+				}
+			}
+		} else {
+			DEBUG("FT1000:ft1000_ioctl: Card not ready take messages\n");
+			result = -EACCES;
+		}
+		kfree(dpram_data);
+
+	}
+	break;
+	case IOCTL_GET_DPRAM_CMD:
+	{
 		struct dpram_blk *pdpram_blk;
 		struct IOCTL_DPRAM_BLK __user *pioctl_dpram;
-            int msglen;
-
-            /* DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_GET_DPRAM called\n"); */
-
-            if (ft1000_flarion_cnt == 0)
-                return -EBADF;
-
-            /* Search for matching file object */
-            for (i=0; i<MAX_NUM_APP; i++) {
-                if (ft1000dev->app_info[i].fileobject == &file->f_owner) {
-                    /*DEBUG("FT1000:ft1000_ioctl: Message is for AppId = %d\n", ft1000dev->app_info[i].app_id); */
-                    break;
-                }
-            }
-
-            /* Could not find application info block */
-            if (i == MAX_NUM_APP) {
-                DEBUG("FT1000:ft1000_ioctl:Could not find application info block\n");
-                result = -EBADF;
-                break;
-            }
-
-            result = 0;
-            pioctl_dpram = argp;
-            if (list_empty(&ft1000dev->app_info[i].app_sqlist) == 0) {
-                /* DEBUG("FT1000:ft1000_ioctl:Message detected in slow queue\n"); */
-                spin_lock_irqsave(&free_buff_lock, flags);
-                pdpram_blk = list_entry(ft1000dev->app_info[i].app_sqlist.next, struct dpram_blk, list);
-                list_del(&pdpram_blk->list);
-                ft1000dev->app_info[i].NumOfMsg--;
-                /* DEBUG("FT1000:ft1000_ioctl:NumOfMsg for app %d = %d\n", i, ft1000dev->app_info[i].NumOfMsg); */
-                spin_unlock_irqrestore(&free_buff_lock, flags);
-                msglen = ntohs(*(u16 *)pdpram_blk->pbuffer) + PSEUDOSZ;
-                result = get_user(msglen, &pioctl_dpram->total_len);
-		if (result)
-			break;
-		msglen = htons(msglen);
-                /* DEBUG("FT1000:ft1000_ioctl:msg length = %x\n", msglen); */
-                if (copy_to_user (&pioctl_dpram->pseudohdr, pdpram_blk->pbuffer, msglen)) {
-					DEBUG("FT1000:ft1000_ioctl: copy fault occurred\n");
-			result = -EFAULT;
+		int msglen;
+
+		/* DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_GET_DPRAM called\n"); */
+
+		if (ft1000_flarion_cnt == 0)
+			return -EBADF;
+
+		/* Search for matching file object */
+		for (i = 0; i < MAX_NUM_APP; i++) {
+			if (ft1000dev->app_info[i].fileobject == &file->f_owner) {
+				/*DEBUG("FT1000:ft1000_ioctl: Message is for AppId = %d\n", ft1000dev->app_info[i].app_id); */
+				break;
+			}
+		}
+
+		/* Could not find application info block */
+		if (i == MAX_NUM_APP) {
+			DEBUG("FT1000:ft1000_ioctl:Could not find application info block\n");
+			result = -EBADF;
 			break;
-				}
+		}
+
+		result = 0;
+		pioctl_dpram = argp;
+		if (list_empty(&ft1000dev->app_info[i].app_sqlist) == 0) {
+			/* DEBUG("FT1000:ft1000_ioctl:Message detected in slow queue\n"); */
+			spin_lock_irqsave(&free_buff_lock, flags);
+			pdpram_blk = list_entry(ft1000dev->app_info[i].app_sqlist.next, struct dpram_blk, list);
+			list_del(&pdpram_blk->list);
+			ft1000dev->app_info[i].NumOfMsg--;
+			/* DEBUG("FT1000:ft1000_ioctl:NumOfMsg for app %d = %d\n", i, ft1000dev->app_info[i].NumOfMsg); */
+			spin_unlock_irqrestore(&free_buff_lock, flags);
+			msglen = ntohs(*(u16 *)pdpram_blk->pbuffer) + PSEUDOSZ;
+			result = get_user(msglen, &pioctl_dpram->total_len);
+			if (result)
+				break;
+			msglen = htons(msglen);
+			/* DEBUG("FT1000:ft1000_ioctl:msg length = %x\n", msglen); */
+			if (copy_to_user(&pioctl_dpram->pseudohdr, pdpram_blk->pbuffer, msglen)) {
+				DEBUG("FT1000:ft1000_ioctl: copy fault occurred\n");
+				result = -EFAULT;
+				break;
+			}
 
-                ft1000_free_buffer(pdpram_blk, &freercvpool);
-                result = msglen;
-            }
-            /* DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_GET_DPRAM no message\n"); */
-        }
-        break;
-
-    default:
-        DEBUG("FT1000:ft1000_ioctl:unknown command: 0x%x\n", command);
-        result = -ENOTTY;
-        break;
-    }
-    ft1000dev->fAppMsgPend = 0;
-    return result;
+			ft1000_free_buffer(pdpram_blk, &freercvpool);
+			result = msglen;
+		}
+		/* DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_GET_DPRAM no message\n"); */
+	}
+	break;
+
+	default:
+		DEBUG("FT1000:ft1000_ioctl:unknown command: 0x%x\n", command);
+		result = -ENOTTY;
+		break;
+	}
+	ft1000dev->fAppMsgPend = 0;
+	return result;
 }
 
 /*
-*---------------------------------------------------------------------------
-* Function:    ft1000_release
-*
-* Parameters:
-*
-* Description:
-*
-* Notes:
-*
-*---------------------------------------------------------------------------
-*/
+ *---------------------------------------------------------------------------
+ * Function:    ft1000_release
+ *
+ * Parameters:
+ *
+ * Description:
+ *
+ * Notes:
+ *
+ *---------------------------------------------------------------------------
+ */
 static int ft1000_release(struct inode *inode, struct file *file)
 {
 	struct ft1000_info *info;
-    struct net_device *dev;
-    struct ft1000_usb *ft1000dev;
-    int i;
+	struct net_device *dev;
+	struct ft1000_usb *ft1000dev;
+	int i;
 	struct dpram_blk *pdpram_blk;
 
-    DEBUG("ft1000_release called\n");
+	DEBUG("ft1000_release called\n");
 
-    dev = file->private_data;
+	dev = file->private_data;
 	info = netdev_priv(dev);
 	ft1000dev = info->priv;
 
-    if (ft1000_flarion_cnt == 0) {
-        ft1000dev->appcnt--;
-        return -EBADF;
-    }
-
-    /* Search for matching file object */
-    for (i=0; i<MAX_NUM_APP; i++) {
-        if (ft1000dev->app_info[i].fileobject == &file->f_owner) {
-            /* DEBUG("FT1000:ft1000_ioctl: Message is for AppId = %d\n", ft1000dev->app_info[i].app_id); */
-            break;
-        }
-    }
-
-    if (i==MAX_NUM_APP)
-	    return 0;
-
-    while (list_empty(&ft1000dev->app_info[i].app_sqlist) == 0) {
-        DEBUG("Remove and free memory queue up on slow queue\n");
-        pdpram_blk = list_entry(ft1000dev->app_info[i].app_sqlist.next, struct dpram_blk, list);
-        list_del(&pdpram_blk->list);
-        ft1000_free_buffer(pdpram_blk, &freercvpool);
-    }
-
-    /* initialize application information */
-    ft1000dev->appcnt--;
-    DEBUG("ft1000_chdev:%s:appcnt = %d\n", __func__, ft1000dev->appcnt);
-    ft1000dev->app_info[i].fileobject = NULL;
-
-    return 0;
+	if (ft1000_flarion_cnt == 0) {
+		ft1000dev->appcnt--;
+		return -EBADF;
+	}
+
+	/* Search for matching file object */
+	for (i = 0; i < MAX_NUM_APP; i++) {
+		if (ft1000dev->app_info[i].fileobject == &file->f_owner) {
+			/* DEBUG("FT1000:ft1000_ioctl: Message is for AppId = %d\n", ft1000dev->app_info[i].app_id); */
+			break;
+		}
+	}
+
+	if (i == MAX_NUM_APP)
+		return 0;
+
+	while (list_empty(&ft1000dev->app_info[i].app_sqlist) == 0) {
+		DEBUG("Remove and free memory queue up on slow queue\n");
+		pdpram_blk = list_entry(ft1000dev->app_info[i].app_sqlist.next, struct dpram_blk, list);
+		list_del(&pdpram_blk->list);
+		ft1000_free_buffer(pdpram_blk, &freercvpool);
+	}
+
+	/* initialize application information */
+	ft1000dev->appcnt--;
+	DEBUG("ft1000_chdev:%s:appcnt = %d\n", __func__, ft1000dev->appcnt);
+	ft1000dev->app_info[i].fileobject = NULL;
+
+	return 0;
 }
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index fe882bd..2cce422 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -1,8 +1,8 @@
 /*
-* CopyRight (C) 2007 Qualcomm Inc. All Rights Reserved.
-*
-* This file is part of Express Card USB Driver
-*/
+ * CopyRight (C) 2007 Qualcomm Inc. All Rights Reserved.
+ *
+ * This file is part of Express Card USB Driver
+ */
 
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -117,17 +117,17 @@ static int check_usb_db(struct ft1000_usb *ft1000dev)
 
 	while (loopcnt < 10) {
 		status = ft1000_read_register(ft1000dev, &temp,
-					       FT1000_REG_DOORBELL);
+					      FT1000_REG_DOORBELL);
 		DEBUG("check_usb_db: read FT1000_REG_DOORBELL value is %x\n",
-		       temp);
+		      temp);
 		if (temp & 0x0080) {
 			DEBUG("FT1000:Got checkusb doorbell\n");
 			status = ft1000_write_register(ft1000dev, 0x0080,
-						FT1000_REG_DOORBELL);
+						       FT1000_REG_DOORBELL);
 			status = ft1000_write_register(ft1000dev, 0x0100,
-						FT1000_REG_DOORBELL);
+						       FT1000_REG_DOORBELL);
 			status = ft1000_write_register(ft1000dev,  0x8000,
-						FT1000_REG_DOORBELL);
+						       FT1000_REG_DOORBELL);
 			break;
 		}
 		loopcnt++;
@@ -138,7 +138,7 @@ static int check_usb_db(struct ft1000_usb *ft1000dev)
 	loopcnt = 0;
 	while (loopcnt < 20) {
 		status = ft1000_read_register(ft1000dev, &temp,
-					       FT1000_REG_DOORBELL);
+					      FT1000_REG_DOORBELL);
 		DEBUG("FT1000:check_usb_db:Doorbell = 0x%x\n", temp);
 		if (temp & 0x8000) {
 			loopcnt++;
@@ -164,10 +164,10 @@ static u16 get_handshake(struct ft1000_usb *ft1000dev, u16 expected_value)
 	while (loopcnt < 100) {
 		/* Need to clear downloader doorbell if Hartley ASIC */
 		status = ft1000_write_register(ft1000dev,  FT1000_DB_DNLD_RX,
-						FT1000_REG_DOORBELL);
+					       FT1000_REG_DOORBELL);
 		if (ft1000dev->fcodeldr) {
 			DEBUG(" get_handshake: fcodeldr is %d\n",
-				ft1000dev->fcodeldr);
+			      ft1000dev->fcodeldr);
 			ft1000dev->fcodeldr = 0;
 			status = check_usb_db(ft1000dev);
 			if (status != 0) {
@@ -175,12 +175,12 @@ static u16 get_handshake(struct ft1000_usb *ft1000dev, u16 expected_value)
 				break;
 			}
 			status = ft1000_write_register(ft1000dev,
-					FT1000_DB_DNLD_RX,
-					FT1000_REG_DOORBELL);
+						       FT1000_DB_DNLD_RX,
+						       FT1000_REG_DOORBELL);
 		}
 
 		status = ft1000_read_dpram16(ft1000dev,
-				DWNLD_MAG1_HANDSHAKE_LOC, (u8 *)&handshake, 1);
+					     DWNLD_MAG1_HANDSHAKE_LOC, (u8 *)&handshake, 1);
 		handshake = ntohs(handshake);
 
 		if (status)
@@ -209,12 +209,12 @@ static void put_handshake(struct ft1000_usb *ft1000dev, u16 handshake_value)
 
 	tempword = (u16)(tempx & 0xffff);
 	status = ft1000_write_dpram16(ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC,
-					tempword, 0);
+				      tempword, 0);
 	tempword = (u16)(tempx >> 16);
 	status = ft1000_write_dpram16(ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC,
-					tempword, 1);
+				      tempword, 1);
 	status = ft1000_write_register(ft1000dev, FT1000_DB_DNLD_TX,
-					FT1000_REG_DOORBELL);
+				       FT1000_REG_DOORBELL);
 }
 
 static u16 get_handshake_usb(struct ft1000_usb *ft1000dev, u16 expected_value)
@@ -230,27 +230,27 @@ static u16 get_handshake_usb(struct ft1000_usb *ft1000dev, u16 expected_value)
 	while (loopcnt < 100) {
 		if (ft1000dev->usbboot == 2) {
 			status = ft1000_read_dpram32(ft1000dev, 0,
-					(u8 *)&(ft1000dev->tempbuf[0]), 64);
+						     (u8 *)&(ft1000dev->tempbuf[0]), 64);
 			for (temp = 0; temp < 16; temp++) {
 				DEBUG("tempbuf %d = 0x%x\n", temp,
-					ft1000dev->tempbuf[temp]);
+				      ft1000dev->tempbuf[temp]);
 			}
 			status = ft1000_read_dpram16(ft1000dev,
-						DWNLD_MAG1_HANDSHAKE_LOC,
-						(u8 *)&handshake, 1);
+						     DWNLD_MAG1_HANDSHAKE_LOC,
+						     (u8 *)&handshake, 1);
 			DEBUG("handshake from read_dpram16 = 0x%x\n",
-				handshake);
+			      handshake);
 			if (ft1000dev->dspalive == ft1000dev->tempbuf[6]) {
 				handshake = 0;
 			} else {
 				handshake = ft1000dev->tempbuf[1];
 				ft1000dev->dspalive =
-						ft1000dev->tempbuf[6];
+					ft1000dev->tempbuf[6];
 			}
 		} else {
 			status = ft1000_read_dpram16(ft1000dev,
-						DWNLD_MAG1_HANDSHAKE_LOC,
-						(u8 *)&handshake, 1);
+						     DWNLD_MAG1_HANDSHAKE_LOC,
+						     (u8 *)&handshake, 1);
 		}
 
 		loopcnt++;
@@ -281,12 +281,12 @@ static u16 get_request_type(struct ft1000_usb *ft1000dev)
 
 	if (ft1000dev->bootmode == 1) {
 		status = fix_ft1000_read_dpram32(ft1000dev,
-				DWNLD_MAG1_TYPE_LOC, (u8 *)&tempx);
+						 DWNLD_MAG1_TYPE_LOC, (u8 *)&tempx);
 		tempx = ntohl(tempx);
 	} else {
 		tempx = 0;
 		status = ft1000_read_dpram16(ft1000dev,
-				DWNLD_MAG1_TYPE_LOC, (u8 *)&tempword, 1);
+					     DWNLD_MAG1_TYPE_LOC, (u8 *)&tempword, 1);
 		tempx |= (tempword << 16);
 		tempx = ntohl(tempx);
 	}
@@ -304,7 +304,7 @@ static u16 get_request_type_usb(struct ft1000_usb *ft1000dev)
 
 	if (ft1000dev->bootmode == 1) {
 		status = fix_ft1000_read_dpram32(ft1000dev,
-				DWNLD_MAG1_TYPE_LOC, (u8 *)&tempx);
+						 DWNLD_MAG1_TYPE_LOC, (u8 *)&tempx);
 		tempx = ntohl(tempx);
 	} else {
 		if (ft1000dev->usbboot == 2) {
@@ -313,8 +313,8 @@ static u16 get_request_type_usb(struct ft1000_usb *ft1000dev)
 		} else {
 			tempx = 0;
 			status = ft1000_read_dpram16(ft1000dev,
-					DWNLD_MAG1_TYPE_LOC,
-					(u8 *)&tempword, 1);
+						     DWNLD_MAG1_TYPE_LOC,
+						     (u8 *)&tempword, 1);
 		}
 		tempx |= (tempword << 16);
 		tempx = ntohl(tempx);
@@ -332,14 +332,14 @@ static long get_request_value(struct ft1000_usb *ft1000dev)
 
 	if (ft1000dev->bootmode == 1) {
 		status = fix_ft1000_read_dpram32(ft1000dev,
-				DWNLD_MAG1_SIZE_LOC, (u8 *)&value);
+						 DWNLD_MAG1_SIZE_LOC, (u8 *)&value);
 		value = ntohl(value);
 	} else	{
 		status = ft1000_read_dpram16(ft1000dev,
-				DWNLD_MAG1_SIZE_LOC, (u8 *)&tempword, 0);
+					     DWNLD_MAG1_SIZE_LOC, (u8 *)&tempword, 0);
 		value = tempword;
 		status = ft1000_read_dpram16(ft1000dev,
-				DWNLD_MAG1_SIZE_LOC, (u8 *)&tempword, 1);
+					     DWNLD_MAG1_SIZE_LOC, (u8 *)&tempword, 1);
 		value |= (tempword << 16);
 		value = ntohl(value);
 	}
@@ -369,7 +369,7 @@ static u16 hdr_checksum(struct pseudo_hdr *pHdr)
 
 
 	chksum = ((((((usPtr[0] ^ usPtr[1]) ^ usPtr[2]) ^ usPtr[3]) ^
-	usPtr[4]) ^ usPtr[5]) ^ usPtr[6]);
+		    usPtr[4]) ^ usPtr[5]) ^ usPtr[6]);
 
 	return chksum;
 }
@@ -387,7 +387,7 @@ static int check_buffers(u16 *buff_w, u16 *buff_r, int len, int offset)
 }
 
 static int write_dpram32_and_check(struct ft1000_usb *ft1000dev,
-		u16 tempbuffer[], u16 dpram)
+				   u16 tempbuffer[], u16 dpram)
 {
 	int status;
 	u16 resultbuffer[64];
@@ -395,37 +395,37 @@ static int write_dpram32_and_check(struct ft1000_usb *ft1000dev,
 
 	for (i = 0; i < 10; i++) {
 		status = ft1000_write_dpram32(ft1000dev, dpram,
-				(u8 *)&tempbuffer[0], 64);
+					      (u8 *)&tempbuffer[0], 64);
 		if (status == 0) {
 			/* Work around for ASIC bit stuffing problem. */
 			if ((tempbuffer[31] & 0xfe00) == 0xfe00) {
 				status = ft1000_write_dpram32(ft1000dev,
-						dpram+12, (u8 *)&tempbuffer[24],
-						64);
+							      dpram+12, (u8 *)&tempbuffer[24],
+							      64);
 			}
 			/* Let's check the data written */
 			status = ft1000_read_dpram32(ft1000dev, dpram,
-					(u8 *)&resultbuffer[0], 64);
+						     (u8 *)&resultbuffer[0], 64);
 			if ((tempbuffer[31] & 0xfe00) == 0xfe00) {
 				if (check_buffers(tempbuffer, resultbuffer, 28,
-							0)) {
+						  0)) {
 					DEBUG("FT1000:download:DPRAM write failed 1 during bootloading\n");
 					usleep_range(9000, 11000);
 					break;
 				}
 				status = ft1000_read_dpram32(ft1000dev,
-						dpram+12,
-						(u8 *)&resultbuffer[0], 64);
+							     dpram+12,
+							     (u8 *)&resultbuffer[0], 64);
 
 				if (check_buffers(tempbuffer, resultbuffer, 16,
-							24)) {
+						  24)) {
 					DEBUG("FT1000:download:DPRAM write failed 2 during bootloading\n");
 					usleep_range(9000, 11000);
 					break;
 				}
 			} else {
 				if (check_buffers(tempbuffer, resultbuffer, 32,
-							0)) {
+						  0)) {
 					DEBUG("FT1000:download:DPRAM write failed 3 during bootloading\n");
 					usleep_range(9000, 11000);
 					break;
@@ -445,7 +445,7 @@ static int write_dpram32_and_check(struct ft1000_usb *ft1000dev,
  *              long word_length - length of the buffer to be written to DPRAM
  */
 static int write_blk(struct ft1000_usb *ft1000dev, u16 **pUsFile, u8 **pUcFile,
-		long word_length)
+		     long word_length)
 {
 	int status = 0;
 	u16 dpram;
@@ -489,13 +489,13 @@ static int write_blk(struct ft1000_usb *ft1000dev, u16 **pUsFile, u8 **pUcFile,
 		if (ft1000dev->bootmode == 0) {
 			if (dpram >= 0x3F4)
 				status = ft1000_write_dpram32(ft1000dev, dpram,
-						(u8 *)&tempbuffer[0], 8);
+							      (u8 *)&tempbuffer[0], 8);
 			else
 				status = ft1000_write_dpram32(ft1000dev, dpram,
-						(u8 *)&tempbuffer[0], 64);
+							      (u8 *)&tempbuffer[0], 64);
 		} else {
 			status = write_dpram32_and_check(ft1000dev, tempbuffer,
-					dpram);
+							 dpram);
 			if (status != 0) {
 				DEBUG("FT1000:download:Write failed tempbuffer[31] = 0x%x\n", tempbuffer[31]);
 				break;
@@ -548,7 +548,7 @@ static int write_blk_fifo(struct ft1000_usb *ft1000dev, u16 **pUsFile,
 }
 
 static int scram_start_dwnld(struct ft1000_usb *ft1000dev, u16 *hshake,
-		u32 *state)
+			     u32 *state)
 {
 	int status = 0;
 
@@ -571,7 +571,7 @@ static int scram_start_dwnld(struct ft1000_usb *ft1000dev, u16 *hshake,
 }
 
 static int request_code_segment(struct ft1000_usb *ft1000dev, u16 **s_file,
-		 u8 **c_file, const u8 *endpoint, bool boot_case)
+				u8 **c_file, const u8 *endpoint, bool boot_case)
 {
 	long word_length;
 	int status = 0;
@@ -602,7 +602,7 @@ static int request_code_segment(struct ft1000_usb *ft1000dev, u16 **s_file,
 			ft1000dev->usbboot++;
 		if (ft1000dev->usbboot == 1)
 			status |= ft1000_write_dpram16(ft1000dev,
-					DWNLD_MAG1_PS_HDR_LOC, 0, 0);
+						       DWNLD_MAG1_PS_HDR_LOC, 0, 0);
 	}
 	return status;
 }
@@ -705,14 +705,14 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 					break;
 				case REQUEST_CODE_SEGMENT:
 					status = request_code_segment(ft1000dev,
-							&s_file, &c_file,
-							(const u8 *)boot_end,
-							true);
-				break;
+								      &s_file, &c_file,
+								      (const u8 *)boot_end,
+								      true);
+					break;
 				default:
 					DEBUG
-					    ("FT1000:download:Download error: Bad request type=%d in BOOT download state.\n",
-					     request);
+						("FT1000:download:Download error: Bad request type=%d in BOOT download state.\n",
+						 request);
 					status = -1;
 					break;
 				}
@@ -724,7 +724,7 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 						      HANDSHAKE_RESPONSE);
 			} else {
 				DEBUG
-				    ("FT1000:download:Download error: Handshake failed\n");
+					("FT1000:download:Download error: Handshake failed\n");
 				status = -1;
 			}
 
@@ -735,56 +735,56 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 			ft1000dev->bootmode = 0;
 			if (ft1000dev->usbboot)
 				handshake =
-				    get_handshake_usb(ft1000dev,
-						      HANDSHAKE_REQUEST);
+					get_handshake_usb(ft1000dev,
+							  HANDSHAKE_REQUEST);
 			else
 				handshake =
-				    get_handshake(ft1000dev, HANDSHAKE_REQUEST);
+					get_handshake(ft1000dev, HANDSHAKE_REQUEST);
 			if (handshake == HANDSHAKE_REQUEST) {
 				/*
 				 * Get type associated with the request.
 				 */
 				if (ft1000dev->usbboot)
 					request =
-					    get_request_type_usb(ft1000dev);
+						get_request_type_usb(ft1000dev);
 				else
 					request = get_request_type(ft1000dev);
 				switch (request) {
 				case REQUEST_FILE_CHECKSUM:
 					DEBUG
-					    ("FT1000:download:image_chksum = 0x%8x\n",
-					     image_chksum);
+						("FT1000:download:image_chksum = 0x%8x\n",
+						 image_chksum);
 					put_request_value(ft1000dev,
 							  image_chksum);
 					break;
 				case REQUEST_RUN_ADDRESS:
 					DEBUG
-					    ("FT1000:download:  REQUEST_RUN_ADDRESS\n");
+						("FT1000:download:  REQUEST_RUN_ADDRESS\n");
 					if (correct_version) {
 						DEBUG
-						    ("FT1000:download:run_address = 0x%8x\n",
-						     (int)run_address);
+							("FT1000:download:run_address = 0x%8x\n",
+							 (int)run_address);
 						put_request_value(ft1000dev,
 								  run_address);
 					} else {
 						DEBUG
-						    ("FT1000:download:Download error: Got Run address request before image offset request.\n");
+							("FT1000:download:Download error: Got Run address request before image offset request.\n");
 						status = -1;
 						break;
 					}
 					break;
 				case REQUEST_CODE_LENGTH:
 					DEBUG
-					    ("FT1000:download:REQUEST_CODE_LENGTH\n");
+						("FT1000:download:REQUEST_CODE_LENGTH\n");
 					if (correct_version) {
 						DEBUG
-						    ("FT1000:download:run_size = 0x%8x\n",
-						     (int)run_size);
+							("FT1000:download:run_size = 0x%8x\n",
+							 (int)run_size);
 						put_request_value(ft1000dev,
 								  run_size);
 					} else {
 						DEBUG
-						    ("FT1000:download:Download error: Got Size request before image offset request.\n");
+							("FT1000:download:Download error: Got Size request before image offset request.\n");
 						status = -1;
 						break;
 					}
@@ -793,47 +793,47 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 					ft1000dev->usbboot = 3;
 					/* Reposition ptrs to beginning of provisioning section */
 					s_file =
-					    (u16 *) (pFileStart +
-						     file_hdr->commands_offset);
+						(u16 *) (pFileStart +
+							 file_hdr->commands_offset);
 					c_file =
-					    (u8 *) (pFileStart +
-						    file_hdr->commands_offset);
+						(u8 *) (pFileStart +
+							file_hdr->commands_offset);
 					state = STATE_DONE_DWNLD;
 					break;
 				case REQUEST_CODE_SEGMENT:
 					/* DEBUG("FT1000:download: REQUEST_CODE_SEGMENT - CODELOADER\n"); */
 					if (!correct_version) {
 						DEBUG
-						    ("FT1000:download:Download error: Got Code Segment request before image offset request.\n");
+							("FT1000:download:Download error: Got Code Segment request before image offset request.\n");
 						status = -1;
 						break;
 					}
 
 					status = request_code_segment(ft1000dev,
-							&s_file, &c_file,
-							(const u8 *)code_end,
-							false);
+								      &s_file, &c_file,
+								      (const u8 *)code_end,
+								      false);
 
 					break;
 
 				case REQUEST_MAILBOX_DATA:
 					DEBUG
-					    ("FT1000:download: REQUEST_MAILBOX_DATA\n");
+						("FT1000:download: REQUEST_MAILBOX_DATA\n");
 					/* Convert length from byte count to word count. Make sure we round up. */
 					word_length =
-					    (long)(pft1000info->DSPInfoBlklen +
-						   1) / 2;
+						(long)(pft1000info->DSPInfoBlklen +
+						       1) / 2;
 					put_request_value(ft1000dev,
 							  word_length);
 					mailbox_data =
-					    (struct drv_msg *)&(pft1000info->
-								DSPInfoBlk[0]);
+						(struct drv_msg *)&(pft1000info->
+								    DSPInfoBlk[0]);
 					/*
 					 * Position ASIC DPRAM auto-increment pointer.
 					 */
 
-					data = (u16 *) &mailbox_data->data[0];
-					dpram = (u16) DWNLD_MAG1_PS_HDR_LOC;
+					data = (u16 *)&mailbox_data->data[0];
+					dpram = (u16)DWNLD_MAG1_PS_HDR_LOC;
 					if (word_length & 0x1)
 						word_length++;
 
@@ -844,18 +844,18 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 						templong = *data++;
 						templong |= (*data++ << 16);
 						status =
-						    fix_ft1000_write_dpram32
-						    (ft1000dev, dpram++,
-						     (u8 *) &templong);
+							fix_ft1000_write_dpram32
+							(ft1000dev, dpram++,
+							 (u8 *)&templong);
 
 					}
 					break;
 
 				case REQUEST_VERSION_INFO:
 					DEBUG
-					    ("FT1000:download:REQUEST_VERSION_INFO\n");
+						("FT1000:download:REQUEST_VERSION_INFO\n");
 					word_length =
-					    file_hdr->version_data_size;
+						file_hdr->version_data_size;
 					put_request_value(ft1000dev,
 							  word_length);
 					/*
@@ -863,11 +863,11 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 					 */
 
 					s_file =
-					    (u16 *) (pFileStart +
-						     file_hdr->
-						     version_data_offset);
+						(u16 *) (pFileStart +
+							 file_hdr->
+							 version_data_offset);
 
-					dpram = (u16) DWNLD_MAG1_PS_HDR_LOC;
+					dpram = (u16)DWNLD_MAG1_PS_HDR_LOC;
 					if (word_length & 0x1)
 						word_length++;
 
@@ -879,26 +879,26 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 						temp = ntohs(*s_file++);
 						templong |= (temp << 16);
 						status =
-						    fix_ft1000_write_dpram32
-						    (ft1000dev, dpram++,
-						     (u8 *) &templong);
+							fix_ft1000_write_dpram32
+							(ft1000dev, dpram++,
+							 (u8 *)&templong);
 
 					}
 					break;
 
 				case REQUEST_CODE_BY_VERSION:
 					DEBUG
-					    ("FT1000:download:REQUEST_CODE_BY_VERSION\n");
+						("FT1000:download:REQUEST_CODE_BY_VERSION\n");
 					correct_version = false;
 					requested_version =
-					    get_request_value(ft1000dev);
+						get_request_value(ft1000dev);
 
 					dsp_img_info =
-					    (struct dsp_image_info *)(pFileStart
-								      +
-								      sizeof
-								      (struct
-								       dsp_file_hdr));
+						(struct dsp_image_info *)(pFileStart
+									  +
+									  sizeof
+									  (struct
+									   dsp_file_hdr));
 
 					for (image = 0;
 					     image < file_hdr->nDspImages;
@@ -908,29 +908,29 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 						    requested_version) {
 							correct_version = true;
 							DEBUG
-							    ("FT1000:download: correct_version is TRUE\n");
+								("FT1000:download: correct_version is TRUE\n");
 							s_file =
-							    (u16 *) (pFileStart
-								     +
-								     dsp_img_info->
-								     begin_offset);
+								(u16 *) (pFileStart
+									 +
+									 dsp_img_info->
+									 begin_offset);
 							c_file =
-							    (u8 *) (pFileStart +
-								    dsp_img_info->
-								    begin_offset);
+								(u8 *) (pFileStart +
+									dsp_img_info->
+									begin_offset);
 							code_end =
-							    (u8 *) (pFileStart +
-								    dsp_img_info->
-								    end_offset);
+								(u8 *) (pFileStart +
+									dsp_img_info->
+									end_offset);
 							run_address =
-							    dsp_img_info->
-							    run_address;
+								dsp_img_info->
+								run_address;
 							run_size =
-							    dsp_img_info->
-							    image_size;
+								dsp_img_info->
+								image_size;
 							image_chksum =
-							    (u32) dsp_img_info->
-							    checksum;
+								(u32)dsp_img_info->
+								checksum;
 							break;
 						}
 						dsp_img_info++;
@@ -942,8 +942,8 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 						 * Error, beyond boot code range.
 						 */
 						DEBUG
-						    ("FT1000:download:Download error: Bad Version Request = 0x%x.\n",
-						     (int)requested_version);
+							("FT1000:download:Download error: Bad Version Request = 0x%x.\n",
+							 (int)requested_version);
 						status = -1;
 						break;
 					}
@@ -951,8 +951,8 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 
 				default:
 					DEBUG
-					    ("FT1000:download:Download error: Bad request type=%d in CODE download state.\n",
-					     request);
+						("FT1000:download:Download error: Bad request type=%d in CODE download state.\n",
+						 request);
 					status = -1;
 					break;
 				}
@@ -964,7 +964,7 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 						      HANDSHAKE_RESPONSE);
 			} else {
 				DEBUG
-				    ("FT1000:download:Download error: Handshake failed\n");
+					("FT1000:download:Download error: Handshake failed\n");
 				status = -1;
 			}
 
@@ -990,9 +990,9 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 
 				/* Get buffer for provisioning data */
 				pbuffer =
-				    kmalloc((pseudo_header_len +
-					     sizeof(struct pseudo_hdr)),
-					    GFP_ATOMIC);
+					kmalloc((pseudo_header_len +
+						 sizeof(struct pseudo_hdr)),
+						GFP_ATOMIC);
 				if (pbuffer) {
 					memcpy(pbuffer, (void *)c_file,
 					       (u32) (pseudo_header_len +
@@ -1000,20 +1000,20 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 							     pseudo_hdr)));
 					/* link provisioning data */
 					pprov_record =
-					    kmalloc(sizeof(struct prov_record),
-						    GFP_ATOMIC);
+						kmalloc(sizeof(struct prov_record),
+							GFP_ATOMIC);
 					if (pprov_record) {
 						pprov_record->pprov_data =
-						    pbuffer;
+							pbuffer;
 						list_add_tail(&pprov_record->
 							      list,
 							      &pft1000info->
 							      prov_list);
 						/* Move to next entry if available */
 						c_file =
-						    (u8 *) ((unsigned long)
-							    c_file +
-							    (u32) ((pseudo_header_len + 1) & 0xFFFFFFFE) + sizeof(struct pseudo_hdr));
+							(u8 *) ((unsigned long)
+								c_file +
+								(u32) ((pseudo_header_len + 1) & 0xFFFFFFFE) + sizeof(struct pseudo_hdr));
 						if ((unsigned long)(c_file) -
 						    (unsigned long)(pFileStart)
 						    >=
@@ -1032,8 +1032,8 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 				status = -1;
 			}
 			DEBUG
-			    ("ft1000:download: after STATE_SECTION_PROV, state = %d, status= %d\n",
-			     state, status);
+				("ft1000:download: after STATE_SECTION_PROV, state = %d, status= %d\n",
+				 state, status);
 			break;
 
 		case STATE_DONE_PROV:
@@ -1050,16 +1050,16 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 			break;
 
 /****
-      // Check if Card is present
-      status = Harley_Read_Register(&temp, FT1000_REG_SUP_IMASK);
-      if ( (status != NDIS_STATUS_SUCCESS) || (temp == 0x0000) ) {
-	break;
-      }
-
-      status = Harley_Read_Register(&temp, FT1000_REG_ASIC_ID);
-      if ( (status != NDIS_STATUS_SUCCESS) || (temp == 0xffff) ) {
-	break;
-      }
+ // Check if Card is present
+ status = Harley_Read_Register(&temp, FT1000_REG_SUP_IMASK);
+ if ( (status != NDIS_STATUS_SUCCESS) || (temp == 0x0000) ) {
+ break;
+ }
+
+ status = Harley_Read_Register(&temp, FT1000_REG_ASIC_ID);
+ if ( (status != NDIS_STATUS_SUCCESS) || (temp == 0xffff) ) {
+ break;
+ }
 ****/
 
 	}			/* End while */
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 2e13e7b..da11955 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -1,8 +1,8 @@
 /* CopyRight (C) 2007 Qualcomm Inc. All Rights Reserved.
-*
-*
-* This file is part of Express Card USB Driver
-*/
+ *
+ *
+ * This file is part of Express Card USB Driver
+ */
 
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -35,16 +35,16 @@ static u8 tempbuffer[1600];
 #define MAX_RCV_LOOP   100
 
 /* send a control message via USB interface synchronously
-*  Parameters:  ft1000_usb  - device structure
-*               pipe - usb control message pipe
-*               request - control request
-*               requesttype - control message request type
-*               value - value to be written or 0
-*               index - register index
-*               data - data buffer to hold the read/write values
-*               size - data size
-*               timeout - control message time out value
-*/
+ *  Parameters:  ft1000_usb  - device structure
+ *               pipe - usb control message pipe
+ *               request - control request
+ *               requesttype - control message request type
+ *               value - value to be written or 0
+ *               index - register index
+ *               data - data buffer to hold the read/write values
+ *               size - data size
+ *               timeout - control message time out value
+ */
 static int ft1000_control(struct ft1000_usb *ft1000dev, unsigned int pipe,
 			  u8 request, u8 requesttype, u16 value, u16 index,
 			  void *data, u16 size, int timeout)
@@ -171,7 +171,7 @@ int ft1000_read_dpram16(struct ft1000_usb *ft1000dev, u16 indx, u8 *buffer,
 
 /* write into DPRAM a number of bytes */
 int ft1000_write_dpram16(struct ft1000_usb *ft1000dev, u16 indx, u16 value,
-		u8 highlow)
+			 u8 highlow)
 {
 	int ret = 0;
 	u8 request;
@@ -287,7 +287,7 @@ static void card_reset_dsp(struct ft1000_usb *ft1000dev, bool value)
 	u16 tempword;
 
 	status = ft1000_write_register(ft1000dev, HOST_INTF_BE,
-					FT1000_REG_SUP_CTRL);
+				       FT1000_REG_SUP_CTRL);
 	status = ft1000_read_register(ft1000dev, &tempword,
 				      FT1000_REG_SUP_CTRL);
 
@@ -318,12 +318,12 @@ static void card_reset_dsp(struct ft1000_usb *ft1000dev, bool value)
 }
 
 /* send a command to ASIC
-*  Parameters:  ft1000_usb  - device structure
-*               ptempbuffer - command buffer
-*               size - command buffer size
-*/
+ *  Parameters:  ft1000_usb  - device structure
+ *               ptempbuffer - command buffer
+ *               size - command buffer size
+ */
 int card_send_command(struct ft1000_usb *ft1000dev, void *ptempbuffer,
-		       int size)
+		      int size)
 {
 	int ret;
 	unsigned short temp;
@@ -355,7 +355,7 @@ int card_send_command(struct ft1000_usb *ft1000dev, void *ptempbuffer,
 		return ret;
 	usleep_range(900, 1100);
 	ret = ft1000_write_register(ft1000dev, FT1000_DB_DPRAM_TX,
-			      FT1000_REG_DOORBELL);
+				    FT1000_REG_DOORBELL);
 	if (ret)
 		return ret;
 	usleep_range(900, 1100);
@@ -399,12 +399,12 @@ int dsp_reload(struct ft1000_usb *ft1000dev)
 	msleep(1000);
 
 	status =
-	    ft1000_write_register(ft1000dev, HOST_INTF_BE, FT1000_REG_SUP_CTRL);
+		ft1000_write_register(ft1000dev, HOST_INTF_BE, FT1000_REG_SUP_CTRL);
 
 	/* Let's check for FEFE */
 	status =
-	    ft1000_read_dpram32(ft1000dev, FT1000_MAG_DPRAM_FEFE_INDX,
-				(u8 *) &templong, 4);
+		ft1000_read_dpram32(ft1000dev, FT1000_MAG_DPRAM_FEFE_INDX,
+				    (u8 *)&templong, 4);
 	DEBUG("templong (fefe) = 0x%8x\n", templong);
 
 	/* call codeloader */
@@ -465,7 +465,7 @@ static int ft1000_reset_card(struct net_device *dev)
 	while (list_empty(&info->prov_list) == 0) {
 		DEBUG("ft1000_reset_card:deleting provisioning record\n");
 		ptr =
-		    list_entry(info->prov_list.next, struct prov_record, list);
+			list_entry(info->prov_list.next, struct prov_record, list);
 		list_del(&ptr->list);
 		kfree(ptr->pprov_data);
 		kfree(ptr);
@@ -484,7 +484,7 @@ static int ft1000_reset_card(struct net_device *dev)
 	/* Initialize DSP heartbeat area */
 	ft1000_write_dpram16(ft1000dev, FT1000_MAG_HI_HO, ho_mag,
 			     FT1000_MAG_HI_HO_INDX);
-	ft1000_read_dpram16(ft1000dev, FT1000_MAG_HI_HO, (u8 *) &tempword,
+	ft1000_read_dpram16(ft1000dev, FT1000_MAG_HI_HO, (u8 *)&tempword,
 			    FT1000_MAG_HI_HO_INDX);
 	DEBUG("ft1000_hw:ft1000_reset_card:hi_ho value = 0x%x\n", tempword);
 
@@ -508,8 +508,8 @@ static void ft1000_usb_transmit_complete(struct urb *urb)
 }
 
 /* take an ethernet packet and convert it to a Flarion
-*  packet prior to sending it to the ASIC Downlink FIFO.
-*/
+ *  packet prior to sending it to the ASIC Downlink FIFO.
+ */
 static int ft1000_copy_down_pkt(struct net_device *netdev, u8 *packet, u16 len)
 {
 	struct ft1000_info *pInfo = netdev_priv(netdev);
@@ -545,7 +545,7 @@ static int ft1000_copy_down_pkt(struct net_device *netdev, u8 *packet, u16 len)
 	hdr.control = 0x00;
 
 	hdr.checksum = hdr.length ^ hdr.source ^ hdr.destination ^
-	    hdr.portdest ^ hdr.portsrc ^ hdr.sh_str_id ^ hdr.control;
+		hdr.portdest ^ hdr.portsrc ^ hdr.sh_str_id ^ hdr.control;
 
 	memcpy(&pFt1000Dev->tx_buf[0], &hdr, sizeof(hdr));
 	memcpy(&(pFt1000Dev->tx_buf[sizeof(struct pseudo_hdr)]), packet, len);
@@ -559,7 +559,7 @@ static int ft1000_copy_down_pkt(struct net_device *netdev, u8 *packet, u16 len)
 			  pFt1000Dev->tx_buf, count,
 			  ft1000_usb_transmit_complete, (void *)pFt1000Dev);
 
-	t = (u8 *) pFt1000Dev->tx_urb->transfer_buffer;
+	t = (u8 *)pFt1000Dev->tx_urb->transfer_buffer;
 
 	ret = usb_submit_urb(pFt1000Dev->tx_urb, GFP_ATOMIC);
 
@@ -574,9 +574,9 @@ static int ft1000_copy_down_pkt(struct net_device *netdev, u8 *packet, u16 len)
 }
 
 /* transmit an ethernet packet
-*  Parameters:  skb - socket buffer to be sent
-*               dev - network device
-*/
+ *  Parameters:  skb - socket buffer to be sent
+ *               dev - network device
+ */
 static int ft1000_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ft1000_info *pInfo = netdev_priv(dev);
@@ -595,10 +595,10 @@ static int ft1000_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	pipe =
-	    usb_sndbulkpipe(pFt1000Dev->dev, pFt1000Dev->bulk_out_endpointAddr);
+		usb_sndbulkpipe(pFt1000Dev->dev, pFt1000Dev->bulk_out_endpointAddr);
 	maxlen = usb_maxpacket(pFt1000Dev->dev, pipe, usb_pipeout(pipe));
 
-	pdata = (u8 *) skb->data;
+	pdata = (u8 *)skb->data;
 
 	if (pInfo->mediastate == 0) {
 		/* Drop packet is mediastate is down */
@@ -814,8 +814,8 @@ int reg_ft1000_netdev(struct ft1000_usb *ft1000dev,
 }
 
 /* take a packet from the FIFO up link and
-*  convert it into an ethernet packet and deliver it to the IP stack
-*/
+ *  convert it into an ethernet packet and deliver it to the IP stack
+ */
 static int ft1000_copy_up_pkt(struct urb *urb)
 {
 	struct ft1000_info *info = urb->context;
@@ -839,7 +839,7 @@ static int ft1000_copy_up_pkt(struct urb *urb)
 	len = urb->transfer_buffer_length;
 	lena = urb->actual_length;
 
-	chksum = (u16 *) ft1000dev->rx_buf;
+	chksum = (u16 *)ft1000dev->rx_buf;
 
 	tempword = *chksum++;
 	for (i = 1; i < 7; i++)
@@ -860,7 +860,7 @@ static int ft1000_copy_up_pkt(struct urb *urb)
 		return -1;
 	}
 
-	pbuffer = (u8 *) skb_put(skb, len + 12);
+	pbuffer = (u8 *)skb_put(skb, len + 12);
 
 	/* subtract the number of bytes read already */
 	ptemp = pbuffer;
@@ -914,7 +914,7 @@ static int ft1000_submit_rx_urb(struct ft1000_info *info)
 			  usb_rcvbulkpipe(pFt1000Dev->dev,
 					  pFt1000Dev->bulk_in_endpointAddr),
 			  pFt1000Dev->rx_buf, MAX_BUF_SIZE,
-			  (usb_complete_t) ft1000_copy_up_pkt, info);
+			  (usb_complete_t)ft1000_copy_up_pkt, info);
 
 	result = usb_submit_urb(pFt1000Dev->rx_urb, GFP_ATOMIC);
 
@@ -976,10 +976,10 @@ static int ft1000_chkcard(struct ft1000_usb *dev)
 }
 
 /* read a message from the dpram area.
-*  Input:
-*    dev - network device structure
-*    pbuffer - caller supply address to buffer
-*/
+ *  Input:
+ *    dev - network device structure
+ *    pbuffer - caller supply address to buffer
+ */
 static bool ft1000_receive_cmd(struct ft1000_usb *dev, u16 *pbuffer,
 			       int maxsz)
 {
@@ -990,46 +990,46 @@ static bool ft1000_receive_cmd(struct ft1000_usb *dev, u16 *pbuffer,
 	u16 tempword;
 
 	ret =
-	    ft1000_read_dpram16(dev, FT1000_MAG_PH_LEN, (u8 *) &size,
-				FT1000_MAG_PH_LEN_INDX);
+		ft1000_read_dpram16(dev, FT1000_MAG_PH_LEN, (u8 *)&size,
+				    FT1000_MAG_PH_LEN_INDX);
 	size = ntohs(size) + PSEUDOSZ;
 	if (size > maxsz) {
 		DEBUG("FT1000:ft1000_receive_cmd:Invalid command length = %d\n",
 		      size);
 		return FALSE;
 	}
-	ppseudohdr = (u16 *) pbuffer;
+	ppseudohdr = (u16 *)pbuffer;
 	ft1000_write_register(dev, FT1000_DPRAM_MAG_RX_BASE,
 			      FT1000_REG_DPRAM_ADDR);
 	ret =
-	    ft1000_read_register(dev, pbuffer, FT1000_REG_MAG_DPDATAH);
+		ft1000_read_register(dev, pbuffer, FT1000_REG_MAG_DPDATAH);
 	pbuffer++;
 	ft1000_write_register(dev, FT1000_DPRAM_MAG_RX_BASE + 1,
 			      FT1000_REG_DPRAM_ADDR);
 	for (i = 0; i <= (size >> 2); i++) {
 		ret =
-		    ft1000_read_register(dev, pbuffer,
-					 FT1000_REG_MAG_DPDATAL);
+			ft1000_read_register(dev, pbuffer,
+					     FT1000_REG_MAG_DPDATAL);
 		pbuffer++;
 		ret =
-		    ft1000_read_register(dev, pbuffer,
-					 FT1000_REG_MAG_DPDATAH);
+			ft1000_read_register(dev, pbuffer,
+					     FT1000_REG_MAG_DPDATAH);
 		pbuffer++;
 	}
 	/* copy odd aligned word */
 	ret =
-	    ft1000_read_register(dev, pbuffer, FT1000_REG_MAG_DPDATAL);
+		ft1000_read_register(dev, pbuffer, FT1000_REG_MAG_DPDATAL);
 
 	pbuffer++;
 	ret =
-	    ft1000_read_register(dev, pbuffer, FT1000_REG_MAG_DPDATAH);
+		ft1000_read_register(dev, pbuffer, FT1000_REG_MAG_DPDATAH);
 
 	pbuffer++;
 	if (size & 0x0001) {
 		/* copy odd byte from fifo */
 		ret =
-		    ft1000_read_register(dev, &tempword,
-					 FT1000_REG_DPRAM_DATA);
+			ft1000_read_register(dev, &tempword,
+					     FT1000_REG_DPRAM_DATA);
 		*pbuffer = ntohs(tempword);
 	}
 	/* Check if pseudo header checksum is good
@@ -1066,7 +1066,7 @@ static int ft1000_dsp_prov(void *arg)
 		/* Check if doorbell is available */
 		DEBUG("check if doorbell is cleared\n");
 		status =
-		    ft1000_read_register(dev, &tempword, FT1000_REG_DOORBELL);
+			ft1000_read_register(dev, &tempword, FT1000_REG_DOORBELL);
 		if (status) {
 			DEBUG("ft1000_dsp_prov::ft1000_read_register error\n");
 			break;
@@ -1088,13 +1088,13 @@ static int ft1000_dsp_prov(void *arg)
 
 			/* Send provisioning data */
 			ptr =
-			    list_entry(info->prov_list.next, struct prov_record,
-				       list);
-			len = *(u16 *) ptr->pprov_data;
+				list_entry(info->prov_list.next, struct prov_record,
+					   list);
+			len = *(u16 *)ptr->pprov_data;
 			len = htons(len);
 			len += PSEUDOSZ;
 
-			pmsg = (u16 *) ptr->pprov_data;
+			pmsg = (u16 *)ptr->pprov_data;
 			ppseudo_hdr = (struct pseudo_hdr *)pmsg;
 			/* Insert slow queue sequence number */
 			ppseudo_hdr->seq_num = info->squeseqnum++;
@@ -1109,12 +1109,12 @@ static int ft1000_dsp_prov(void *arg)
 			memcpy(&TempShortBuf[2], ppseudo_hdr, len);
 
 			status =
-			    ft1000_write_dpram32(dev, 0,
-						 (u8 *) &TempShortBuf[0],
-						 (unsigned short)(len + 2));
+				ft1000_write_dpram32(dev, 0,
+						     (u8 *)&TempShortBuf[0],
+						     (unsigned short)(len + 2));
 			status =
-			    ft1000_write_register(dev, FT1000_DB_DPRAM_TX,
-						  FT1000_REG_DOORBELL);
+				ft1000_write_register(dev, FT1000_DB_DPRAM_TX,
+						      FT1000_REG_DOORBELL);
 
 			list_del(&ptr->list);
 			kfree(ptr->pprov_data);
@@ -1229,12 +1229,12 @@ static int ft1000_proc_drvmsg(struct ft1000_usb *dev, u16 size)
 		if (ntohs(pdspinitmsg->length) ==
 		    (sizeof(struct dsp_init_msg) - 20)) {
 			memcpy(info->ProductMode, pdspinitmsg->ProductMode,
-					MODESZ);
+			       MODESZ);
 			memcpy(info->RfCalVer, pdspinitmsg->RfCalVer, CALVERSZ);
 			memcpy(info->RfCalDate, pdspinitmsg->RfCalDate,
 			       CALDATESZ);
 			DEBUG("RFCalVer = 0x%2x 0x%2x\n", info->RfCalVer[0],
-					info->RfCalVer[1]);
+			      info->RfCalVer[1]);
 		}
 		break;
 	}
@@ -1252,7 +1252,7 @@ static int ft1000_proc_drvmsg(struct ft1000_usb *dev, u16 size)
 		} else {
 			dev->fProvComplete = true;
 			status = ft1000_write_register(dev, FT1000_DB_HB,
-					FT1000_REG_DOORBELL);
+						       FT1000_REG_DOORBELL);
 			DEBUG("FT1000:drivermsg:No more DSP provisioning data in dsp image\n");
 		}
 		DEBUG("ft1000_proc_drvmsg:DSP PROVISION is done\n");
@@ -1264,7 +1264,7 @@ static int ft1000_proc_drvmsg(struct ft1000_usb *dev, u16 size)
 		tempword = ntohs(pdrvmsg->length);
 		info->DSPInfoBlklen = tempword;
 		if (tempword < (MAX_DSP_SESS_REC - 4)) {
-			pmsg = (u16 *) &pdrvmsg->data[0];
+			pmsg = (u16 *)&pdrvmsg->data[0];
 			for (i = 0; i < ((tempword + 1) / 2); i++) {
 				DEBUG("FT1000:drivermsg:dsp info data = 0x%x\n", *pmsg);
 				info->DSPInfoBlk[i + 10] = *pmsg++;
@@ -1281,27 +1281,27 @@ static int ft1000_proc_drvmsg(struct ft1000_usb *dev, u16 size)
 		/* allow any outstanding ioctl to finish */
 		mdelay(10);
 		status = ft1000_read_register(dev, &tempword,
-				FT1000_REG_DOORBELL);
+					      FT1000_REG_DOORBELL);
 		if (tempword & FT1000_DB_DPRAM_TX) {
 			mdelay(10);
 			status = ft1000_read_register(dev, &tempword,
-					FT1000_REG_DOORBELL);
+						      FT1000_REG_DOORBELL);
 			if (tempword & FT1000_DB_DPRAM_TX) {
 				mdelay(10);
 				status = ft1000_read_register(dev, &tempword,
-						FT1000_REG_DOORBELL);
+							      FT1000_REG_DOORBELL);
 				if (tempword & FT1000_DB_DPRAM_TX)
 					break;
 			}
 		}
 		/* Put message into Slow Queue Form Pseudo header */
-		pmsg = (u16 *) info->DSPInfoBlk;
+		pmsg = (u16 *)info->DSPInfoBlk;
 		*pmsg++ = 0;
 		*pmsg++ = htons(info->DSPInfoBlklen + 20 + info->DSPInfoBlklen);
 		ppseudo_hdr =
-		    (struct pseudo_hdr *)(u16 *) &info->DSPInfoBlk[2];
+			(struct pseudo_hdr *)(u16 *)&info->DSPInfoBlk[2];
 		ppseudo_hdr->length = htons(info->DSPInfoBlklen + 4
-				+ info->DSPInfoBlklen);
+					    + info->DSPInfoBlklen);
 		ppseudo_hdr->source = 0x10;
 		ppseudo_hdr->destination = 0x20;
 		ppseudo_hdr->portdest = 0;
@@ -1323,10 +1323,10 @@ static int ft1000_proc_drvmsg(struct ft1000_usb *dev, u16 size)
 		info->DSPInfoBlk[10] = 0x7200;
 		info->DSPInfoBlk[11] = htons(info->DSPInfoBlklen);
 		status = ft1000_write_dpram32(dev, 0,
-				(u8 *)&info->DSPInfoBlk[0],
-				(unsigned short)(info->DSPInfoBlklen + 22));
+					      (u8 *)&info->DSPInfoBlk[0],
+					      (unsigned short)(info->DSPInfoBlklen + 22));
 		status = ft1000_write_register(dev, FT1000_DB_DPRAM_TX,
-				FT1000_REG_DOORBELL);
+					       FT1000_REG_DOORBELL);
 		dev->DrvMsgPend = 0;
 		break;
 	}
@@ -1337,17 +1337,17 @@ static int ft1000_proc_drvmsg(struct ft1000_usb *dev, u16 size)
 		/* allow any outstanding ioctl to finish */
 		mdelay(10);
 		status = ft1000_read_register(dev, &tempword,
-				FT1000_REG_DOORBELL);
+					      FT1000_REG_DOORBELL);
 		if (tempword & FT1000_DB_DPRAM_TX) {
 			mdelay(10);
 			status = ft1000_read_register(dev, &tempword,
-					FT1000_REG_DOORBELL);
+						      FT1000_REG_DOORBELL);
 			if (tempword & FT1000_DB_DPRAM_TX)
 				mdelay(10);
 		}
 		if ((tempword & FT1000_DB_DPRAM_TX) == 0) {
 			/* Put message into Slow Queue Form Pseudo header */
-			pmsg = (u16 *) &tempbuffer[0];
+			pmsg = (u16 *)&tempbuffer[0];
 			ppseudo_hdr = (struct pseudo_hdr *)pmsg;
 			ppseudo_hdr->length = htons(0x0012);
 			ppseudo_hdr->source = 0x10;
@@ -1368,7 +1368,7 @@ static int ft1000_proc_drvmsg(struct ft1000_usb *dev, u16 size)
 			for (i = 1; i < 7; i++)
 				ppseudo_hdr->checksum ^= *pmsg++;
 
-			pmsg = (u16 *) &tempbuffer[16];
+			pmsg = (u16 *)&tempbuffer[16];
 			*pmsg++ = htons(RSP_DRV_ERR_RPT_MSG);
 			*pmsg++ = htons(0x000e);
 			*pmsg++ = htons(info->DSP_TIME[0]);
@@ -1384,7 +1384,7 @@ static int ft1000_proc_drvmsg(struct ft1000_usb *dev, u16 size)
 			*pmsg++ = htons(info->DrvErrNum);
 
 			status = card_send_command(dev, (unsigned char *)&tempbuffer[0],
-					(u16)(0x0012 + PSEUDOSZ));
+						   (u16)(0x0012 + PSEUDOSZ));
 			if (status)
 				goto out;
 			info->DrvErrNum = 0;
@@ -1412,9 +1412,9 @@ static int dsp_broadcast_msg_id(struct ft1000_usb *dev)
 
 	for (i = 0; i < MAX_NUM_APP; i++) {
 		if ((dev->app_info[i].DspBCMsgFlag)
-				&& (dev->app_info[i].fileobject)
-				&& (dev->app_info[i].NumOfMsg
-					< MAX_MSG_LIMIT)) {
+		    && (dev->app_info[i].fileobject)
+		    && (dev->app_info[i].NumOfMsg
+			< MAX_MSG_LIMIT)) {
 			pdpram_blk = ft1000_get_buffer(&freercvpool);
 			if (pdpram_blk == NULL) {
 				DEBUG("Out of memory in free receive command pool\n");
@@ -1422,18 +1422,18 @@ static int dsp_broadcast_msg_id(struct ft1000_usb *dev)
 				return -1;
 			}
 			if (ft1000_receive_cmd(dev, pdpram_blk->pbuffer,
-						MAX_CMD_SQSIZE)) {
+					       MAX_CMD_SQSIZE)) {
 				/* Put message into the
 				 * appropriate application block
 				 */
 				dev->app_info[i].nRxMsg++;
 				spin_lock_irqsave(&free_buff_lock, flags);
 				list_add_tail(&pdpram_blk->list,
-						&dev->app_info[i] .app_sqlist);
+					      &dev->app_info[i] .app_sqlist);
 				dev->app_info[i].NumOfMsg++;
 				spin_unlock_irqrestore(&free_buff_lock, flags);
 				wake_up_interruptible(&dev->app_info[i]
-						.wait_dpram_msg);
+						      .wait_dpram_msg);
 			} else {
 				dev->app_info[i].nRxMsgMiss++;
 				ft1000_free_buffer(pdpram_blk, &freercvpool);
@@ -1461,7 +1461,7 @@ static int handle_misc_portid(struct ft1000_usb *dev)
 	/* Search for correct application block */
 	for (i = 0; i < MAX_NUM_APP; i++) {
 		if (dev->app_info[i].app_id == ((struct pseudo_hdr *)
-					pdpram_blk->pbuffer)->portdest)
+						pdpram_blk->pbuffer)->portdest)
 			break;
 	}
 	if (i == MAX_NUM_APP) {
@@ -1502,14 +1502,14 @@ int ft1000_poll(void *dev_id)
 	if (!status) {
 		if (tempword & FT1000_DB_DPRAM_RX) {
 			status = ft1000_read_dpram16(dev,
-					0x200, (u8 *)&data, 0);
+						     0x200, (u8 *)&data, 0);
 			size = ntohs(data) + 16 + 2;
 			if (size % 4) {
 				modulo = 4 - (size % 4);
 				size = size + modulo;
 			}
 			status = ft1000_read_dpram16(dev, 0x201,
-					(u8 *)&portid, 1);
+						     (u8 *)&portid, 1);
 			portid &= 0xff;
 			if (size < MAX_CMD_SQSIZE) {
 				switch (portid) {
@@ -1529,18 +1529,18 @@ int ft1000_poll(void *dev_id)
 			} else
 				DEBUG("FT1000:dpc:Invalid total length for SlowQ = %d\n", size);
 			status = ft1000_write_register(dev,
-					FT1000_DB_DPRAM_RX,
-					FT1000_REG_DOORBELL);
+						       FT1000_DB_DPRAM_RX,
+						       FT1000_REG_DOORBELL);
 		} else if (tempword & FT1000_DSP_ASIC_RESET) {
 			/* Let's reset the ASIC from the Host side as well */
 			status = ft1000_write_register(dev, ASIC_RESET_BIT,
-					FT1000_REG_RESET);
+						       FT1000_REG_RESET);
 			status = ft1000_read_register(dev, &tempword,
-					FT1000_REG_RESET);
+						      FT1000_REG_RESET);
 			i = 0;
 			while (tempword & ASIC_RESET_BIT) {
 				status = ft1000_read_register(dev, &tempword,
-						FT1000_REG_RESET);
+							      FT1000_REG_RESET);
 				usleep_range(9000, 11000);
 				i++;
 				if (i == 100)
@@ -1553,51 +1553,51 @@ int ft1000_poll(void *dev_id)
 			usleep_range(9000, 11000);
 			/* Program WMARK register */
 			status = ft1000_write_register(dev, 0x600,
-					FT1000_REG_MAG_WATERMARK);
+						       FT1000_REG_MAG_WATERMARK);
 			/* clear ASIC reset doorbell */
 			status = ft1000_write_register(dev,
-					FT1000_DSP_ASIC_RESET,
-					FT1000_REG_DOORBELL);
+						       FT1000_DSP_ASIC_RESET,
+						       FT1000_REG_DOORBELL);
 			usleep_range(9000, 11000);
 		} else if (tempword & FT1000_ASIC_RESET_REQ) {
 			DEBUG("ft1000_poll: FT1000_REG_DOORBELL message type:  FT1000_ASIC_RESET_REQ\n");
 			/* clear ASIC reset request from DSP */
 			status = ft1000_write_register(dev,
-					FT1000_ASIC_RESET_REQ,
-					FT1000_REG_DOORBELL);
+						       FT1000_ASIC_RESET_REQ,
+						       FT1000_REG_DOORBELL);
 			status = ft1000_write_register(dev, HOST_INTF_BE,
-					FT1000_REG_SUP_CTRL);
+						       FT1000_REG_SUP_CTRL);
 			/* copy dsp session record from Adapter block */
 			status = ft1000_write_dpram32(dev, 0,
-					(u8 *)&info->DSPSess.Rec[0], 1024);
+						      (u8 *)&info->DSPSess.Rec[0], 1024);
 			status = ft1000_write_register(dev, 0x600,
-					FT1000_REG_MAG_WATERMARK);
+						       FT1000_REG_MAG_WATERMARK);
 			/* ring doorbell to tell DSP that
 			 * ASIC is out of reset
 			 * */
 			status = ft1000_write_register(dev,
-					FT1000_ASIC_RESET_DSP,
-					FT1000_REG_DOORBELL);
+						       FT1000_ASIC_RESET_DSP,
+						       FT1000_REG_DOORBELL);
 		} else if (tempword & FT1000_DB_COND_RESET) {
 			DEBUG("ft1000_poll: FT1000_REG_DOORBELL message type:  FT1000_DB_COND_RESET\n");
 			if (!dev->fAppMsgPend) {
 				/* Reset ASIC and DSP */
 				status = ft1000_read_dpram16(dev,
-						FT1000_MAG_DSP_TIMER0,
-						(u8 *)&(info->DSP_TIME[0]),
-						FT1000_MAG_DSP_TIMER0_INDX);
+							     FT1000_MAG_DSP_TIMER0,
+							     (u8 *)&(info->DSP_TIME[0]),
+							     FT1000_MAG_DSP_TIMER0_INDX);
 				status = ft1000_read_dpram16(dev,
-						FT1000_MAG_DSP_TIMER1,
-						(u8 *)&(info->DSP_TIME[1]),
-						FT1000_MAG_DSP_TIMER1_INDX);
+							     FT1000_MAG_DSP_TIMER1,
+							     (u8 *)&(info->DSP_TIME[1]),
+							     FT1000_MAG_DSP_TIMER1_INDX);
 				status = ft1000_read_dpram16(dev,
-						FT1000_MAG_DSP_TIMER2,
-						(u8 *)&(info->DSP_TIME[2]),
-						FT1000_MAG_DSP_TIMER2_INDX);
+							     FT1000_MAG_DSP_TIMER2,
+							     (u8 *)&(info->DSP_TIME[2]),
+							     FT1000_MAG_DSP_TIMER2_INDX);
 				status = ft1000_read_dpram16(dev,
-						FT1000_MAG_DSP_TIMER3,
-						(u8 *)&(info->DSP_TIME[3]),
-						FT1000_MAG_DSP_TIMER3_INDX);
+							     FT1000_MAG_DSP_TIMER3,
+							     (u8 *)&(info->DSP_TIME[3]),
+							     FT1000_MAG_DSP_TIMER3_INDX);
 				info->CardReady = 0;
 				info->DrvErrNum = DSP_CONDRESET_INFO;
 				DEBUG("ft1000_hw:DSP conditional reset requested\n");
@@ -1607,7 +1607,7 @@ int ft1000_poll(void *dev_id)
 				dev->fCondResetPend = true;
 			}
 			ft1000_write_register(dev, FT1000_DB_COND_RESET,
-					FT1000_REG_DOORBELL);
+					      FT1000_REG_DOORBELL);
 		}
 	}
 	return 0;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h b/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h
index cb644a5..e9472be 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h
@@ -1,30 +1,30 @@
 /*
-*---------------------------------------------------------------------------
-* FT1000 driver for Flarion Flash OFDM NIC Device
-*
-* Copyright (C) 2002 Flarion Technologies, All rights reserved.
-*
-* This program is free software; you can redistribute it and/or modify it
-* under the terms of the GNU General Public License as published by the Free
-* Software Foundation; either version 2 of the License, or (at your option) any
-* later version. This program is distributed in the hope that it will be useful,
-* but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
-* or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
-* more details. You should have received a copy of the GNU General Public
-* License along with this program; if not, write to the
-* Free Software Foundation, Inc., 59 Temple Place -
-* Suite 330, Boston, MA 02111-1307, USA.
-*---------------------------------------------------------------------------
-*
-* File:         ft1000_ioctl.h
-*
-* Description:    Common structures and defines relating to IOCTL
-*
-* History:
-* 11/5/02    Whc                Created.
-*
-*---------------------------------------------------------------------------
-*/
+ *---------------------------------------------------------------------------
+ * FT1000 driver for Flarion Flash OFDM NIC Device
+ *
+ * Copyright (C) 2002 Flarion Technologies, All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option) any
+ * later version. This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details. You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place -
+ * Suite 330, Boston, MA 02111-1307, USA.
+ *---------------------------------------------------------------------------
+ *
+ * File:         ft1000_ioctl.h
+ *
+ * Description:    Common structures and defines relating to IOCTL
+ *
+ * History:
+ * 11/5/02    Whc                Created.
+ *
+ *---------------------------------------------------------------------------
+ */
 #ifndef _FT1000IOCTLH_
 #define _FT1000IOCTLH_
 
@@ -94,8 +94,8 @@ struct IOCTL_DPRAM_COMMAND {
 } __packed;
 
 /*
-* Custom IOCTL command codes
-*/
+ * Custom IOCTL command codes
+ */
 #define FT1000_MAGIC_CODE      'F'
 
 #define IOCTL_REGISTER_CMD	0
@@ -106,8 +106,8 @@ struct IOCTL_DPRAM_COMMAND {
 #define IOCTL_CONNECT		10
 #define IOCTL_DISCONNECT	11
 
-#define IOCTL_FT1000_GET_DSP_STAT _IOR(FT1000_MAGIC_CODE,      \
-				       IOCTL_GET_DSP_STAT_CMD, \
+#define IOCTL_FT1000_GET_DSP_STAT _IOR(FT1000_MAGIC_CODE,		\
+				       IOCTL_GET_DSP_STAT_CMD,		\
 				       struct IOCTL_GET_DSP_STAT)
 #define IOCTL_FT1000_GET_VER _IOR(FT1000_MAGIC_CODE, IOCTL_GET_VER_CMD, \
 				  struct IOCTL_GET_VER)
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index 39be30c..244e3d6 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -109,8 +109,8 @@ static int ft1000_probe(struct usb_interface *interface,
 
 	for (i = 0; i < iface_desc->desc.bNumEndpoints; i++) {
 		endpoint =
-		    (struct usb_endpoint_descriptor *)&iface_desc->
-		    endpoint[i].desc;
+			(struct usb_endpoint_descriptor *)&iface_desc->
+			endpoint[i].desc;
 		DEBUG("endpoint %d\n", i);
 		DEBUG("bEndpointAddress=%x, bmAttributes=%x\n",
 		      endpoint->bEndpointAddress, endpoint->bmAttributes);
@@ -118,7 +118,7 @@ static int ft1000_probe(struct usb_interface *interface,
 		    && ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
 			USB_ENDPOINT_XFER_BULK)) {
 			ft1000dev->bulk_in_endpointAddr =
-			    endpoint->bEndpointAddress;
+				endpoint->bEndpointAddress;
 			DEBUG("ft1000_probe: in: %d\n",
 			      endpoint->bEndpointAddress);
 		}
@@ -127,7 +127,7 @@ static int ft1000_probe(struct usb_interface *interface,
 		    && ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
 			USB_ENDPOINT_XFER_BULK)) {
 			ft1000dev->bulk_out_endpointAddr =
-			    endpoint->bEndpointAddress;
+				endpoint->bEndpointAddress;
 			DEBUG("ft1000_probe: out: %d\n",
 			      endpoint->bEndpointAddress);
 		}
@@ -172,7 +172,7 @@ static int ft1000_probe(struct usb_interface *interface,
 
 	gPollingfailed = false;
 	ft1000dev->pPollThread =
-	    kthread_run(ft1000_poll_thread, ft1000dev, "ft1000_poll");
+		kthread_run(ft1000_poll_thread, ft1000dev, "ft1000_poll");
 
 	if (IS_ERR(ft1000dev->pPollThread)) {
 		ret = PTR_ERR(ft1000dev->pPollThread);
@@ -218,7 +218,7 @@ static void ft1000_disconnect(struct usb_interface *interface)
 
 	DEBUG("ft1000_disconnect is called\n");
 
-	pft1000info = (struct ft1000_info *) usb_get_intfdata(interface);
+	pft1000info = (struct ft1000_info *)usb_get_intfdata(interface);
 	DEBUG("In disconnect pft1000info=%p\n", pft1000info);
 
 	if (pft1000info) {
@@ -233,7 +233,7 @@ static void ft1000_disconnect(struct usb_interface *interface)
 			ft1000_destroy_dev(ft1000dev->net);
 			unregister_netdev(ft1000dev->net);
 			DEBUG
-			    ("ft1000_disconnect: network device unregistered\n");
+				("ft1000_disconnect: network device unregistered\n");
 			free_netdev(ft1000dev->net);
 
 		}
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 8f7ccae..418e6df 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -137,7 +137,7 @@ extern spinlock_t free_buff_lock;
 int ft1000_create_dev(struct ft1000_usb *dev);
 void ft1000_destroy_dev(struct net_device *dev);
 extern int card_send_command(struct ft1000_usb *ft1000dev,
-			      void *ptempbuffer, int size);
+			     void *ptempbuffer, int size);
 
 struct dpram_blk *ft1000_get_buffer(struct list_head *bufflist);
 void ft1000_free_buffer(struct dpram_blk *pdpram_blk, struct list_head *plist);
-- 
2.1.2

