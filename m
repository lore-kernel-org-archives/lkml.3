Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbbA2BHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:07:35 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33506 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbbA2BH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:07:28 -0500
Date: Wed, 28 Jan 2015 13:24:38 +0200
From: Heba Aamer <heba93aamer@gmail.com>
To: devel@driverdev.osuosl.org
Cc: thomas.petazzoni@free-electrons.com, noralf@tronnes.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] staging: fbtft: fix horizontal spaces errors
Message-ID: <01176f954f21c75004f68e529d13fdf87fae9b93.1422443132.git.heba93aamer@gmail.com>
References: <cover.1422443132.git.heba93aamer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1422443132.git.heba93aamer@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl errors:
spaces required around that '='
space required after that ';'
spaces required around that '<'

Signed-off-by: Heba Aamer <heba93aamer@gmail.com>
---
 drivers/staging/fbtft/fb_pcd8544.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/fbtft/fb_pcd8544.c b/drivers/staging/fbtft/fb_pcd8544.c
index d0e5892..0510547 100644
--- a/drivers/staging/fbtft/fb_pcd8544.c
+++ b/drivers/staging/fbtft/fb_pcd8544.c
@@ -117,10 +117,10 @@ static int write_vmem(struct fbtft_par *par, size_t offset, size_t len)
 
 	fbtft_par_dbg(DEBUG_WRITE_VMEM, par, "%s()\n", __func__);
 
-	for (x=0;x<84;x++) {
-		for (y=0;y<6;y++) {
+	for (x = 0; x < 84; x++) {
+		for (y = 0; y < 6; y++) {
 			*buf = 0x00;
-			for (i=0;i<8;i++) {
+			for (i = 0; i < 8; i++) {
 				*buf |= (vmem16[(y*8+i)*84+x] ? 1 : 0) << i;
 			}
 			buf++;
-- 
1.7.9.5

