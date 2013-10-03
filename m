Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab3JCLi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 07:38:27 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:63869 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab3JCLiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 07:38:24 -0400
Message-ID: <524D5726.4060608@gmail.com>
Date: Thu, 03 Oct 2013 19:38:14 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Jiri Kosina <trivial@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: [PATCH TRIVIAL] __page_to_pfn: Fix typo in comment
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

Fix typo in __page_to_pfn comment: s/encorded/encoded.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 include/asm-generic/memory_model.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/memory_model.h b/include/asm-generic/memory_model.h
index aea9e45..14909b0 100644
--- a/include/asm-generic/memory_model.h
+++ b/include/asm-generic/memory_model.h
@@ -53,7 +53,7 @@
 
 #elif defined(CONFIG_SPARSEMEM)
 /*
- * Note: section's mem_map is encorded to reflect its start_pfn.
+ * Note: section's mem_map is encoded to reflect its start_pfn.
  * section[i].section_mem_map == mem_map's address - start_pfn;
  */
 #define __page_to_pfn(pg)					\
-- 
1.7.1
