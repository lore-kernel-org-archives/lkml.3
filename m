Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab3C0HYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 03:24:08 -0400
Received: from intranet.asianux.com ([58.214.24.6]:38437 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab3C0HYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 03:24:06 -0400
X-Spam-Score: -100.8
Message-ID: <51529E77.2010906@asianux.com>
Date: Wed, 27 Mar 2013 15:23:35 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: airlied@linux.ie, bskeggs@redhat.com, airlied@redhat.com
CC: dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/gpu/drm/nouveau: remove erroneous semicolon
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  need remove semicolon, or always return true.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 drivers/gpu/drm/nouveau/nv50_display.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nv50_display.c b/drivers/gpu/drm/nouveau/nv50_display.c
index 7f0e6c3..1ddc03e 100644
--- a/drivers/gpu/drm/nouveau/nv50_display.c
+++ b/drivers/gpu/drm/nouveau/nv50_display.c
@@ -479,7 +479,7 @@ nv50_display_flip_wait(void *data)
 {
 	struct nv50_display_flip *flip = data;
 	if (nouveau_bo_rd32(flip->disp->sync, flip->chan->addr / 4) ==
-					      flip->chan->data);
+					      flip->chan->data)
 		return true;
 	usleep_range(1, 2);
 	return false;
-- 
1.7.7.6
