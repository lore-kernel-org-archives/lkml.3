Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbaK2URg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 15:17:36 -0500
Received: from resqmta-ch2-04v.sys.comcast.net ([69.252.207.36]:56673 "EHLO
	resqmta-ch2-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537AbaK2URf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 15:17:35 -0500
From: Geoff Darst <geoffda@comcast.net>
To: marek.belisko@gmail.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Geoff Darst <geoffda@comcast.net>
Subject: [PATCH] staging: ft1000 : replace __attribute ((__packed__) with __packed
Date: Sat, 29 Nov 2014 13:17:22 -0700
Message-Id: <1417292242-10483-1-git-send-email-geoffda@comcast.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace two instances of __attribute ((__packed__) with __packed macro
to address the warning found by the checkpatch.pl tool.

Signed-off-by: Geoff Darst <geoffda@comcast.net>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
index c1856f7..df1cf0c 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
@@ -99,7 +99,7 @@ struct dsp_file_hdr {
 	u32  version_data_offset;	/* Offset were scrambled version data begins. */
 	u32  version_data_size;	/* Size, in words, of scrambled version data. */
 	u32  nDspImages;	/* Number of DSP images in file. */
-} __attribute__ ((packed));
+} __packed;
 
 struct dsp_image_info {
 	u32  coff_date;		/* Date/time when DSP Coff image was built. */
@@ -110,7 +110,7 @@ struct dsp_image_info {
 	u32  version;		/* Embedded version # of DSP code. */
 	unsigned short checksum;	/* Dsp File checksum */
 	unsigned short pad1;
-} __attribute__ ((packed));
+} __packed;
 
 void card_bootload(struct net_device *dev)
 {
-- 
1.9.3

