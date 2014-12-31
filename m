Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbaLaBZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 20:25:47 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:48496 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbaLaBW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 20:22:27 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/19] lib/md5.c: Simplify include
Date: Wed, 31 Dec 2014 02:21:43 +0100
Message-Id: <1419988915-20730-9-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

md5.c doesn't use anything from kernel.h, except that that pulls in
compiler.h, which is needed for the export.h to work.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/md5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/md5.c b/lib/md5.c
index 958a3c15923c..bb0cd01d356d 100644
--- a/lib/md5.c
+++ b/lib/md5.c
@@ -1,4 +1,4 @@
-#include <linux/kernel.h>
+#include <linux/compiler.h>
 #include <linux/export.h>
 #include <linux/cryptohash.h>
 
-- 
2.1.3

