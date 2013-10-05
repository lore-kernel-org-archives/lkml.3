Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab3JERct (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 13:32:49 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:36060 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab3JERcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 13:32:48 -0400
Message-ID: <52504D38.1030402@gmail.com>
Date: Sun, 06 Oct 2013 01:32:40 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] mm/page_alloc.c: Get rid of unused marco LONG_ALIGN
References: <52504CF8.6000708@gmail.com>
In-Reply-To: <52504CF8.6000708@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

The macro is nowhere used, so remove it.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 mm/page_alloc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1fb13b6..9d8508d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3881,8 +3881,6 @@ static inline unsigned long wait_table_bits(unsigned long size)
 	return ffz(~size);
 }
 
-#define LONG_ALIGN(x) (((x)+(sizeof(long))-1)&~((sizeof(long))-1))
-
 /*
  * Check if a pageblock contains reserved pages
  */
-- 
1.7.1

