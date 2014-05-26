Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbaEZVo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 17:44:56 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:55775 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaEZVov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 17:44:51 -0400
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: DRI Development <dri-devel@lists.freedesktop.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alex Williamson <alex.williamson@redhat.com>,
        Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Shovel drivers/gpu/vga/* to Dave
Date: Mon, 26 May 2014 23:44:42 +0200
Message-Id: <1401140682-453-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DRM is pretty much the main user of this stuff (if we ignore the sysfs
interface used by X, i.e. by the same gang of people writing the drm
drivers). So shovel it into Dave's responsibility to avoid patches
getting lost on lkml.

With this get_maintainers will rout vgaarb and switcheroo patches
correctly.

Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org
References: https://lkml.org/lkml/2014/5/25/94
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e67ea2442041..1f08b7e43dec 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2933,6 +2933,7 @@ L:	dri-devel@lists.freedesktop.org
 T:	git git://people.freedesktop.org/~airlied/linux
 S:	Maintained
 F:	drivers/gpu/drm/
+F:	drivers/gpu/vga/
 F:	include/drm/
 F:	include/uapi/drm/
 
-- 
1.9.2

