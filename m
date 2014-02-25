Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaBYHv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 02:51:27 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:57171 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbaBYHvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 02:51:25 -0500
Date: Tue, 25 Feb 2014 13:21:13 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: josh@joshtriplett.org
Subject: [PATCH 6/8] lib: Include appropriate header file in lib/libcrc32c.c
Message-ID: <716945bffcda22f4809972abf5b5b27b20c0bd9f.1393313946.git.rashika.kheria@gmail.com>
References: <7bf34999aea7f3d1441dc8fc344882a814da6e06.1393313946.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7bf34999aea7f3d1441dc8fc344882a814da6e06.1393313946.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file include/linux/crc32c.h in
lib/libcrc32c.c because it has prototype declaration of function defined
in lib/libcrc32c.c.

This eliminates the following warning in lib/libcrc32c.c:
lib/libcrc32c.c:42:5: warning: no previous prototype for ‘crc32c’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 lib/libcrc32c.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/libcrc32c.c b/lib/libcrc32c.c
index 244f548..793a6a3 100644
--- a/lib/libcrc32c.c
+++ b/lib/libcrc32c.c
@@ -36,6 +36,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/crc32c.h>
 
 static struct crypto_shash *tfm;
 
-- 
1.7.9.5

