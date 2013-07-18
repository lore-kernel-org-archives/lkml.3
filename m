Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933634Ab3GRW5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 18:57:05 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:53503 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758908Ab3GRW5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 18:57:04 -0400
From: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
To: akpm@linux-foundation.org
Cc: <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
Subject: [PATCH] genalloc: correct dev_get_gen_pool documentation
Date: Thu, 18 Jul 2013 19:55:52 -0300
Message-Id: <1374188152-5622-1-git-send-email-emilio@elopez.com.ar>
X-Mailer: git-send-email 1.8.3.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation mentions a "name" parameter, which does not exist.
This commit removes such mention from the function documentation.

Signed-off-by: Emilio López <emilio@elopez.com.ar>
---
 lib/genalloc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/genalloc.c b/lib/genalloc.c
index b35cfa9..1d1f82b 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -519,7 +519,6 @@ struct gen_pool *devm_gen_pool_create(struct device *dev, int min_alloc_order,
 /**
  * dev_get_gen_pool - Obtain the gen_pool (if any) for a device
  * @dev: device to retrieve the gen_pool from
- * @name: Optional name for the gen_pool, usually NULL
  *
  * Returns the gen_pool for the device if one is present, or NULL.
  */
-- 
1.8.3.3

