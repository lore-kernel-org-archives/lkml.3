Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab3AWPSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:18:46 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:42344 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab3AWPSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:18:45 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: akinobu.mita@gmail.com, rob@landley.net, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] documentation: fault-injection: Fix typo in notifier-error-inject.txt
Date: Thu, 24 Jan 2013 00:18:37 +0900
Message-Id: <1358954317-6975-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.1.1.293.gfe73786
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typos in notifier-error-inject.txt

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/fault-injection/notifier-error-inject.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/fault-injection/notifier-error-inject.txt b/Documentation/fault-injection/notifier-error-inject.txt
index c83526c..09adabe 100644
--- a/Documentation/fault-injection/notifier-error-inject.txt
+++ b/Documentation/fault-injection/notifier-error-inject.txt
@@ -1,7 +1,7 @@
 Notifier error injection
 ========================
 
-Notifier error injection provides the ability to inject artifical errors to
+Notifier error injection provides the ability to inject artificial errors to
 specified notifier chain callbacks. It is useful to test the error handling of
 notifier call chain failures which is rarely executed.  There are kernel
 modules that can be used to test the following notifiers.
@@ -14,7 +14,7 @@ modules that can be used to test the following notifiers.
 CPU notifier error injection module
 -----------------------------------
 This feature can be used to test the error handling of the CPU notifiers by
-injecting artifical errors to CPU notifier chain callbacks.
+injecting artificial errors to CPU notifier chain callbacks.
 
 If the notifier call chain should be failed with some events notified, write
 the error code to debugfs interface
-- 
1.8.1.1.293.gfe73786

