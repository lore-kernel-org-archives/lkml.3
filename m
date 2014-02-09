Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaBISsq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 13:48:46 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62426 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbaBISsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 13:48:42 -0500
From: Richard Weinberger <richard@nod.at>
To: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com (moderated list:PANASONIC MN10300...),
        linux-kernel@vger.kernel.org (open list)
Cc: Richard Weinberger <richard@nod.at>
Subject: [PATCH 24/28] Remove DEPRECATED
Date: Sun,  9 Feb 2014 19:48:02 +0100
Message-Id: <1391971686-9517-25-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1391971686-9517-1-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol is an orphan, get rid of it.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/mn10300/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mn10300/Kconfig.debug b/arch/mn10300/Kconfig.debug
index 94efb3e..af18047 100644
--- a/arch/mn10300/Kconfig.debug
+++ b/arch/mn10300/Kconfig.debug
@@ -32,7 +32,7 @@ config KPROBES
 
 config GDBSTUB
 	bool "Remote GDB kernel debugging"
-	depends on DEBUG_KERNEL && DEPRECATED
+	depends on DEBUG_KERNEL
 	select DEBUG_INFO
 	select FRAME_POINTER
 	help
-- 
1.8.4.2

