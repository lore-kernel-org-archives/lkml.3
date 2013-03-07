Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab3CGA3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:29:33 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:50984 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab3CGA3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:29:10 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Lucas Stach <dev@lynxeye.de>, Borislav Petkov <bp@alien8.de>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 2/3] MAINTAINERS: tegra: match related files using N: not K:
Date: Wed,  6 Mar 2013 17:29:00 -0700
Message-Id: <1362616141-13947-2-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362616141-13947-1-git-send-email-swarren@wwwdotorg.org>
References: <1362616141-13947-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

This causes the regex to be applied to filenames only, and not patch or
file content (such as comments). This should prevent e.g.
drivers/gpu/drm/nouveau/nv50_display.c from matching this entry.

Reported-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c9b1e37..2d02ab5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7851,7 +7851,7 @@ L:	linux-tegra@vger.kernel.org
 Q:	http://patchwork.ozlabs.org/project/linux-tegra/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git
 S:	Supported
-K:	(?i)[^a-z]tegra
+N:	[^a-z]tegra
 
 TEHUTI ETHERNET DRIVER
 M:	Andy Gospodarek <andy@greyhouse.net>
-- 
1.7.10.4

