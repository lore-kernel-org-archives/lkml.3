Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880Ab3GOO2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:28:44 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:56214 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385Ab3GOO2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:28:41 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH-v3 17/17] staging/lustre: drop CONFIG_BROKEN
Date: Mon, 15 Jul 2013 22:27:20 +0800
Message-Id: <1373898440-14208-18-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
References: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 0ad1ea69545b1965be4c93ee03fdc685c6beb23d

I didn't use git revert because it can not be done cleanly.
Hopefully it will be the last time we do it...

Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/Kconfig b/drivers/staging/lustre/lustre/Kconfig
index c59ea55..893a3c6 100644
--- a/drivers/staging/lustre/lustre/Kconfig
+++ b/drivers/staging/lustre/lustre/Kconfig
@@ -1,6 +1,6 @@
 config LUSTRE_FS
 	tristate "Lustre file system client support"
-	depends on STAGING && INET && m && BROKEN
+	depends on STAGING && INET && m
 	select LNET
 	select CRYPTO
 	select CRYPTO_CRC32
-- 
1.7.9.5

