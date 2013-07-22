Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab3GVQoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:44:05 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36003 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab3GVQoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:44:04 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>, Peng Tao <tao.peng@emc.com>
Subject: [PATCH] staging/lustre: fix Kconfig bool defaults
Date: Tue, 23 Jul 2013 00:41:30 +0800
Message-Id: <1374511290-4883-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should be y/n instead of true/false...

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
---
This applis on top of the 48 Intel tree ported patches.

 drivers/staging/lustre/lustre/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/Kconfig b/drivers/staging/lustre/lustre/Kconfig
index 566d89d..d80a78f 100644
--- a/drivers/staging/lustre/lustre/Kconfig
+++ b/drivers/staging/lustre/lustre/Kconfig
@@ -50,7 +50,7 @@ config LUSTRE_OBD_MAX_IOCTL_BUFFER
 config LUSTRE_DEBUG_LU_REF_CHECK
 	bool "Enable Lustre DEBUG object refcount checks"
 	depends on LUSTRE_FS
-	default false
+	default n
 	help
 	  This option is mainly for debug purpose. It enables Lustre code to track
 	  references between objects.
@@ -60,7 +60,7 @@ config LUSTRE_DEBUG_LU_REF_CHECK
 config LUSTRE_DEBUG_EXPENSIVE_CHECK
 	bool "Enable Lustre DEBUG checks"
 	depends on LUSTRE_FS
-	default false
+	default n
 	help
 	  This option is mainly for debug purpose. It enables Lustre code to do
 	  expensive checks that may have a performance impact.
@@ -70,4 +70,4 @@ config LUSTRE_DEBUG_EXPENSIVE_CHECK
 config LUSTRE_TRANSLATE_ERRNOS
 	bool
 	depends on LUSTRE_FS && !X86
-	default true
+	default y
-- 
1.7.9.5

