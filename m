Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaI3UYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:24:50 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47102 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaI3UYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:24:49 -0400
Message-ID: <542B118D.3030306@gmail.com>
Date: Tue, 30 Sep 2014 21:24:45 +0100
From: Paul McQuade <paulmcquad@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Paul McQuade <paulmcquad@gmail.com>, Xishi Qiu <qiuxishi@huawei.com>
Subject: [PATCH] MM: bootmem: Added headers
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b9f5d476a5aaad7a21c319b6bce6b3717925d9c9 Mon Sep 17 00:00:00 2001
From: Paul McQuade <paulmcquad@gmail.com>
Date: Tue, 30 Sep 2014 20:51:54 +0100
Subject: [PATCH] MM: bootmem: Added headers

Replace asm headers with the following linux headers.
<linux/bug.h>
<linux/io.h>

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 mm/bootmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 90bd350..8a000ce 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -16,9 +16,9 @@
 #include <linux/kmemleak.h>
 #include <linux/range.h>
 #include <linux/memblock.h>
+#include <linux/bug.h>
+#include <linux/io.h>
 
-#include <asm/bug.h>
-#include <asm/io.h>
 #include <asm/processor.h>
 
 #include "internal.h"
-- 
1.9.1

