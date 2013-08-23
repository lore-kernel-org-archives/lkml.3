Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab3HWJrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 05:47:11 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:65038 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab3HWJrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 05:47:07 -0400
Message-ID: <52172F87.1010706@huawei.com>
Date: Fri, 23 Aug 2013 17:46:47 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: <rob@landley.net>, <ohad@wizery.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Xishi Qiu <qiuxishi@huawei.com>
Subject: [PATCH] doc: documentation/hwspinlock.txt fix typo
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a trivial typo in Documentation/hwspinlock.txt

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 Documentation/hwspinlock.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/hwspinlock.txt b/Documentation/hwspinlock.txt
index a903ee5..62f7d4e 100644
--- a/Documentation/hwspinlock.txt
+++ b/Documentation/hwspinlock.txt
@@ -241,7 +241,7 @@ int hwspinlock_example2(void)
      locks).
      Should be called from a process context (this function might sleep).
      Returns the address of hwspinlock on success, or NULL on error (e.g.
-     if the hwspinlock is sill in use).
+     if the hwspinlock is still in use).
 
 5. Important structs
 
-- 
1.7.1


