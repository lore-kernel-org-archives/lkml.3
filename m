Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab3COP53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:57:29 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:41940 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab3COP51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:57:27 -0400
From: <ludovic.desroches@atmel.com>
To: <linux-i2c@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <wsa@the-dreams.de>, <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [PATCH] MAINTAINERS: add maintainer entry for atmel i2c driver
Date: Fri, 15 Mar 2013 16:32:57 +0100
Message-ID: <1363361577-7770-1-git-send-email-ludovic.desroches@atmel.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ludovic Desroches <ludovic.desroches@atmel.com>

Create an entry for atmel i2c driver: i2c-at91.c

Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
---
Hello,

If there are no objections, I'll take the maintenance of the at91 i2c driver
since there is no maintainer.

Wolfram, can you take this patch or do I have to ask someone else?

Regards

Ludovic


 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9561658..d667ecc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1467,6 +1467,12 @@ F:	drivers/dma/at_hdmac.c
 F:	drivers/dma/at_hdmac_regs.h
 F:	include/linux/platform_data/dma-atmel.h
 
+ATMEL I2C DRIVER
+M:	Ludovic Desroches <ludovic.desroches@atmel.com>
+L:	linux-i2c@vger.kernel.org
+S:	Supported
+F:	drivers/i2c/busses/i2c-at91.c
+
 ATMEL ISI DRIVER
 M:	Josh Wu <josh.wu@atmel.com>
 L:	linux-media@vger.kernel.org
-- 
1.7.11.3

