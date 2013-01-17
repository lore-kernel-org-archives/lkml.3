Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114Ab3AQCza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:55:30 -0500
Received: from smtp.outflux.net ([198.145.64.163]:46827 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759066Ab3AQCz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:55:28 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 62/86] drivers/scsi/device_handler: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:53:54 -0800
Message-Id: <1358391258-1771-63-git-send-email-keescook@chromium.org>
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

CC: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/device_handler/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/Kconfig b/drivers/scsi/device_handler/Kconfig
index 6707025..69abd0a 100644
--- a/drivers/scsi/device_handler/Kconfig
+++ b/drivers/scsi/device_handler/Kconfig
@@ -32,8 +32,8 @@ config SCSI_DH_EMC
 	If you have a EMC CLARiiON select y. Otherwise, say N.
 
 config SCSI_DH_ALUA
-	tristate "SPC-3 ALUA Device Handler (EXPERIMENTAL)"
-	depends on SCSI_DH && EXPERIMENTAL
+	tristate "SPC-3 ALUA Device Handler"
+	depends on SCSI_DH
 	help
 	  SCSI Device handler for generic SPC-3 Asymmetric Logical Unit
 	  Access (ALUA).
-- 
1.7.9.5

