Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837Ab3AQDIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 22:08:11 -0500
Received: from smtp.outflux.net ([198.145.64.163]:36551 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758704Ab3AQCyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:54:43 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 86/86] final removal of CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:54:18 -0800
Message-Id: <1358391258-1771-87-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358391258-1771-1-git-send-email-keescook@chromium.org>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove CONFIG_EXPERIMENTAL, now that every mention of it has been removed
from the tree.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 init/Kconfig |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index a966690..fb9f55b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -32,10 +32,6 @@ config BUILDTIME_EXTABLE_SORT
 
 menu "General setup"
 
-config EXPERIMENTAL
-	bool
-	default y
-
 config BROKEN
 	bool
 
-- 
1.7.9.5

