Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763540Ab3IEItz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 04:49:55 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:43099 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757468Ab3IEItw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 04:49:52 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Li Wei <wei.g.li@intel.com>, Andreas Dilger <andreas.dilger@intel.com>,
        Peng Tao <tao.peng@emc.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] staging/lustre: Correct default for LUSTRE_TRANSLATE_ERRNOS
Date: Thu,  5 Sep 2013 10:49:01 +0200
Message-Id: <1378370941-4493-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LUSTRE_TRANSLATE_ERRNOS is never enabled, a "true" is not a valid value.
Use "default y" instead of "default true" to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/staging/lustre/lustre/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/Kconfig b/drivers/staging/lustre/lustre/Kconfig
index 4e898e4..e44965b 100644
--- a/drivers/staging/lustre/lustre/Kconfig
+++ b/drivers/staging/lustre/lustre/Kconfig
@@ -52,7 +52,7 @@ config LUSTRE_DEBUG_EXPENSIVE_CHECK
 config LUSTRE_TRANSLATE_ERRNOS
 	bool
 	depends on LUSTRE_FS && !X86
-	default true
+	default y
 
 config LUSTRE_LLITE_LLOOP
 	bool "Lustre virtual block device"
-- 
1.7.9.5

