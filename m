Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbaDVGVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:21:34 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:56869 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752081AbaDVGU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:20:27 -0400
X-IronPort-AV: E=Sophos;i="4.97,899,1389715200"; 
   d="scan'208";a="29554499"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 7/7 V3] idr: remove useless #ifndef TEST
Date: Tue, 22 Apr 2014 14:23:29 +0800
Message-ID: <1398147810-26414-8-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1398147810-26414-1-git-send-email-laijs@cn.fujitsu.com>
References: <20140421152345.4d67a6563ebd89f0b969332f@linux-foundation.org>
 <1398147810-26414-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"#ifndef TEST" can't work for user space test now, just remove it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 lib/idr.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 39158ab..96bb252 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -20,11 +20,9 @@
  * that id to this code and it returns your pointer.
  */
 
-#ifndef TEST                        // to test in user space...
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/export.h>
-#endif
 #include <linux/err.h>
 #include <linux/string.h>
 #include <linux/idr.h>
-- 
1.7.4.4

