Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbaKKGJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 01:09:39 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:36791 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaKKGJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 01:09:38 -0500
From: Xie XiuQi <xiexiuqi@huawei.com>
To: <linux-kernel@vger.kernel.org>
CC: <johunt@akamai.com>, <akpm@linux-foundation.org>, <jbaron@akamai.com>
Subject: [PATCH] kernel/panic: update comments for print_tainted
Date: Tue, 11 Nov 2014 14:50:59 +0800
Message-ID: <1415688659-22131-1-git-send-email-xiexiuqi@huawei.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commits 69361eef9056 ("panic: add TAINT_SOFTLOCKUP") added the 'L' flag,
but failed to update the comments for print_tainted(). So, update the
comments.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
---
 kernel/panic.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index d09dc5c..cf80672 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -244,6 +244,7 @@ static const struct tnt tnts[] = {
  *  'I' - Working around severe firmware bug.
  *  'O' - Out-of-tree module has been loaded.
  *  'E' - Unsigned module has been loaded.
+ *  'L' - A soft lockup has previously occurred.
  *
  *	The string is overwritten by the next call to print_tainted().
  */
-- 
1.7.1

