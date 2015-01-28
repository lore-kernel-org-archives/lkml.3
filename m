Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbbA1VJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:09:53 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37633 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbbA1Uyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:54:32 -0500
Date: Wed, 28 Jan 2015 15:29:05 +0200
From: Heba Aamer <heba93aamer@gmail.com>
To: devel@driverdev.osuosl.org
Cc: thomas.petazzoni@free-electrons.com, noralf@tronnes.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: fbtft: remove redundant .owner
Message-ID: <20150128132905.GA11672@mohammed-Inspiron-3537>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following coccicheck warning:
No need to set .owner here. The core will do it. 

Signed-off-by: Heba Aamer <heba93aamer@gmail.com>
---
 drivers/staging/fbtft/flexfb.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/fbtft/flexfb.c b/drivers/staging/fbtft/flexfb.c
index 45574a0..3f21cd2 100644
--- a/drivers/staging/fbtft/flexfb.c
+++ b/drivers/staging/fbtft/flexfb.c
@@ -559,7 +559,6 @@ static const struct platform_device_id flexfb_platform_ids[] = {
 static struct platform_driver flexfb_platform_driver = {
 	.driver = {
 		.name   = DRVNAME,
-		.owner  = THIS_MODULE,
 	},
 	.id_table = flexfb_platform_ids,
 	.probe  = flexfb_probe_pdev,
-- 
1.7.9.5

