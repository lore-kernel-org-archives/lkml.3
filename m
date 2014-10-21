Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbaJUTOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 15:14:11 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48147 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbaJUTOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 15:14:09 -0400
From: Rob Ward <robert.ward114@googlemail.com>
X-Google-Original-From: Rob Ward <rob@rob-thinkpad>
Date: Tue, 21 Oct 2014 20:14:00 +0100 (BST)
To: joern@lazybastard.org, dwmw2@infradead.org, computersforpeace@gmail.com
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mtd: phram: fix asm/io.h include usage
Message-ID: <alpine.DEB.2.10.1410212010210.7838@rob-thinkpad>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ca36c5ca9adbe1d3c107e5ff22e8d0db5dddb1b9 Mon Sep 17 00:00:00 2001
From: Rob Ward <robert.ward114@googlemail.com>
Date: Tue, 21 Oct 2014 20:01:09 +0100
Subject: [PATCH] mtd: phram: fix asm/io.h include usage

Modify phram to include <linux/io.h> rather than <asm/io.h>

Signed-off-by: Rob Ward <robert.ward114@googlemail.com>
---
 drivers/mtd/devices/phram.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/phram.c b/drivers/mtd/devices/phram.c
index effd9a4..8b66e52 100644
--- a/drivers/mtd/devices/phram.c
+++ b/drivers/mtd/devices/phram.c
@@ -17,7 +17,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <asm/io.h>
+#include <linux/io.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
-- 
2.0.2

