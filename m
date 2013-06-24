Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab3FXGxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 02:53:08 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:57532 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab3FXGxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 02:53:07 -0400
Subject: [PATCH v3] powerpc/pseries: Enable PSTORE in pseries_defconfig
To: linuxppc-dev@ozlabs.org, mikey@neuling.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: mahesh@linux.vnet.ibm.com, ananth@in.ibm.com
Date: Mon, 24 Jun 2013 12:23:00 +0530
Message-ID: <20130624064534.16842.3582.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062406-5564-0000-0000-0000087CD423
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since now we have pstore support for nvram in pseries, enable it
in the default config. With this config option enabled, pstore
infra-structure will be used to read/write the messages from/to nvram.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
 v3:
	Move pstore config to right place
 v2:
	Change patch description

 arch/powerpc/configs/pseries_defconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/configs/pseries_defconfig b/arch/powerpc/configs/pseries_defconfig
index c4dfbaf..bea8587 100644
--- a/arch/powerpc/configs/pseries_defconfig
+++ b/arch/powerpc/configs/pseries_defconfig
@@ -296,6 +296,7 @@ CONFIG_SQUASHFS=m
 CONFIG_SQUASHFS_XATTR=y
 CONFIG_SQUASHFS_LZO=y
 CONFIG_SQUASHFS_XZ=y
+CONFIG_PSTORE=y
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3_ACL=y
 CONFIG_NFS_V4=y

