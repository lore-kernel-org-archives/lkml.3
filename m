Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490AbbAPB7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 20:59:42 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:54020 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754944AbbAPB7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 20:59:41 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="56143626"
From: Chen Fan <chen.fan.fnst@cn.fujitsu.com>
To: Jiri Kosina <trivial@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] eventfd: fix trivial typos in function eventfd_signal() comment
Date: Fri, 16 Jan 2015 09:53:12 +0800
Message-ID: <1421373192-13680-1-git-send-email-chen.fan.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.78]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

