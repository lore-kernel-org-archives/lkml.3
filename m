Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbaHKVZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 17:25:22 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35915 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbaHKVZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 17:25:19 -0400
From: Tina Johnson <tinajohnson.1234@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Tina Johnson <tinajohnson.1234@gmail.com>
Subject: [PATCH 2/2] Base: fix coding style issues
Date: Tue, 12 Aug 2014 02:54:09 +0530
Message-Id: <1407792249-7333-3-git-send-email-tinajohnson.1234@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1407792249-7333-1-git-send-email-tinajohnson.1234@gmail.com>
References: <1407792249-7333-1-git-send-email-tinajohnson.1234@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl issues with coding style. Added and removed spaces
accordingly.

Signed-off-by: Tina Johnson <tinajohnson.1234@gmail.com>
---
 drivers/base/attribute_container.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
index 5917cc3..3ead3af 100644
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -74,7 +74,7 @@ int
 attribute_container_register(struct attribute_container *cont)
 {
 	INIT_LIST_HEAD(&cont->node);
-	klist_init(&cont->containers,internal_container_klist_get,
+	klist_init(&cont->containers, internal_container_klist_get,
 		   internal_container_klist_put);
 
 	mutex_lock(&attribute_container_mutex);
@@ -184,7 +184,7 @@ attribute_container_add_device(struct device *dev,
 		struct klist_node *n = klist_next(iter); \
 		n ? container_of(n, typeof(*pos), member) : \
 			({ klist_iter_exit(iter) ; NULL; }); \
-	}) ) != NULL; )
+	})) != NULL;)
 
 
 /**
-- 
1.7.10.4

