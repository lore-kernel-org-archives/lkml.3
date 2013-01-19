Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab3ASEJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 23:09:49 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:46509 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab3ASEJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 23:09:48 -0500
Date: Fri, 18 Jan 2013 23:09:56 -0500
From: Jake Champlin <jake.champlin.27@gmail.com>
To: gregkh@linuxfoundation.org
Cc: dan.magenheimer@oracle.com, sjenning@linux.vnet.ibm.com,
        konrad.wilk@oracle.com, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        jake.champlin.27@gmail.com
Subject: [PATCH] Staging: ramster: zcache-main: Fixed Bracing Issues
Message-ID: <20130119040950.GA18812@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed Coding Style Bracing Issues

Signed-off-by: Jake Champlin <jake.champlin.27@gmail.com>
---
 drivers/staging/ramster/zcache-main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ramster/zcache-main.c b/drivers/staging/ramster/zcache-main.c
index a09dd5c..2613889 100644
--- a/drivers/staging/ramster/zcache-main.c
+++ b/drivers/staging/ramster/zcache-main.c
@@ -478,6 +478,7 @@ static void zcache_free_page(struct page *page)
 #ifdef ZCACHE_DEBUG
 	if (curr_pageframes > 2L || curr_pageframes < -2L) {
 		/* pr_info here */
+		/* unnecessary comment */
 	}
 #endif
 }
@@ -1017,11 +1018,10 @@ static int zcache_frontswap_unuse(void)
 		unuse_ret = frontswap_unuse(type, offset,
 				newpage2 != NULL ? newpage2 : evictpage2,
 				ZCACHE_GFP_MASK);
-		if (unuse_ret != 0) {
+		if (unuse_ret != 0)
 			goto free_and_out;
-		} else if (evictpage2 != NULL) {
+		else if (evictpage2 != NULL)
 			zcache_unacct_page();
-		}
 	}
 	ret = 0;
 	goto out;
-- 
1.8.1.1


-- 
Jake Champlin
jake.champlin.27@gmail.com
8123742937
<MuttClient>
