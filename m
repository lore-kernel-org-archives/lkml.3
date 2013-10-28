Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab3J1GFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 02:05:16 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:37212 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418Ab3J1GEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 02:04:53 -0400
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, stephen@networkplumber.org,
        davem@davemloft.net, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v2 3/3] net, iovec: fix the incorrect comment in memcpy_fromiovecend()
Date: Mon, 28 Oct 2013 14:01:50 +0800
Message-Id: <1382940110-10737-3-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1382940110-10737-1-git-send-email-zwu.kernel@gmail.com>
References: <1382940110-10737-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102806-9332-0000-0000-000001F23AB3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 net/core/iovec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/iovec.c b/net/core/iovec.c
index b77eeec..4cdb7c4 100644
--- a/net/core/iovec.c
+++ b/net/core/iovec.c
@@ -100,7 +100,7 @@ int memcpy_toiovecend(const struct iovec *iov, unsigned char *kdata,
 EXPORT_SYMBOL(memcpy_toiovecend);
 
 /*
- *	Copy iovec from kernel. Returns -EFAULT on error.
+ *	Copy iovec to kernel. Returns -EFAULT on error.
  */
 
 int memcpy_fromiovecend(unsigned char *kdata, const struct iovec *iov,
-- 
1.7.11.7

