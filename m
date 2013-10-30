Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab3J3Fe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 01:34:27 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:38258 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab3J3FeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 01:34:23 -0400
MIME-Version: 1.0
Date: Wed, 30 Oct 2013 13:34:22 +0800
Message-ID: <CAPgLHd8=fLjqnKEoTB2C+7R=Nz7bdV0D5ttO29em=P8nX-Tvag@mail.gmail.com>
Subject: [PATCH -next] mtd: remove duplicated include from mtdcore.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: dwmw2@infradead.org
Cc: yongjun_wei@trendmicro.com.cn, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/mtd/mtdcore.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 7189089..92311a5 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -37,7 +37,6 @@
 #include <linux/backing-dev.h>
 #include <linux/gfp.h>
 #include <linux/slab.h>
-#include <linux/major.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>

