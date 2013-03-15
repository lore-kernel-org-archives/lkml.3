Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab3COPUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:20:40 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47928 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab3COPUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:20:37 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: airlied@linux.ie
Cc: bskeggs@redhat.com, marcin.slusarz@gmail.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] nouveau: nv10_fence.c: avoid sparse warning
Date: Fri, 15 Mar 2013 16:18:48 +0100
Message-Id: <1363360728-20158-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix this warning :
sparse: symbol 'nv10_fence_context_new' was not declared. Should it be static?

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/gpu/drm/nouveau/nouveau_fence.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_fence.h b/drivers/gpu/drm/nouveau/nouveau_fence.h
index c899434..61ee43a 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fence.h
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.h
@@ -64,6 +64,7 @@ int  nv17_fence_sync(struct nouveau_fence *, struct nouveau_channel *,
 		     struct nouveau_channel *);
 u32  nv10_fence_read(struct nouveau_channel *);
 void nv10_fence_context_del(struct nouveau_channel *);
+int  nv10_fence_context_new(struct nouveau_channel *);
 void nv10_fence_destroy(struct nouveau_drm *);
 int  nv10_fence_create(struct nouveau_drm *);
 
-- 
1.7.10.4

