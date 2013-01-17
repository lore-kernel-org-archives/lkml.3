Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242Ab3AQC6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:58:03 -0500
Received: from smtp.outflux.net ([198.145.64.163]:46429 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759062Ab3AQCzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:55:23 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Russell King <linux@arm.linux.org.uk>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 61/86] drivers/scsi/arm: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:53:53 -0800
Message-Id: <1358391258-1771-62-git-send-email-keescook@chromium.org>
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

CC: Russell King <linux@arm.linux.org.uk>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/arm/Kconfig |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/arm/Kconfig b/drivers/scsi/arm/Kconfig
index a8587f1..cfd172a 100644
--- a/drivers/scsi/arm/Kconfig
+++ b/drivers/scsi/arm/Kconfig
@@ -64,19 +64,19 @@ config SCSI_POWERTECSCSI
 	  you have one of these, say Y. If unsure, say N.
 
 comment "The following drivers are not fully supported"
-	depends on ARCH_ACORN && EXPERIMENTAL
+	depends on ARCH_ACORN
 
 config SCSI_CUMANA_1
-	tristate "CumanaSCSI I support (EXPERIMENTAL)"
-	depends on ARCH_ACORN && EXPERIMENTAL && SCSI
+	tristate "CumanaSCSI I support"
+	depends on ARCH_ACORN && SCSI
 	select SCSI_SPI_ATTRS
 	help
 	  This enables support for the Cumana SCSI I card. If you have an
 	  Acorn system with one of these, say Y. If unsure, say N.
 
 config SCSI_OAK1
-	tristate "Oak SCSI support (EXPERIMENTAL)"
-	depends on ARCH_ACORN && EXPERIMENTAL && SCSI
+	tristate "Oak SCSI support"
+	depends on ARCH_ACORN && SCSI
 	select SCSI_SPI_ATTRS
 	help
 	  This enables support for the Oak SCSI card. If you have an Acorn
-- 
1.7.9.5

