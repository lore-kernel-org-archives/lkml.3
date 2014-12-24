Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaLXNGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 08:06:33 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:62060 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbaLXNGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 08:06:31 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: mtk.manpages@gmail.com
Cc: linux-man@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 1/2] adjtimex.2: Update return value of adjtimex
Date: Wed, 24 Dec 2014 22:00:39 +0900
Message-Id: <1419426040-16090-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.2.1.62.g3f15098
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch update return value of adjtimex man page.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 man2/adjtimex.2 | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/man2/adjtimex.2 b/man2/adjtimex.2
index eb3fda1..f2a8b8c 100644
--- a/man2/adjtimex.2
+++ b/man2/adjtimex.2
@@ -109,12 +109,13 @@ returns the clock state:
 .PP
 .in +4n
 .nf
-#define TIME_OK   0 /* clock synchronized */
-#define TIME_INS  1 /* insert leap second */
-#define TIME_DEL  2 /* delete leap second */
-#define TIME_OOP  3 /* leap second in progress */
-#define TIME_WAIT 4 /* leap second has occurred */
-#define TIME_BAD  5 /* clock not synchronized */
+#define TIME_OK    0 /* clock synchronized */
+#define TIME_INS   1 /* insert leap second */
+#define TIME_DEL   2 /* delete leap second */
+#define TIME_OOP   3 /* leap second in progress */
+#define TIME_WAIT  4 /* leap second has occurred */
+#define TIME_ERROR 5 /* clock not synchronized */
+#define TIME_BAD   TIME_ERROR /* bw compat */
 .fi
 .in
 .PP
-- 
2.2.1.62.g3f15098

