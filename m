Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbaBDTBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:01:04 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:41675 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbaBDTBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:01:00 -0500
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>,
        Jani Nikula <jani.nikula@linux.intel.com>
Subject: [PATCH] MAINTAINERS: Update drm/i915 git repo
Date: Tue,  4 Feb 2014 20:00:51 +0100
Message-Id: <1391540451-24169-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moved to a common location so that Jani also can push to it, to avoid
moving it every time I go on vacation. Please update autobuilders and
everything else pointing at the drm-intel.git repo, the old one won't
be updated any more.

Cc: Dave Airlie <airlied@gmail.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 31a046213274..e3aaf277cf58 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2832,7 +2832,7 @@ M:	Jani Nikula <jani.nikula@linux.intel.com>
 L:	intel-gfx@lists.freedesktop.org
 L:	dri-devel@lists.freedesktop.org
 Q:	http://patchwork.freedesktop.org/project/intel-gfx/
-T:	git git://people.freedesktop.org/~danvet/drm-intel
+T:	git git://anongit.freedesktop.org/drm-intel
 S:	Supported
 F:	drivers/gpu/drm/i915/
 F:	include/drm/i915*
-- 
1.8.5.2

