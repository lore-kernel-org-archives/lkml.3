Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab3I1L0u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 07:26:50 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:41425 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab3I1L0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 07:26:47 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 1/2] arm64: include EXT4 in defconfig
Date: Sat, 28 Sep 2013 16:49:55 +0530
Message-Id: <1380367196-28295-2-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.4.477.g4cae6f5
In-Reply-To: <1380367196-28295-1-git-send-email-artagnon@gmail.com>
References: <1380367196-28295-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most readily available root filesystems are formatted as EXT4 these
days. For example, see the raring rootfs that the Debian folk is
preparing [1].

[1]: http://people.debian.org/~wookey/bootstrap/rootfs/

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 arch/arm64/configs/defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 5b3e832..798bcbb 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -72,6 +72,7 @@ CONFIG_LOGO=y
 # CONFIG_IOMMU_SUPPORT is not set
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
+CONFIG_EXT4_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
 # CONFIG_EXT3_FS_XATTR is not set
 CONFIG_FUSE_FS=y
-- 
1.8.4.477.g4cae6f5

