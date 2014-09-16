Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbaIPIvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 04:51:43 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:7570 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbaIPIvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 04:51:39 -0400
Message-ID: <5417FA0F.1030403@huawei.com>
Date: Tue, 16 Sep 2014 16:51:27 +0800
From: Yao Dongdong <yaodongdong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] Documentation/memory-barriers.txt: match table to its comment
 followed
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.110.51.36]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The table shows CPU2's sequence of events as "x = B; y = A;", but its comment followed
described as "x = A; y = B;".

Signed-off-by: Yao Dongdong <yaodongdong@huawei.com>
---
 Documentation/memory-barriers.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index a4de88f..9a46bbe 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -115,8 +115,8 @@ For example, consider the following sequence of events:
        CPU 1           CPU 2
        =============== ===============
        { A == 1; B == 2 }
-       A = 3;          x = B;
-       B = 4;          y = A;
+       A = 3;          x = A;
+       B = 4;          y = B;

 The set of accesses as seen by the memory system in the middle can be arranged
 in 24 different combinations:
--
1.8.0.1

