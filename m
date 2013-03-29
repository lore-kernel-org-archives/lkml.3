Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab3C2Mc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 08:32:56 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:61581 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab3C2Mcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 08:32:54 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] notifier-error-inject: fix module names in Kconfig
Date: Fri, 29 Mar 2013 21:32:33 +0900
Message-Id: <1364560353-30173-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig help text for MEMORY_NOTIFIER_ERROR_INJECT and
OF_RECONFIG_NOTIFIER_ERROR_INJECT has mismatched module names.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 lib/Kconfig.debug | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 28be08c..96aeace 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1192,7 +1192,7 @@ config MEMORY_NOTIFIER_ERROR_INJECT
 	  bash: echo: write error: Cannot allocate memory
 
 	  To compile this code as a module, choose M here: the module will
-	  be called pSeries-reconfig-notifier-error-inject.
+	  be called memory-notifier-error-inject.
 
 	  If unsure, say N.
 
@@ -1209,7 +1209,7 @@ config OF_RECONFIG_NOTIFIER_ERROR_INJECT
 	  notified, write the error code to "actions/<notifier event>/error".
 
 	  To compile this code as a module, choose M here: the module will
-	  be called memory-notifier-error-inject.
+	  be called of-reconfig-notifier-error-inject.
 
 	  If unsure, say N.
 
-- 
1.8.1.4

