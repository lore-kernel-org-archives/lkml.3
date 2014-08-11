Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaHKVZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 17:25:18 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:39790 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbaHKVZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 17:25:12 -0400
From: Tina Johnson <tinajohnson.1234@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Tina Johnson <tinajohnson.1234@gmail.com>
Subject: [PATCH 1/2] Base: fix whitespace errors
Date: Tue, 12 Aug 2014 02:54:08 +0530
Message-Id: <1407792249-7333-2-git-send-email-tinajohnson.1234@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1407792249-7333-1-git-send-email-tinajohnson.1234@gmail.com>
References: <1407792249-7333-1-git-send-email-tinajohnson.1234@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a clean-up patch to the attribute_container.c file to fix
the whitespace errors.

Signed-off-by: Tina Johnson <tinajohnson.1234@gmail.com>
---
 drivers/base/attribute_container.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
index b84ca8f..5917cc3 100644
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -76,7 +76,7 @@ attribute_container_register(struct attribute_container *cont)
 	INIT_LIST_HEAD(&cont->node);
 	klist_init(&cont->containers,internal_container_klist_get,
 		   internal_container_klist_put);
-		
+
 	mutex_lock(&attribute_container_mutex);
 	list_add_tail(&cont->node, &attribute_container_list);
 	mutex_unlock(&attribute_container_mutex);
@@ -104,14 +104,14 @@ attribute_container_unregister(struct attribute_container *cont)
 	spin_unlock(&cont->containers.k_lock);
 	mutex_unlock(&attribute_container_mutex);
 	return retval;
-		
+
 }
 EXPORT_SYMBOL_GPL(attribute_container_unregister);
 
 /* private function used as class release */
 static void attribute_container_release(struct device *classdev)
 {
-	struct internal_container *ic 
+	struct internal_container *ic
 		= container_of(classdev, struct internal_container, classdev);
 	struct device *dev = classdev->parent;
 
@@ -185,7 +185,7 @@ attribute_container_add_device(struct device *dev,
 		n ? container_of(n, typeof(*pos), member) : \
 			({ klist_iter_exit(iter) ; NULL; }); \
 	}) ) != NULL; )
-			
+
 
 /**
  * attribute_container_remove_device - make device eligible for removal.
@@ -247,7 +247,7 @@ attribute_container_remove_device(struct device *dev,
  * container, then use attribute_container_trigger() instead.
  */
 void
-attribute_container_device_trigger(struct device *dev, 
+attribute_container_device_trigger(struct device *dev,
 				   int (*fn)(struct attribute_container *,
 					     struct device *,
 					     struct device *))
-- 
1.7.10.4

