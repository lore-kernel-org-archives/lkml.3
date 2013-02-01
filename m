Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab3BAUax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 15:30:53 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:37237 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125Ab3BAUar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 15:30:47 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: dan.magenheimer@oracle.com, konrad.wilk@oracle.com,
        sjenning@linux.vnet.ibm.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, ngupta@vflare.org, rcj@linux.vnet.ibm.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 15/15] xen/tmem: Add missing %s in the printk statement.
Date: Fri,  1 Feb 2013 15:23:04 -0500
Message-Id: <1359750184-23408-16-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1359750184-23408-1-git-send-email-konrad.wilk@oracle.com>
References: <1359750184-23408-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems that it got lost.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/tmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/tmem.c b/drivers/xen/tmem.c
index 2f939e5..4f3ff99 100644
--- a/drivers/xen/tmem.c
+++ b/drivers/xen/tmem.c
@@ -401,7 +401,7 @@ static int xen_tmem_init(void)
 			s = " (WARNING: frontswap_ops overridden)";
 		}
 		printk(KERN_INFO "frontswap enabled, RAM provided by "
-				 "Xen Transcendent Memory\n");
+				 "Xen Transcendent Memory%s\n", s);
 	}
 #endif
 #ifdef CONFIG_CLEANCACHE
-- 
1.7.11.7

