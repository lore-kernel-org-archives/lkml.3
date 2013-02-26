Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab3BZLEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 06:04:14 -0500
Received: from multi.imgtec.com ([194.200.65.239]:58360 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332Ab3BZLEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 06:04:13 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 4/5] metag: remove CONFIG_EXPERIMENTAL from defconfigs
Date: Tue, 26 Feb 2013 11:04:01 +0000
Message-ID: <1361876642-10247-5-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361876642-10247-1-git-send-email-james.hogan@imgtec.com>
References: <1361876642-10247-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_26_11_04_11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since upstream commit "make CONFIG_EXPERIMENTAL invisible and default"
CONFIG_EXPERIMENTAL is invisible and defaults to y pending it's removal.
Therefore remove the explicit selection from the metag defconfig files.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/configs/meta1_defconfig     | 1 -
 arch/metag/configs/meta2_defconfig     | 1 -
 arch/metag/configs/meta2_smp_defconfig | 1 -
 3 files changed, 3 deletions(-)

diff --git a/arch/metag/configs/meta1_defconfig b/arch/metag/configs/meta1_defconfig
index ad663ca..c35a75e 100644
--- a/arch/metag/configs/meta1_defconfig
+++ b/arch/metag/configs/meta1_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_LOG_BUF_SHIFT=13
diff --git a/arch/metag/configs/meta2_defconfig b/arch/metag/configs/meta2_defconfig
index 47922e93..fb31484 100644
--- a/arch/metag/configs/meta2_defconfig
+++ b/arch/metag/configs/meta2_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/metag/configs/meta2_smp_defconfig b/arch/metag/configs/meta2_smp_defconfig
index f508250..6c7b777 100644
--- a/arch/metag/configs/meta2_smp_defconfig
+++ b/arch/metag/configs/meta2_smp_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
-- 
1.8.1.2


