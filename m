Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbaINQkd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 12:40:33 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:64002 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359AbaINQkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 12:40:32 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhwOALvDFVRbsGnM/2dsb2JhbABggw2zSAEBAQEBAQUBbwGdfIEFF3iEYCOBGoh5AakMjxqFfIlRHYQ1BZ0IjDCJD4NgO4J5AQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: airlied@linux.ie, Fabian Frederick <fabf@skynet.be>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 0/9 linux-next] drivers/gpu/drm: use container_of where possible
Date: Sun, 14 Sep 2014 18:40:13 +0200
Message-Id: <1410712823-29137-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small patchset using container_of instead of casting on first structure member address.

Fabian Frederick (9):
  drm/cirrus: use container_of to resolve cirrus_fbdev from
    drm_fb_helper
  drm/mgag200: use container_of to resolve mga_fbdev from drm_fb_helper
  drm/radeon: use container_of to resolve radeon_fbdev from
    drm_fb_helper
  drm/nouveau: use container_of to resolve nouveau_fbdev from
    drm_fb_helper
  drm/nouveau: use container_of to resolve nouveau_plane from drm_plane
  drm/qxl: use container_of to resolve qxl_fbdev from drm_fb_helper
  drm/gma500: use container_of to resolve psb_fbdev from drm_fb_helper
  drm/ast: use container_of to resolve ast_fbdev from drm_fb_helper
  drm/udl: use container_of to resolve udl_fbdev from drm_fb_helper

 drivers/gpu/drm/ast/ast_fb.c               |  3 ++-
 drivers/gpu/drm/cirrus/cirrus_fbdev.c      |  3 ++-
 drivers/gpu/drm/gma500/framebuffer.c       |  3 ++-
 drivers/gpu/drm/mgag200/mgag200_fb.c       |  3 ++-
 drivers/gpu/drm/nouveau/dispnv04/overlay.c | 15 ++++++++++-----
 drivers/gpu/drm/nouveau/nouveau_fbcon.c    |  3 ++-
 drivers/gpu/drm/qxl/qxl_fb.c               |  3 ++-
 drivers/gpu/drm/radeon/radeon_fb.c         |  3 ++-
 drivers/gpu/drm/udl/udl_fb.c               |  3 ++-
 9 files changed, 26 insertions(+), 13 deletions(-)

-- 
1.9.1

