Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828Ab3AQCys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:54:48 -0500
Received: from smtp.outflux.net ([198.145.64.163]:37221 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758547Ab3AQCyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:54:38 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Dave Airlie <airlied@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 41/86] drivers/gpu/drm/ast: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:53:33 -0800
Message-Id: <1358391258-1771-42-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358391258-1771-1-git-send-email-keescook@chromium.org>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Dave Airlie <airlied@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/gpu/drm/ast/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ast/Kconfig b/drivers/gpu/drm/ast/Kconfig
index a277b12..da4a51e 100644
--- a/drivers/gpu/drm/ast/Kconfig
+++ b/drivers/gpu/drm/ast/Kconfig
@@ -1,6 +1,6 @@
 config DRM_AST
 	tristate "AST server chips"
-	depends on DRM && PCI && EXPERIMENTAL
+	depends on DRM && PCI
 	select DRM_TTM
 	select FB_SYS_COPYAREA
 	select FB_SYS_FILLRECT
-- 
1.7.9.5

