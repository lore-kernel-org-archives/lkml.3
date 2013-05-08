Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab3EHCEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 22:04:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26124 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab3EHCEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 22:04:08 -0400
X-AuditID: cbfee690-b7f136d000000fea-85-5189b2956474
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: "'David S. Miller'" <davem@davemloft.net>
References: <004801ce33e4$0a2ffc00$1e8ff400$%choi@samsung.com>
In-reply-to: 
Subject: [PATCH] net/core Fix wrong comments about memcpy_fromiovecend
Date: Wed, 08 May 2013 11:04:04 +0900
Message-id: <000301ce4b90$5132f170$f398d450$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAEJzDJAAAEqHoAC1cPGABGTGq0ABhlNeMA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t8zfd2pmzoDDZ5t5rWYc76FxWJJM7fF
	5V1z2ByYPbasvMnk0bdlFaPH501yAcxRXDYpqTmZZalF+nYJXBktF/+zFFxkrZj2uIO1gfEs
	SxcjJ4eEgInEzKl32SFsMYkL99azdTFycQgJLGOUWNy2kAmm6O35JVCJ6YwS0+f0QTl/GSX6
	dtxgBKliE9CVOLZ+CyuILSLgLXFqyi9mEJsZKH597n+wFUICdhJr/s1jA7E5BXgk1v3pBKsR
	FnCT6H+4AKyGRUBV4vXabWCbeYHqj986B2ULSvyYfI8FYqaWxPqdx5kgbHmJzWveAs3hALpU
	XeLRX12IEyIkNryfxQhRIiKx78U7RpCbJQS2sUssm3yNFWKXgMS3yYdYIHplJTYdYIZ4WFLi
	4IobLBMYJWYh2TwLyeZZSDbPQrJiASPLKkbR1ILkguKk9CITveLE3OLSvHS95PzcTYyQCJyw
	g/HeAetDjMlA6ycyS4km5wMjOK8k3tDYzMjC1MTU2Mjc0ow0YSVxXvUW60AhgfTEktTs1NSC
	1KL4otKc1OJDjEwcnFINjCnyvce1z15UfuItsjNK3OR4VqmQ8nmGDXEP/NvdfPhdSv7+mGdy
	5k7dRvPzb5p+21rLt7yS2ZU7KX119B+XffM2NW9a7b1u9hb1BS4Tz0asnuZXasBQ6SU0n3Ht
	PyGnR8uWF9QYXZiSdCKoVj/yxIwdzPvs08S+mf9uFG/U4i+XuBHDt3b1DiWW4oxEQy3mouJE
	AI5skTvWAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t9jQd2pmzoDDVa85bSYc76FxWJJM7fF
	5V1z2ByYPbasvMnk0bdlFaPH501yAcxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6
	hpYW5koKeYm5qbZKLj4Bum6ZOUCLlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZ
	oIGEdYwZLRf/sxRcZK2Y9riDtYHxLEsXIyeHhICJxNvzS9ggbDGJC/fWA9lcHEIC0xklps/p
	g3L+Mkr07bjBCFLFJqArcWz9FlYQW0TAW+LUlF/MIDYzUPz63P/sILaQgJ3Emn/zwKZyCvBI
	rPvTCVYjLOAm0f9wAVgNi4CqxOu125hAbF6g+uO3zkHZghI/Jt9jgZipJbF+53EmCFteYvOa
	t0BzOIAuVZd49FcX4oQIiQ3vZzFClIhI7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1I
	LihOSs811CtOzC0uzUvXS87P3cQIju9nUjsYVzZYHGIU4GBU4uG14O4MFGJNLCuuzD3EKMHB
	rCTCW1YAFOJNSaysSi3Kjy8qzUktPsSYDPToRGYp0eR8YOrJK4k3NDYxM7I0MrMwMjE3J01Y
	SZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQbGFq3YHv3ZMalhhZNSs7PMhDZZ2ua3RtuKpU2Y
	NCukf830e7OTp/I/zVUTWfraR425inUWZ/qViKIyx89HP6zwz3i/9sf6md/1jDfOOt01bbq+
	cZtKq80MsZtzJkXPqTiS8DJtdcor/W2u1lY3+bvr9KaxP3wyQyBm9oF6viPuiXNXHHjewz5X
	iaU4I9FQi7moOBEA3qRPHzMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Copy iovec from kernel" should be "Copy iovec to kernel"
because copy_from_user copies data from userspace.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 net/core/iovec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/iovec.c b/net/core/iovec.c
index 7e7aeb0..ba93fd2 100644
--- a/net/core/iovec.c
+++ b/net/core/iovec.c
@@ -150,7 +150,7 @@ int memcpy_fromiovec(unsigned char *kdata, struct iovec
*iov, int len)
 EXPORT_SYMBOL(memcpy_fromiovec);
 
 /*
- *	Copy iovec from kernel. Returns -EFAULT on error.
+ *	Copy iovec to kernel. Returns -EFAULT on error.
  */
 
 int memcpy_fromiovecend(unsigned char *kdata, const struct iovec *iov,
-- 
1.7.

