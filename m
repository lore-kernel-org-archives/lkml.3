Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab3HTQPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:15:41 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:48119 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab3HTQPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:15:40 -0400
Subject: [PATCH v3 trivial 1/7] Docs: Kconfig: For readability,
                                               offset modifiers with commas
Date: Tue, 20 Aug 2013 16:05:12 -0000
From: Michael Witten <mfwitten@gmail.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Rob Landley <rob@landley.net>, Randy Dunlap <rdunlap@infradead.org>,
        David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
Message-ID: <64c884c773954310a271fff5be724f7f-mfwitten@gmail.com>
In-Reply-To: <4cd8ab80726c43cf90243970c20f50ef-mfwitten@gmail.com>
References: <4cd8ab80726c43cf90243970c20f50ef-mfwitten@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Mon, 22 Apr 2013 02:21:32 +0000

This updates the Kconfig descriptions for the following:

  * UTC namespace (UTS_NS)
  * IPC namespace (IPC_NS)

Signed-off-by: Michael Witten <mfwitten@gmail.com>
---
 init/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 247084b..6ba39b6 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1093,7 +1093,7 @@ config UTS_NS
 	bool "UTS namespace"
 	default y
 	help
-	  In this namespace tasks see different info provided with the
+	  In this namespace, tasks see different info provided with the
 	  uname() system call
 
 config IPC_NS
@@ -1101,7 +1101,7 @@ config IPC_NS
 	depends on (SYSVIPC || POSIX_MQUEUE)
 	default y
 	help
-	  In this namespace tasks work with IPC ids which correspond to
+	  In this namespace, tasks work with IPC ids which correspond to
 	  different IPC objects in different namespaces.
 
 config USER_NS
-- 
1.7.11.2.252.gc4a64c8

