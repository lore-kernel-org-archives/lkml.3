Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857Ab3AQDFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 22:05:05 -0500
Received: from smtp.outflux.net ([198.145.64.163]:52970 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758792Ab3AQCyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:54:46 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 29/86] arch/parisc: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:53:21 -0800
Message-Id: <1358391258-1771-30-git-send-email-keescook@chromium.org>
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

CC: "James E.J. Bottomley" <jejb@parisc-linux.org>
CC: Helge Deller <deller@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/parisc/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index b77feff..416309b 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -194,12 +194,12 @@ config PARISC_PAGE_SIZE_4KB
 	  If you don't know what to do, choose 4KB.
 
 config PARISC_PAGE_SIZE_16KB
-	bool "16KB (EXPERIMENTAL)"
-	depends on PA8X00 && EXPERIMENTAL
+	bool "16KB"
+	depends on PA8X00
 
 config PARISC_PAGE_SIZE_64KB
-	bool "64KB (EXPERIMENTAL)"
-	depends on PA8X00 && EXPERIMENTAL
+	bool "64KB"
+	depends on PA8X00
 
 endchoice
 
-- 
1.7.9.5

