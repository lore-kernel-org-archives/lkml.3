Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054AbaIOWTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:19:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51138 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758190AbaIOWTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:19:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mario Kleiner <mario.kleiner.de@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 173/187] drm/nouveau: Bump version from 1.1.1 to 1.1.2
Date: Mon, 15 Sep 2014 15:09:43 -0700
Message-Id: <1410818997-9432-174-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Kleiner <mario.kleiner.de@gmail.com>

commit 7820e5eef0faa4a5e10834296680827f7ce78a89 upstream.

Linux 3.16 fixed multiple bugs in kms pageflip completion events
and timestamping, which were originally introduced in Linux 3.13.

These fixes have been backported to all stable kernels since 3.13.

However, the userspace nouveau-ddx needs to be aware if it is
running on a kernel on which these bugs are fixed, or not.

Bump the patchlevel of the drm driver version to signal this,
so backporting this patch to stable 3.13+ kernels will give the
ddx the required info.

Signed-off-by: Mario Kleiner <mario.kleiner.de@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/nouveau/nouveau_drm.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.h b/drivers/gpu/drm/nouveau/nouveau_drm.h
index 4b0fb6c..a6949ec 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.h
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.h
@@ -10,7 +10,7 @@
 
 #define DRIVER_MAJOR		1
 #define DRIVER_MINOR		1
-#define DRIVER_PATCHLEVEL	1
+#define DRIVER_PATCHLEVEL	2
 
 /*
  * 1.1.1:
@@ -21,6 +21,8 @@
  *        to control registers on the MPs to enable performance counters,
  *        and to control the warp error enable mask (OpenGL requires out of
  *        bounds access to local memory to be silently ignored / return 0).
+ * 1.1.2:
+ *      - fixes multiple bugs in flip completion events and timestamping
  */
 
 #include <core/client.h>
-- 
1.9.1

