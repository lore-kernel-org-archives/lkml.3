Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab3IQV0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 17:26:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab3IQV0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 17:26:43 -0400
Date: Tue, 17 Sep 2013 17:26:34 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: bskeggs@redhat.com, airlied@redhat.com
Subject: nouveau: remove pointless assignment
Message-ID: <20130917212634.GA31390@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, bskeggs@redhat.com,
	airlied@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

self-assignment of a variable doesn't make a lot of sense.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 755c38d..d0a737c 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -982,7 +982,7 @@ nouveau_bo_move_m2mf(struct ttm_buffer_object *bo, int evict, bool intr,
 		     bool no_wait_gpu, struct ttm_mem_reg *new_mem)
 {
 	struct nouveau_drm *drm = nouveau_bdev(bo->bdev);
-	struct nouveau_channel *chan = chan = drm->ttm.chan;
+	struct nouveau_channel *chan = drm->ttm.chan;
 	struct nouveau_bo *nvbo = nouveau_bo(bo);
 	struct ttm_mem_reg *old_mem = &bo->mem;
 	int ret;
