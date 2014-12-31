Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaLaBXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 20:23:37 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:36280 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbaLaBWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 20:22:34 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 17/19] lib/strncpy_from_user.c: Replace module.h include
Date: Wed, 31 Dec 2014 02:21:52 +0100
Message-Id: <1419988915-20730-18-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

strncpy_from_user.c only needs EXPORT_SYMBOL, so just include
compiler.h and export.h instead of the whole module.h machinery.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/strncpy_from_user.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/strncpy_from_user.c b/lib/strncpy_from_user.c
index bb2b201d6ad0..e0af6ff73d14 100644
--- a/lib/strncpy_from_user.c
+++ b/lib/strncpy_from_user.c
@@ -1,4 +1,5 @@
-#include <linux/module.h>
+#include <linux/compiler.h>
+#include <linux/export.h>
 #include <linux/uaccess.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
-- 
2.1.3

