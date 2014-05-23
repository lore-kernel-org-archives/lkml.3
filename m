Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbaEWD60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 23:58:26 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10912 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbaEWD6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 23:58:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 22 May 2014 20:52:09 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Dave Airlie <airlied@gmail.com>
CC: <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] drm/ttm: fix kerneldoc of ttm_bo_create
Date: Fri, 23 May 2014 12:58:06 +0900
Message-ID: <1400817487-27179-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kerneldoc header of ttm_bo_create() was referring to another
(nonexisting) function and had a few obsolete or incorrect arguments.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 include/drm/ttm/ttm_bo_api.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/drm/ttm/ttm_bo_api.h b/include/drm/ttm/ttm_bo_api.h
index ee127ec33c60..7526c5bf5610 100644
--- a/include/drm/ttm/ttm_bo_api.h
+++ b/include/drm/ttm/ttm_bo_api.h
@@ -485,13 +485,12 @@ extern int ttm_bo_init(struct ttm_bo_device *bdev,
 			void (*destroy) (struct ttm_buffer_object *));
 
 /**
- * ttm_bo_synccpu_object_init
+ * ttm_bo_create
  *
  * @bdev: Pointer to a ttm_bo_device struct.
- * @bo: Pointer to a ttm_buffer_object to be initialized.
  * @size: Requested size of buffer object.
  * @type: Requested type of buffer object.
- * @flags: Initial placement flags.
+ * @placement: Initial placement.
  * @page_alignment: Data alignment in pages.
  * @interruptible: If needing to sleep while waiting for GPU resources,
  * sleep interruptible.
-- 
1.9.2

