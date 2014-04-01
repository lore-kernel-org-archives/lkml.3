Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbaDABwD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 21:52:03 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38714 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaDABwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 21:52:00 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-bc-533a1bbec1bc
From: Jungseok Lee <jays.lee@samsung.com>
To: konrad.wilk@oracle.com, linux-kernel@vger.kernel.org
Cc: sungjinn.chung@samsung.com,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: [PATCH] swiotlb: Correct kernel command line handler
Date: Tue, 01 Apr 2014 10:51:58 +0900
Message-id: <011801cf4d4c$f7ba51f0$e72ef5d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9NTBtBoMCSDAt8QEisIzQrZOmupg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zA9190lbBBs/2GlssW/yU0eLyrjls
	FjPO72Oy+DBjJaMDi8fHp7dYPPq2rGL0+LxJLoA5issmJTUnsyy1SN8ugStj/odDTAVHeCsO
	tbcxNjB+4+pi5OSQEDCROPx6MyOELSZx4d56ti5GLg4hgWWMEheePGaDKWrYdYgZIrGIUWLd
	5jWMEM4fRolbrduYQarYBDQlHt3tYQexRQQsJFatnwZmMwuES+x6eoIJxBYWsJW4+28/mM0i
	oCqxa3M/2AZeAUuJz0/fsULYghI/Jt9jgejVkli/8zgThC0vsXnNW2aIixQkdpx9zQixS09i
	7/kPULtEJPa9eAd2nITAMnaJm5c2s0MsE5D4NvkQ0FAOoISsxKYDUHMkJQ6uuMEygVFsFpLV
	s5CsnoVk9SwkKxYwsqxiFE0tSC4oTkovMtQrTswtLs1L10vOz93ECImv3h2Mtw9YH2JMBlo/
	kVlKNDkfGJ95JfGGxmZGFqYmpsZG5pZmpAkrifMmPUwKEhJITyxJzU5NLUgtii8qzUktPsTI
	xMEp1cDosXq2SZoEo0BQGMNa04jrnU1/jHx/HxNs/VFxQS+ktE5Cc+fmKOkbeXV1oU3+oVua
	Vhnw71lw49rCxJLbOyQPtu6WCStYxqD871654cnS7uA7k0XDpnGycsd7f62qePtp6ts1769o
	pDd9L/0yyfhP/qGJt+4t3sqao7wwc4t1vVqv65xTqexKLMUZiYZazEXFiQComRH6xQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xgO4+aatgg7379C2WLX7KaHF51xw2
	ixnn9zFZfJixktGBxePj01ssHn1bVjF6fN4kF8Ac1cBok5GamJJapJCal5yfkpmXbqvkHRzv
	HG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0TkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Su
	b0gQXI+RARpIWMeYMf/DIaaCI7wVh9rbGBsYv3F1MXJySAiYSDTsOsQMYYtJXLi3nq2LkYtD
	SGARo8S6zWsYIZw/jBK3WreBVbEJaEo8utvDDmKLCFhIrFo/DcxmFgiX2PX0BBOILSxgK3H3
	334wm0VAVWLX5n42EJtXwFLi89N3rBC2oMSPyfdYIHq1JNbvPM4EYctLbF7zFuoiBYkdZ18z
	QuzSk9h7/gPULhGJfS/eMU5gFJiFZNQsJKNmIRk1C0nLAkaWVYyiqQXJBcVJ6blGesWJucWl
	eel6yfm5mxjB0ftMegfjqgaLQ4wCHIxKPLwW5ZbBQqyJZcWVuYcYJTiYlUR4j7wHCvGmJFZW
	pRblxxeV5qQWH2JMBvp0IrOUaHI+MLHklcQbGpuYGVkamVkYmZibkyasJM57sNU6UEggPbEk
	NTs1tSC1CGYLEwenVANjuf9Dr2SON1HeXsWtvunzIree+3yyrLlR8vQpib+T8j2tdt59to9H
	Il1Ri9HhWceudV2iwRuvLbf9J3BgeeyWZj150c0XRPOVnVYsuXz3/trIvDzpN++jl//W4v/L
	dPbf+TseRv5nhJT//Vt8IaV/8nWLZ6wlO6bOPHgs45zfNIUX/IlWBZcVlFiKMxINtZiLihMB
	1VtvmCIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corrects kernel command line handler when io_tlb_nslabs
is set to 0.

A current implementation allocates default size memory (64MB) when
0 is given to io_tlb_nslabs ("swiotlb=0") by kernel command line.
In other words, memory is allocated unintentionally.

Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
Signed-off-by: Sungjinn Chung <sungjinn.chung@samsung.com>
---
 lib/swiotlb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index b604b83..9fe9f71 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -55,6 +55,8 @@
 
 int swiotlb_force;
 
+static int swiotlb_no_use;
+
 /*
  * Used to do a quick range check in swiotlb_tbl_unmap_single and
  * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
@@ -102,6 +104,8 @@ setup_io_tlb_npages(char *str)
 		io_tlb_nslabs = simple_strtoul(str, &str, 0);
 		/* avoid tail segment of size < IO_TLB_SEGSIZE */
 		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
+		if (!io_tlb_nslabs)
+			swiotlb_no_use = 1;
 	}
 	if (*str == ',')
 		++str;
@@ -212,7 +216,7 @@ swiotlb_init(int verbose)
 	unsigned char *vstart;
 	unsigned long bytes;
 
-	if (!io_tlb_nslabs) {
+	if (!swiotlb_no_use && !io_tlb_nslabs) {
 		io_tlb_nslabs = (default_size >> IO_TLB_SHIFT);
 		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
 	}
@@ -244,7 +248,7 @@ swiotlb_late_init_with_default_size(size_t default_size)
 	unsigned int order;
 	int rc = 0;
 
-	if (!io_tlb_nslabs) {
+	if (!swiotlb_no_use && !io_tlb_nslabs) {
 		io_tlb_nslabs = (default_size >> IO_TLB_SHIFT);
 		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
 	}
-- 
1.7.10.4


