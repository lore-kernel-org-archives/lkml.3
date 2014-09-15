Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbaIOUm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:42:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55119 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573AbaIOTgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:36:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mario Kleiner <mario.kleiner.de@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 3.16 154/158] drm/nouveau: Bump version from 1.1.1 to 1.1.2
Date: Mon, 15 Sep 2014 12:26:33 -0700
Message-Id: <20140915192547.489482188@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_drm.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

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


