Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935768Ab3DKChm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 22:37:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31878 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab3DKChl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 22:37:41 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-bf-516621dd8319
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: "'Christoffer Dall'" <cdall@cs.columbia.edu>,
        "'Russell King'" <linux@arm.linux.org.uk>
References: 
In-reply-to: 
Subject: [PATCH] KVM: ARM: Fix wrong address in comment
Date: Thu, 11 Apr 2013 11:37:17 +0900
Message-id: <000801ce365d$7b9bce70$72d36b50$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAEJzDJAAtXBJYACaKDZQAASDCoA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t8zQ927immBBo+nqljMmyJrsaSZ22LT
	42usFpd3zWGzuH2Z14HVo6W5h83j662DTB6bl9R79G1ZxejxeZNcAGsUl01Kak5mWWqRvl0C
	V0b3hh2sBe84Km7O+cTcwNjF3sXIySEhYCKxrm02M4QtJnHh3nq2LkYuDiGBZYwSf/7vYYUp
	urrwMiNEYhGjxJf9t6Gcv4wSB/YvYgOpYhPQlTi2fgtYh4hAscSpJ2eBbA4OZoFIifu/xEFM
	IQFuidXNQSAVnAI8Euv+dIItFhYwl1g14xnYFBYBVYl3Mz6A2bwCdhL77t+EsgUlfky+xwJi
	MwtoSazfeZwJwpaX2LzmLTPIeAkBdYlHf3UhDvCT+NW1kBWiRERi34t3YBdLCFxjl3hz/DEL
	xC4BiW+TD7FA9MpKbDoADQdJiYMrbrBMYJSYhWTzLCSbZyHZPAvJigWMLKsYRVMLkguKk9KL
	TPWKE3OLS/PS9ZLzczcxQuJz4g7G+wesDzEmA62fyCwlmpwPjO+8knhDYzMjC1MTU2Mjc0sz
	0oSVxHnVW6wDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTC2hk35MW33y13fT7JzynwKP9Of
	mdS2x/80+5fQ7/uflifYyDft0Jsb3GIzw2dixYrpS5OcJ/OuOOoeo/yYb92J9Ek3lnO1K832
	3iH8df+uma+6LCbkXJjYmcp2v8cq/VWRi3yd4bvX/A6pUxgn3t/g6+HCuvqdTMDVOZqMWaqL
	4m40/j4qeuu4EktxRqKhFnNRcSIArxo6qOUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t9jAd27immBBouWKVjMmyJrsaSZ22LT
	42usFpd3zWGzuH2Z14HVo6W5h83j662DTB6bl9R79G1ZxejxeZNcAGtUA6NNRmpiSmqRQmpe
	cn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBmJYWyxJxSoFBAYnGxkr4d
	pgmhIW66FjCNEbq+IUFwPUYGaCBhHWNG94YdrAXvOCpuzvnE3MDYxd7FyMkhIWAicXXhZUYI
	W0ziwr31bF2MXBxCAosYJb7sv80I4fxllDiwfxEbSBWbgK7EsfVbWEFsEYFiiVNPzgLZHBzM
	ApES93+Jg5hCAtwSq5uDQCo4BXgk1v3pZAaxhQXMJVbNeAY2hUVAVeLdjA9gNq+AncS++zeh
	bEGJH5PvsYDYzAJaEut3HmeCsOUlNq95ywwyXkJAXeLRX12IA/wkfnUtZIUoEZHY9+Id4wRG
	oVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREc/c+kdzCuarA4
	xCjAwajEw3uiITVQiDWxrLgy9xCjBAezkggv106gEG9KYmVValF+fFFpTmrxIcZkoEcnMkuJ
	JucDE1NeSbyhsYmZkaWRmYWRibk5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTB2/u9b
	UFERyC49/dDu56n2oqw63cznCnLkKuZWP6mrZ5OK58qQS/a7VnpOwXn75+cOQifeHvsR9WZW
	6GK+BI5rxzkWyBwQTHZ5sSTLrMXpWV2deBa36815+74dUl/df2XbpxMP758pnR63qm228Fsl
	xU8rdFZPvh4deWHjEs1Qx1ChP7lh7MpKLMUZiYZazEXFiQBmekiJQgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hyp_hvc vector offset should be 0x14 and hyp_svc vector offset should be
0x8.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 arch/arm/kvm/interrupts.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
index 8ca87ab..a8e0c2d 100644
--- a/arch/arm/kvm/interrupts.S
+++ b/arch/arm/kvm/interrupts.S
@@ -235,9 +235,9 @@ ENTRY(kvm_call_hyp)
  * instruction is issued since all traps are disabled when running the host
  * kernel as per the Hyp-mode initialization at boot time.
  *
- * HVC instructions cause a trap to the vector page + offset 0x18 (see
hyp_hvc
+ * HVC instructions cause a trap to the vector page + offset 0x14 (see
hyp_hvc
  * below) when the HVC instruction is called from SVC mode (i.e. a guest or
the
- * host kernel) and they cause a trap to the vector page + offset 0xc when
HVC
+ * host kernel) and they cause a trap to the vector page + offset 0x8 when
HVC
  * instructions are called from within Hyp-mode.
  *
  * Hyp-ABI: Calling HYP-mode functions from host (in SVC mode):
-- 
1.7.9.5

