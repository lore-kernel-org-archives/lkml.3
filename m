Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab3LXNfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 08:35:14 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3917 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab3LXNex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 08:34:53 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 24 Dec 2013 05:36:32 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v2 6/6] misc: enable fuse drivers
Date: Tue, 24 Dec 2013 15:32:11 +0200
Message-ID: <1387891931-9854-7-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1387891931-9854-1-git-send-email-pdeschrijver@nvidia.com>
References: <1387891931-9854-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable building the fuse drivers.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/misc/Kconfig  |    1 +
 drivers/misc/Makefile |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 6cb388e..45560dc 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -526,4 +526,5 @@ source "drivers/misc/mei/Kconfig"
 source "drivers/misc/vmw_vmci/Kconfig"
 source "drivers/misc/mic/Kconfig"
 source "drivers/misc/genwqe/Kconfig"
+source "drivers/misc/fuse/Kconfig"
 endmenu
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 99b9424..e243a8b 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -54,3 +54,4 @@ obj-$(CONFIG_LATTICE_ECP3_CONFIG)	+= lattice-ecp3-config.o
 obj-$(CONFIG_SRAM)		+= sram.o
 obj-y				+= mic/
 obj-$(CONFIG_GENWQE)		+= genwqe/
+obj-y				+= fuse/
-- 
1.7.7.rc0.72.g4b5ea.dirty

