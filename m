Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaDAGno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 02:43:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:21639 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbaDAGnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 02:43:43 -0400
X-IronPort-AV: E=Sophos;i="4.97,770,1389715200"; 
   d="scan'208";a="9805432"
Message-ID: <533A5FCB.50502@cn.fujitsu.com>
Date: Tue, 01 Apr 2014 14:42:19 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131030 Thunderbird/17.0.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] madvise: Correct the comment of MADV_DODUMP flag
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/04/01 14:40:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/04/01 14:40:05,
	Serialize complete at 2014/04/01 14:40:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/MADV_NODUMP/MADV_DONTDUMP/

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 include/uapi/asm-generic/mman-common.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/uapi/asm-generic/mman-common.h b/include/uapi/asm-generic/mman-common.h
index 4164529..ddc3b36 100644
--- a/include/uapi/asm-generic/mman-common.h
+++ b/include/uapi/asm-generic/mman-common.h
@@ -50,7 +50,7 @@

 #define MADV_DONTDUMP   16             /* Explicity exclude from the core dump,
                                           overrides the coredump filter bits */
-#define MADV_DODUMP    17              /* Clear the MADV_NODUMP flag */
+#define MADV_DODUMP    17              /* Clear the MADV_DONTDUMP flag */

 /* compatibility flags */
 #define MAP_FILE       0
-- 
1.7.1
