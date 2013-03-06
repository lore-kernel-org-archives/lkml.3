Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab3CFUfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 15:35:36 -0500
Received: from smtp.outflux.net ([198.145.64.163]:54341 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265Ab3CFUff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 15:35:35 -0500
Date: Wed, 6 Mar 2013 12:35:31 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] final removal of CONFIG_EXPERIMENTAL
Message-ID: <20130306203531.GA22371@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove "config EXPERIMENTAL" itself, now that every "depends on" it has
been removed from the tree.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/Kconfig |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 22616cd..5341d72 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -28,10 +28,6 @@ config BUILDTIME_EXTABLE_SORT
 
 menu "General setup"
 
-config EXPERIMENTAL
-	bool
-	default y
-
 config BROKEN
 	bool
 
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
