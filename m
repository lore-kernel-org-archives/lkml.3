Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab3AXK6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:58:55 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:33843 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab3AXKzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:55:54 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v3 69/71] ARC: [plat-arcfpga] defconfig for fully loaded ARC Linux
Date: Thu, 24 Jan 2013 16:20:38 +0530
Message-ID: <1359024639-21915-25-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/configs/fpga_defconfig |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/arc/configs/fpga_defconfig b/arch/arc/configs/fpga_defconfig
index 8638e101f..b869806 100644
--- a/arch/arc/configs/fpga_defconfig
+++ b/arch/arc/configs/fpga_defconfig
@@ -10,16 +10,29 @@ CONFIG_NAMESPACES=y
 # CONFIG_PID_NS is not set
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE="../arc_initramfs"
-CONFIG_EXPERT=y
-# CONFIG_FUTEX is not set
+CONFIG_KALLSYMS_ALL=y
+CONFIG_EMBEDDED=y
+# CONFIG_SLUB_DEBUG is not set
 # CONFIG_COMPAT_BRK is not set
+CONFIG_KPROBES=y
+CONFIG_MODULES=y
 # CONFIG_LBDAF is not set
 # CONFIG_BLK_DEV_BSG is not set
 # CONFIG_IOSCHED_DEADLINE is not set
 # CONFIG_IOSCHED_CFQ is not set
+CONFIG_ARC_PLAT_FPGA_LEGACY=y
+CONFIG_ARC_BOARD_ML509=y
+# CONFIG_ARC_HAS_RTSC is not set
 CONFIG_ARC_BUILTIN_DTB_NAME="angel4"
 # CONFIG_COMPACTION is not set
 # CONFIG_CROSS_MEMORY_ATTACH is not set
+CONFIG_NET=y
+CONFIG_PACKET=y
+CONFIG_UNIX=y
+CONFIG_UNIX_DIAG=y
+CONFIG_NET_KEY=y
+CONFIG_INET=y
+# CONFIG_IPV6 is not set
 # CONFIG_STANDALONE is not set
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 # CONFIG_FIRMWARE_IN_KERNEL is not set
@@ -38,9 +51,11 @@ CONFIG_SERIAL_ARC_CONSOLE=y
 # CONFIG_HID is not set
 # CONFIG_USB_SUPPORT is not set
 # CONFIG_IOMMU_SUPPORT is not set
-# CONFIG_DNOTIFY is not set
-# CONFIG_INOTIFY_USER is not set
+CONFIG_EXT2_FS=y
+CONFIG_EXT2_FS_XATTR=y
+CONFIG_TMPFS=y
 # CONFIG_MISC_FILESYSTEMS is not set
+CONFIG_NFS_FS=y
 # CONFIG_ENABLE_WARN_DEPRECATED is not set
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_XZ_DEC=y
-- 
1.7.4.1

