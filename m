Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbaHHLGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 07:06:39 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:36248 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187AbaHHLGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 07:06:35 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dma-buf/fence: Fix one more kerneldoc warning
Date: Fri,  8 Aug 2014 13:06:30 +0200
Message-Id: <1407495990-19475-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The seqno_fence_init() function's cond argument isn't described in the
kerneldoc comment. Fix that to silence a warning when building DocBook
documentation.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 include/linux/seqno-fence.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/seqno-fence.h b/include/linux/seqno-fence.h
index 3d6003de4b0d..a1ba6a5ccdd6 100644
--- a/include/linux/seqno-fence.h
+++ b/include/linux/seqno-fence.h
@@ -62,6 +62,7 @@ to_seqno_fence(struct fence *fence)
  * @context: the execution context this fence is a part of
  * @seqno_ofs: the offset within @sync_buf
  * @seqno: the sequence # to signal on
+ * @cond: fence wait condition
  * @ops: the fence_ops for operations on this seqno fence
  *
  * This function initializes a struct seqno_fence with passed parameters,
-- 
2.0.4

