Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab3KDKHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 05:07:35 -0500
Received: from top.free-electrons.com ([176.31.233.9]:33335 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752190Ab3KDKHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 05:07:34 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: tony.luck@intel.com, fenghua.yu@intel.com
Cc: keescook@chromium.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] ia64/xen: remove unused NO_IDLE_HZ Kconfig parameter
Date: Mon,  4 Nov 2013 11:07:18 +0100
Message-Id: <1383559638-5739-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the NO_IDLE_HZ Kconfig parameter,
which was no longer used anywhere in the source code
and Makefiles.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/ia64/xen/Kconfig | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/ia64/xen/Kconfig b/arch/ia64/xen/Kconfig
index 5d8a06b0ddf7..592999efc419 100644
--- a/arch/ia64/xen/Kconfig
+++ b/arch/ia64/xen/Kconfig
@@ -7,7 +7,6 @@ config XEN
 	default y
 	depends on PARAVIRT && MCKINLEY && IA64_PAGE_SIZE_16KB
 	select XEN_XENCOMM
-	select NO_IDLE_HZ
 	# followings are required to save/restore.
 	select ARCH_SUSPEND_POSSIBLE
 	select SUSPEND
@@ -19,7 +18,3 @@ config XEN
 config XEN_XENCOMM
 	depends on XEN
 	bool
-
-config NO_IDLE_HZ
-	depends on XEN
-	bool
-- 
1.8.1.2

