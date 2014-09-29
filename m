Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbaI2Igb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 04:36:31 -0400
Received: from nasmtp02.atmel.com ([204.2.163.16]:7741 "EHLO
	SJOEDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751770AbaI2Ig3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 04:36:29 -0400
From: Josh Wu <josh.wu@atmel.com>
To: <computersforpeace@gmail.com>, <akpm@linux-foundation.org>,
        <nicolas.ferre@atmel.com>
CC: <linux-mtd@lists.infradead.org>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Josh Wu <josh.wu@atmel.com>
Subject: [PATCH] MAINTAINERS: add atmel nand driver maintainer entry
Date: Mon, 29 Sep 2014 16:36:03 +0800
Message-ID: <1411979763-1449-1-git-send-email-josh.wu@atmel.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an entry in MAINTAINERS file for ATMEL nand driver.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3705430..1bdf3bf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1698,6 +1698,12 @@ M:	Nicolas Ferre <nicolas.ferre@atmel.com>
 S:	Supported
 F:	drivers/net/ethernet/cadence/
 
+ATMEL NAND DRIVER
+M:	Josh Wu <josh.wu@atmel.com>
+L:	linux-mtd@lists.infradead.org
+S:	Supported
+F:	drivers/mtd/nand/atmel_nand*
+
 ATMEL SPI DRIVER
 M:	Nicolas Ferre <nicolas.ferre@atmel.com>
 S:	Supported
-- 
1.9.1

