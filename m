Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630Ab3BNDHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 22:07:14 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48001 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab3BNDFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 22:05:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        dan.magenheimer@oracle.com, gregkh@linuxfoundation.org
Cc: sjenning@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 10/16] zcache: Module license is defined twice.
Date: Wed, 13 Feb 2013 22:05:00 -0500
Message-Id: <1360811106-2679-11-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>
References: <1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The other (same license) is at the end of the file.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/staging/zcache/zcache-main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 059c0f2..4b9ee7f 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -73,8 +73,6 @@ static char *namestr __read_mostly = "zcache";
 #define ZCACHE_GFP_MASK \
 	(__GFP_FS | __GFP_NORETRY | __GFP_NOWARN | __GFP_NOMEMALLOC)
 
-MODULE_LICENSE("GPL");
-
 /* crypto API for zcache  */
 #define ZCACHE_COMP_NAME_SZ CRYPTO_MAX_ALG_NAME
 static char zcache_comp_name[ZCACHE_COMP_NAME_SZ] __read_mostly;
-- 
1.8.0.2

