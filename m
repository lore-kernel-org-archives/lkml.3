Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351AbaK2C62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 21:58:28 -0500
Received: from resqmta-ch2-07v.sys.comcast.net ([69.252.207.39]:39203 "EHLO
	resqmta-ch2-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751035AbaK2C61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 21:58:27 -0500
X-Greylist: delayed 493 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Nov 2014 21:58:27 EST
From: Geoff Darst <geoffda@comcast.net>
To: marek.belisko@gmail.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Geoff Darst <geoffda@comcast.net>
Subject: [PATCH] Staging: ft1000 : ft1000-pcmcia: replace __attribute ((__packed__) with __packed macro per coding style guidelines in ft1000_dnld.c
Date: Fri, 28 Nov 2014 19:49:31 -0700
Message-Id: <1417229371-9243-1-git-send-email-geoffda@comcast.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace two instances of __attribute ((__packed__) with __packed macro to address the warning found by the checkpatch.pl tool.

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

