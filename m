Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaLaBWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 20:22:35 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:51424 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbaLaBWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 20:22:33 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 16/19] lib/stmp_device.c: Replace module.h include
Date: Wed, 31 Dec 2014 02:21:51 +0100
Message-Id: <1419988915-20730-17-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stmp_device.c only needs EXPORT_SYMBOL, so just include compiler.h and
export.h instead of the whole module.h machinery.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/stmp_device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/stmp_device.c b/lib/stmp_device.c
index 8ac9bcc4289a..a904656f4fd7 100644
--- a/lib/stmp_device.c
+++ b/lib/stmp_device.c
@@ -15,7 +15,8 @@
 #include <linux/io.h>
 #include <linux/errno.h>
 #include <linux/delay.h>
-#include <linux/module.h>
+#include <linux/compiler.h>
+#include <linux/export.h>
 #include <linux/stmp_device.h>
 
 #define STMP_MODULE_CLKGATE	(1 << 30)
-- 
2.1.3

