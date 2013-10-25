Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab3JYHv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 03:51:58 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45577 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946Ab3JYHva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 03:51:30 -0400
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH 3/3] net, iovec: fix the uncorrect comment in memcpy_fromiovecend()
Date: Fri, 25 Oct 2013 15:49:20 +0800
Message-Id: <1382687360-27794-3-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1382687360-27794-1-git-send-email-zwu.kernel@gmail.com>
References: <1382687360-27794-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102507-0320-0000-0000-0000018287AC
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

