Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbaHVOLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:11:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34385 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932112AbaHVOLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:11:42 -0400
From: Dan Murphy <dmurphy@ti.com>
To: <linux-input@vger.kernel.org>, <dmitry.torokhov@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH] input: misc: drv260x remove defines not used
Date: Fri, 22 Aug 2014 09:11:15 -0500
Message-ID: <1408716675-1093-1-git-send-email-dmurphy@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing some #defines that are not and should
never be used pertaining to I2C.

Removing:
define DRV260X_ALLOWED_R_BYTES	25
define DRV260X_ALLOWED_W_BYTES	2
define DRV260X_MAX_RW_RETRIES	5
define DRV260X_I2C_RETRY_DELAY 10

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/input/misc/drv260x.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/input/misc/drv260x.c b/drivers/input/misc/drv260x.c
index e90e3b8..a7a19e6 100644
--- a/drivers/input/misc/drv260x.c
+++ b/drivers/input/misc/drv260x.c
@@ -66,11 +66,6 @@
 #define DRV260X_LRA_RES_PERIOD	0x22
 #define DRV260X_MAX_REG			0x23
 
-#define DRV260X_ALLOWED_R_BYTES	25
-#define DRV260X_ALLOWED_W_BYTES	2
-#define DRV260X_MAX_RW_RETRIES	5
-#define DRV260X_I2C_RETRY_DELAY 10
-
 #define DRV260X_GO_BIT				0x01
 
 /* Library Selection */
-- 
1.7.9.5

