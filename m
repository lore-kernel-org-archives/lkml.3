Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaIJGEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 02:04:23 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:63511 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaIJGEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 02:04:22 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 2/4] staging: comedi: hwdrv_apci3120: add a blank line after declarations
Date: Wed, 10 Sep 2014 01:04:10 -0500
Message-Id: <edb5bd005496d86da174ea3498af0712ee583937.1409983606.git.chase.southwood@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1409983606.git.chase.southwood@gmail.com>
References: <cover.1409983606.git.chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
index bdb527f..d776a0c 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
@@ -1008,6 +1008,7 @@ static int apci3120_cyclic_ai(int mode,
 	} else {
 		/* If DMA Enabled */
 		unsigned int scan_bytes = cmd->scan_end_arg * sizeof(short);
+
 		devpriv->b_InterruptMode = APCI3120_DMA_MODE;
 
 		/* Disables the EOC, EOS interrupt  */
-- 
2.1.0

