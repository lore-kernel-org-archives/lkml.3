Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab3GXSDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:03:38 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:53666 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab3GXSDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:03:35 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>, Peng Tao <tao.peng@emc.com>
Subject: [PATCH-RESEND 3/3] staging/lustre: fix Kconfig bool defaults
Date: Thu, 25 Jul 2013 02:00:21 +0800
Message-Id: <1374688821-9874-4-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374688821-9874-1-git-send-email-bergwolf@gmail.com>
References: <1374688821-9874-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should be y instead of true.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
---
 drivers/staging/lustre/lustre/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/Kconfig b/drivers/staging/lustre/lustre/Kconfig
index 9ae7fa8..e3b3c74 100644
--- a/drivers/staging/lustre/lustre/Kconfig
+++ b/drivers/staging/lustre/lustre/Kconfig
@@ -52,4 +52,4 @@ config LUSTRE_DEBUG_EXPENSIVE_CHECK
 config LUSTRE_TRANSLATE_ERRNOS
 	bool
 	depends on LUSTRE_FS && !X86
-	default true
+	default y
-- 
1.7.9.5

