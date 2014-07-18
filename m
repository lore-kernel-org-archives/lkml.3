Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762533AbaGRUN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 16:13:27 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42132 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762497AbaGRUNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 16:13:24 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Asadi <asadi.samuel@gmail.com>
Subject: [PATCH 2/2] Staging: comedi: adl_pci9118: line over 80 fixed
Date: Fri, 18 Jul 2014 23:13:08 +0300
Message-Id: <1405714388-13375-2-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405714388-13375-1-git-send-email-asadi.samuel@gmail.com>
References: <1405714388-13375-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A 'line over 80 characters' issue fixed.

Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>
---
 drivers/staging/comedi/drivers/adl_pci9118.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 7365f31..a715cd3 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -346,7 +346,7 @@ struct pci9118_private {
 						 * on external start
 						 */
 	unsigned short ao_data[2];		/* data output buffer */
-	char dma_doublebuf;			/* we can use double buffering */
+	char dma_doublebuf;			/* use double buffering */
 	unsigned int dma_actbuf;		/* which buffer is used now */
 	unsigned short *dmabuf_virt[2];		/*
 						 * pointers to begin of
-- 
1.7.10.4

