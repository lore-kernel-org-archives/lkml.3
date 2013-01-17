Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984Ab3AQCzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:55:09 -0500
Received: from smtp.outflux.net ([198.145.64.163]:51704 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758938Ab3AQCzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:55:02 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 17/86] drivers/net/wireless/rt2x00: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:53:09 -0800
Message-Id: <1358391258-1771-18-git-send-email-keescook@chromium.org>
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

CC: Ivo van Doorn <IvDoorn@gmail.com>
CC: Gertjan van Wingerde <gwingerde@gmail.com>
CC: Helmut Schaa <helmut.schaa@googlemail.com>
CC: "John W. Linville" <linville@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/rt2x00/Kconfig |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index c7548da..44d6ead 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -82,7 +82,6 @@ config RT2800PCI_RT33XX
 
 config RT2800PCI_RT35XX
 	bool "rt2800pci - Include support for rt35xx devices (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	default y
 	---help---
 	  This adds support for rt35xx wireless chipset family to the
@@ -92,7 +91,6 @@ config RT2800PCI_RT35XX
 
 config RT2800PCI_RT53XX
        bool "rt2800pci - Include support for rt53xx devices (EXPERIMENTAL)"
-       depends on EXPERIMENTAL
        default y
        ---help---
          This adds support for rt53xx wireless chipset family to the
@@ -101,7 +99,6 @@ config RT2800PCI_RT53XX
 
 config RT2800PCI_RT3290
        bool "rt2800pci - Include support for rt3290 devices (EXPERIMENTAL)"
-       depends on EXPERIMENTAL
        default y
        ---help---
          This adds support for rt3290 wireless chipset family to the
@@ -159,7 +156,6 @@ config RT2800USB_RT33XX
 
 config RT2800USB_RT35XX
 	bool "rt2800usb - Include support for rt35xx devices (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	default y
 	---help---
 	  This adds support for rt35xx wireless chipset family to the
@@ -168,7 +164,6 @@ config RT2800USB_RT35XX
 
 config RT2800USB_RT53XX
        bool "rt2800usb - Include support for rt53xx devices (EXPERIMENTAL)"
-       depends on EXPERIMENTAL
        ---help---
          This adds support for rt53xx wireless chipset family to the
          rt2800usb driver.
-- 
1.7.9.5

