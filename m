Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab3ARMl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 07:41:28 -0500
Received: from hermes.synopsys.com ([198.182.44.81]:56095 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab3ARMlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 07:41:25 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v2 76/76] ARC: [plat-arcfpga] defconfig for fully loaded ARC Linux
Date: Fri, 18 Jan 2013 18:10:27 +0530
Message-ID: <1358512827-7694-5-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358512827-7694-1-git-send-email-vgupta@synopsys.com>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
 <1358512827-7694-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/configs/fpga_defconfig |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arc/configs/fpga_defconfig b/arch/arc/configs/fpga_defconfig
index 8638e101f..52a3ae1 100644
--- a/arch/arc/configs/fpga_defconfig
+++ b/arch/arc/configs/fpga_defconfig
@@ -10,13 +10,18 @@ CONFIG_NAMESPACES=y
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
 CONFIG_ARC_BUILTIN_DTB_NAME="angel4"
 # CONFIG_COMPACTION is not set
 # CONFIG_CROSS_MEMORY_ATTACH is not set
-- 
1.7.4.1

