Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbbAKUGT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 15:06:19 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:43484 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbbAKUGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 15:06:17 -0500
From: Dmitry Voytik <voytikd@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Dmitry Voytik <voytikd@gmail.com>
Subject: [PATCH] bug: add comments for BUG_ON() and BUG()
Date: Sun, 11 Jan 2015 23:06:18 +0300
Message-Id: <1421006778-11148-1-git-send-email-voytikd@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Voytik <voytikd@gmail.com>
---
 include/asm-generic/bug.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 630dd23..b0aa488 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -43,6 +43,10 @@ struct bug_entry {
  * If you're tempted to BUG(), think again:  is completely giving up
  * really the *only* solution?  There are usually better options, where
  * users don't need to reboot ASAP and can mostly shut down cleanly.
+ *
+ * Use BUG_ON(unexpected_fatal_condition) instead of just:
+ * if (unexpected_fatal_condition)
+ *	BUG();
  */
 #ifndef HAVE_ARCH_BUG
 #define BUG() do { \
-- 
1.9.1

