Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab3GYHG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 03:06:28 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:53526 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab3GYHG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 03:06:26 -0400
Date: Thu, 25 Jul 2013 15:06:13 +0800 (CST)
From: Xiong Zhou <jencce.kernel@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Andreas Dilger <andreas.dilger@intel.com>,
        Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
        Peng Tao <bergwolf@gmail.com>, devel@driverdev.osuosl.org,
        jencce.kernel@gmail.com
Subject: [PATCH] staging/lustre: add BLOCK depends in Kconfig
Message-ID: <alpine.DEB.2.02.1307251458330.31610@M2420>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-345731864-1374735983=:31610"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-345731864-1374735983=:31610
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

From: Xiong Zhou <jencce.kernel@gmail.com>

Add BLOCK depends in Kconfig for LUSTRE to fix this:
drivers/staging/lustre/lustre/fid/../include/linux/lustre_compat25.h:117:2: 
error: implicit declaration of function ¡unregister_blkdev¢ 

Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
---
 drivers/staging/lustre/lustre/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/Kconfig b/drivers/staging/lustre/lustre/Kconfig
index 9ae7fa8..0b45de0 100644
--- a/drivers/staging/lustre/lustre/Kconfig
+++ b/drivers/staging/lustre/lustre/Kconfig
@@ -1,6 +1,6 @@
 config LUSTRE_FS
 	tristate "Lustre file system client support"
-	depends on STAGING && INET && m
+	depends on STAGING && INET && BLOCK && m
 	select LNET
 	select CRYPTO
 	select CRYPTO_CRC32
--8323328-345731864-1374735983=:31610--
