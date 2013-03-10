Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab3CJNMS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 09:12:18 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:51528 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab3CJNMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 09:12:16 -0400
From: Ghennadi Procopciuc <ghennadi.procopciuc1@gmail.com>
To: airlied@linux.ie
Cc: airlied@redhat.com, paulmck@linux.vnet.ibm.com, unix140@gmail.com,
        dhowells@redhat.com, davej@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Ghennadi Procopciuc <ghennadi.procopciuc1@gmail.com>
Subject: [PATCH] gpu: make 'vmw_event_fence_action_create' static
Date: Sun, 10 Mar 2013 15:12:06 +0200
Message-Id: <1362921126-685-1-git-send-email-ghennadi.procopciuc1@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following checkpatch warning :
drivers/gpu/drm/vmwgfx/vmwgfx_fence.c:996:5: warning: symbol
'vmw_event_fence_action_create' was not declared. Should it be static?

Signed-off-by: Ghennadi Procopciuc <unix140@gmail.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
index c62d20e..e0846e6 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
@@ -952,7 +952,7 @@ void vmw_fence_obj_add_action(struct vmw_fence_obj *fence,
  * an error code, the caller needs to free that object.
  */
 
-int vmw_event_fence_action_queue(struct drm_file *file_priv,
+static int vmw_event_fence_action_queue(struct drm_file *file_priv,
 				 struct vmw_fence_obj *fence,
 				 struct drm_pending_event *event,
 				 uint32_t *tv_sec,
-- 
1.7.10.4

