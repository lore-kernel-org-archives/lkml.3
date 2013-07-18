Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933743Ab3GRTf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:35:56 -0400
Received: from etezian.org ([198.101.225.253]:40689 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933110Ab3GRTfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:35:55 -0400
From: Andi Shyti <andi@etezian.org>
To: linux@arm.linux.org.uk, linus.walleij@linaro.org, lee.jones@linaro.org,
        fabio.baltieri@linaro.org, rui.zhang@intel.com
Cc: andi@etezian.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] u8500_defconfig: allow creation and mounting of devtmpfs
Date: Thu, 18 Jul 2013 21:35:30 +0200
Message-Id: <1374176130-21209-1-git-send-email-andi@etezian.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables CONFIG_DETTMPFS and CONFIG_DEVTMPFS_MOUNT
flags for u8500 based devices.

In this way it's possible to create a tmpfs/ramfs already in the
early stages of the boot, allowing programs like udev/mdev to
populate the /dev directory.

Signed-off-by: Andi Shyti <andi@etezian.org>
---
 arch/arm/configs/u8500_defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/u8500_defconfig b/arch/arm/configs/u8500_defconfig
index a0025dc..0675d6a 100644
--- a/arch/arm/configs/u8500_defconfig
+++ b/arch/arm/configs/u8500_defconfig
@@ -109,6 +109,8 @@ CONFIG_EXT2_FS_SECURITY=y
 CONFIG_EXT3_FS=y
 CONFIG_EXT4_FS=y
 CONFIG_VFAT_FS=y
+CONFIG_DEVTMPFS=y
+CONFIG_DEVTMPFS_MOUNT=y
 CONFIG_TMPFS=y
 CONFIG_TMPFS_POSIX_ACL=y
 # CONFIG_MISC_FILESYSTEMS is not set
-- 
1.8.3.2

