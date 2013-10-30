Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab3J3LbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 07:31:04 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:63287 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab3J3LbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 07:31:01 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 4/4] staging/lustre: enable build on MIPS/XTENSA/SUPERH
Date: Wed, 30 Oct 2013 19:30:36 +0800
Message-Id: <1383132636-8952-4-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383132636-8952-1-git-send-email-bergwolf@gmail.com>
References: <1383132636-8952-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The missing symbol copy_from_user_page() is not needed now.

Cc: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Niu Yawei <yawei.niu@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/Kconfig b/drivers/staging/lustre/lustre/Kconfig
index 2156a44..e44965b 100644
--- a/drivers/staging/lustre/lustre/Kconfig
+++ b/drivers/staging/lustre/lustre/Kconfig
@@ -1,6 +1,6 @@
 config LUSTRE_FS
 	tristate "Lustre file system client support"
-	depends on INET && m && !MIPS && !XTENSA && !SUPERH
+	depends on INET && m
 	select LNET
 	select CRYPTO
 	select CRYPTO_CRC32
-- 
1.7.9.5

