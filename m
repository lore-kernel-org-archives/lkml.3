Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab3BWHgU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 02:36:20 -0500
Received: from smtp.outflux.net ([198.145.64.163]:45945 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab3BWHgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 02:36:19 -0500
Date: Fri, 22 Feb 2013 23:36:14 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Kees Cook <keescook@chromium.org>, kvm@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] drivers/vfio: remove depends on CONFIG_EXPERIMENTAL
Message-ID: <20130223073614.GA5108@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index e84300b..c41b01e 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -9,7 +9,7 @@ config VFIO_PCI
 
 config VFIO_PCI_VGA
 	bool "VFIO PCI support for VGA devices"
-	depends on VFIO_PCI && X86 && VGA_ARB && EXPERIMENTAL
+	depends on VFIO_PCI && X86 && VGA_ARB
 	help
 	  Support for VGA extension to VFIO PCI.  This exposes an additional
 	  region on VGA devices for accessing legacy VGA addresses used by
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
