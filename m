Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017AbbA1U1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:27:40 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:41988 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524AbbA1U1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:27:38 -0500
Date: Wed, 28 Jan 2015 13:28:20 +0200
From: Heba Aamer <heba93aamer@gmail.com>
To: devel@driverdev.osuosl.org
Cc: thomas.petazzoni@free-electrons.com, noralf@tronnes.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] staging: fbtft: fix braces {} are not necessary for
 single statement blocks
Message-ID: <ac3f5a3e1f4f1fcce1d8ee9d53f5a7638953ec52.1422443132.git.heba93aamer@gmail.com>
References: <cover.1422443132.git.heba93aamer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1422443132.git.heba93aamer@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl warning:
braces {} are not necessary for single statement blocks

Signed-off-by: Heba Aamer <heba93aamer@gmail.com>
---
 drivers/staging/fbtft/fb_pcd8544.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/fbtft/fb_pcd8544.c b/drivers/staging/fbtft/fb_pcd8544.c
index 8b9ebfb..5e08a70 100644
--- a/drivers/staging/fbtft/fb_pcd8544.c
+++ b/drivers/staging/fbtft/fb_pcd8544.c
@@ -120,9 +120,8 @@ static int write_vmem(struct fbtft_par *par, size_t offset, size_t len)
 	for (x = 0; x < 84; x++) {
 		for (y = 0; y < 6; y++) {
 			*buf = 0x00;
-			for (i = 0; i < 8; i++) {
+			for (i = 0; i < 8; i++)
 				*buf |= (vmem16[(y*8+i)*84+x] ? 1 : 0) << i;
-			}
 			buf++;
 		}
 	}
-- 
1.7.9.5

