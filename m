Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbaHFRxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:53:12 -0400
Received: from mail-yk0-f194.google.com ([209.85.160.194]:52540 "EHLO
	mail-yk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbaHFRxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:53:11 -0400
From: Nick Krause <xerofoiffy@gmail.com>
To: Richard Weinberger <richard.weinberger@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        linux-spi@vger.kernel.org (open list:SPI SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/1] spi: Remove unused definitions
Date: Wed,  6 Aug 2014 13:53:17 -0400
Message-Id: <1407347597-2168-1-git-send-email-xerofoiffy@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused definition which cause the following warnings

drivers/spi/spi-omap-100k.c:73:0: warning: "WRITE" redefined [enabled by default]
include/linux/fs.h:193:0: note: this is the location of the previous definition
drivers/spi/spi-omap-100k.c:74:0: warning: "READ" redefined [enabled by default]
include/linux/fs.h:192:0: note: this is the location of the previous definition

Signed-off-by: Nick Krause <xerofoiffy@gmail.com>
---
 drivers/spi/spi-omap-100k.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/spi/spi-omap-100k.c b/drivers/spi/spi-omap-100k.c
index 5e91858..fb52276 100644
--- a/drivers/spi/spi-omap-100k.c
+++ b/drivers/spi/spi-omap-100k.c
@@ -70,10 +70,6 @@
 #define SPI_STATUS_WE                   (1UL << 1)
 #define SPI_STATUS_RD                   (1UL << 0)
 
-#define WRITE 0
-#define READ  1
-
-
 /* use PIO for small transfers, avoiding DMA setup/teardown overhead and
  * cache operations; better heuristics consider wordsize and bitrate.
  */
-- 
1.9.1

