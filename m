Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbbAFBX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 20:23:29 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:6884 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753264AbbAFBX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 20:23:28 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="55581613"
From: Chen Fan <chen.fan.fnst@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>, Davide Libenzi <davidel@xmailserver.org>
CC: <chen.fan.fnst@cn.fujitsu.com>
Subject: [PATCH] eventfd: fix trivial typos in function eventfd_signal() comment
Date: Tue, 6 Jan 2015 09:17:04 +0800
Message-ID: <1420507024-28561-1-git-send-email-chen.fan.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1420452233-20562-1-git-send-email-chen.fan.fnst@cn.fujitsu.com>
References: <1420452233-20562-1-git-send-email-chen.fan.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.78]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Chen Fan <chen.fan.fnst@cn.fujitsu.com>
---

 fs/eventfd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index 4b0a226..f550f8e 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -45,10 +45,10 @@ struct eventfd_ctx {
  *
  * This function is supposed to be called by the kernel in paths that do not
  * allow sleeping. In this function we allow the counter to reach the ULLONG_MAX
- * value, and we signal this as overflow condition by returining a POLLERR
+ * value, and we signal this as overflow condition by returning a POLLERR
  * to poll(2).
  *
- * Returns the amount by which the counter was incrememnted.  This will be less
+ * Returns the amount by which the counter was incremented.  This will be less
  * than @n if the counter has overflowed.
  */
 __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
-- 
1.9.3

