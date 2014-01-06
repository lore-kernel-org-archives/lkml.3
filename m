Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbaAFPSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:18:20 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:40075 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaAFPSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:18:18 -0500
Date: Mon, 6 Jan 2014 20:48:11 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 19/85] drivers: gpu: Include appropriate header file in
 overlay.c
Message-ID: <741198d65d3d0fe377f814164024f1462d424a6b.1389018324.git.rashika.kheria@gmail.com>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file drm/nouveau/dispnv04/disp.h in
drm/nouveau/dispnv04/overlay.c because function nouveau_overlay_init()
has its prototype declaration in the header file.

This eliminates the following warning in drm/nouveau/dispnv04/overlay.c:
drivers/gpu/drm/nouveau/dispnv04/overlay.c:335:1: warning: no previous prototype for ‘nouveau_overlay_init’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/nouveau/dispnv04/overlay.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/dispnv04/overlay.c b/drivers/gpu/drm/nouveau/dispnv04/overlay.c
index 32e7064..178044b 100644
--- a/drivers/gpu/drm/nouveau/dispnv04/overlay.c
+++ b/drivers/gpu/drm/nouveau/dispnv04/overlay.c
@@ -33,6 +33,7 @@
 #include "nouveau_connector.h"
 #include "nouveau_display.h"
 #include "nvreg.h"
+#include "disp.h"
 
 
 struct nouveau_plane {
-- 
1.7.9.5

