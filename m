Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759058Ab3AQCzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:55:20 -0500
Received: from smtp.outflux.net ([198.145.64.163]:50313 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759039Ab3AQCzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:55:18 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 57/86] drivers/platform/x86: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:53:49 -0800
Message-Id: <1358391258-1771-58-git-send-email-keescook@chromium.org>
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

CC: Matthew Garrett <mjg@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/platform/x86/Kconfig |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index c86bae8..7ab0b2f 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -80,10 +80,9 @@ config ASUS_LAPTOP
 	  If you have an ACPI-compatible ASUS laptop, say Y or M here.
 
 config DELL_LAPTOP
-	tristate "Dell Laptop Extras (EXPERIMENTAL)"
+	tristate "Dell Laptop Extras"
 	depends on X86
 	depends on DCDBAS
-	depends on EXPERIMENTAL
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on RFKILL || RFKILL = n
 	depends on SERIO_I8042
@@ -171,9 +170,8 @@ config AMILO_RFKILL
 	  laptops.
 
 config TC1100_WMI
-	tristate "HP Compaq TC1100 Tablet WMI Extras (EXPERIMENTAL)"
+	tristate "HP Compaq TC1100 Tablet WMI Extras"
 	depends on !X86_64
-	depends on EXPERIMENTAL
 	depends on ACPI
 	depends on ACPI_WMI
 	---help---
-- 
1.7.9.5

