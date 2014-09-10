Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaIJGEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 02:04:53 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:58207 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaIJGEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 02:04:51 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 4/4] staging: comedi: hwdrv_apci3120: remove void function return statement
Date: Wed, 10 Sep 2014 01:04:42 -0500
Message-Id: <16a22373d901c65ee8a68f82788ca420e99141fc.1409983606.git.chase.southwood@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1409983606.git.chase.southwood@gmail.com>
References: <cover.1409983606.git.chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Returns at the end of void functions are useless.  Remove this one.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
index 470c866..2148ff4 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
@@ -1598,8 +1598,6 @@ static void apci3120_interrupt(int irq, void *d)
 		}
 
 	}
-
-	return;
 }
 
 /*
-- 
2.1.0

