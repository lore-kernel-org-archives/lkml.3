Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040Ab3AQCzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:55:18 -0500
Received: from smtp.outflux.net ([198.145.64.163]:56545 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758883Ab3AQCzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:55:15 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Adam Belay <abelay@mit.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 58/86] drivers/pnp/pnpbios: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:53:50 -0800
Message-Id: <1358391258-1771-59-git-send-email-keescook@chromium.org>
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

CC: Adam Belay <abelay@mit.edu>
CC: Bjorn Helgaas <bhelgaas@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/pnp/pnpbios/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pnp/pnpbios/Kconfig b/drivers/pnp/pnpbios/Kconfig
index b986d9f..50c3dd0 100644
--- a/drivers/pnp/pnpbios/Kconfig
+++ b/drivers/pnp/pnpbios/Kconfig
@@ -2,8 +2,8 @@
 # Plug and Play BIOS configuration
 #
 config PNPBIOS
-	bool "Plug and Play BIOS support (EXPERIMENTAL)"
-	depends on ISA && X86 && EXPERIMENTAL
+	bool "Plug and Play BIOS support"
+	depends on ISA && X86
 	default n
 	---help---
 	  Linux uses the PNPBIOS as defined in "Plug and Play BIOS
-- 
1.7.9.5

