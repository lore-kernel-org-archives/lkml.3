Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaLaBWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 20:22:52 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:44686 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbaLaBWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 20:22:35 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 19/19] lib/lcm.c: Replace include
Date: Wed, 31 Dec 2014 02:21:54 +0100
Message-Id: <1419988915-20730-20-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need all the stuff kernel.h pulls in; just compiler.h since
export.h doesn't do necessary #includes. This removes more than 100
dependencies.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/lcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/lcm.c b/lib/lcm.c
index 51cc6b13cd52..e97dbd51e756 100644
--- a/lib/lcm.c
+++ b/lib/lcm.c
@@ -1,4 +1,4 @@
-#include <linux/kernel.h>
+#include <linux/compiler.h>
 #include <linux/gcd.h>
 #include <linux/export.h>
 #include <linux/lcm.h>
-- 
2.1.3

