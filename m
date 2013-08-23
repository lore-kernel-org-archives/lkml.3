Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab3HWBVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 21:21:53 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:11040 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab3HWBVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 21:21:51 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-40-5216b92d309e
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        gregkh@linuxfoundation.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 2/3] extcon: class: Remove unnecessary extern declaration
Date: Fri, 23 Aug 2013 10:21:38 +0900
Message-id: <1377220899-4367-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1377220899-4367-1-git-send-email-cw00.choi@samsung.com>
References: <1377220899-4367-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsWyRsSkWFd3p1iQwe3NWhbXvzxntWhevJ7N
	4mzTG3aLy7vmsFncblzB5sDqsX/uGnaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyvg68Sdr
	wUK2imcH1rE1MC5j7WLk5JAQMJE4/fk4lC0mceHeejYQW0hgKaPEn4+2MDVHLj4FinMBxacz
	SjxefpYZwmlkknhzdSoLSBWbgJbE/hc3wLpFBBQkNvc+A5vKLFAt8f/NI3YQW1jAU+L00Stg
	NouAqsTiiz/A6nkFXCS2X1sCdYWcxIc9EPWcAq4SvX9amCEucpGYtGA3K8hiCYHvbBILHh5n
	gRgkIPFt8iEgmwMoISux6QAzxBxJiYMrbrBMYBRewMiwilE0tSC5oDgpvchQrzgxt7g0L10v
	OT93EyMwfE//e9a7g/H2AetDjMlA4yYyS4km5wPDP68k3tDYzMjC1MTU2Mjc0ow0YSVxXrUW
	60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjJzyblwld69rXPexY52hw8QsLDrZvC/c4Kl5
	wKK/+xdMOL5JZGrLeU7Tx+J9RpYpTWoH9f5Nnf/9xWXzUqEaRjvXoJVzbO9vyJ6lu7VKyNKv
	1GxFC2/ALMv19mpuhQ6zYtdKJf7UfaXzeqJqwVzlmZ8W/Yo8aDs9mGPblshfYavj3jT/YQqQ
	VGIpzkg01GIuKk4EAMbPVxx1AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t9jQV3dnWJBBq/eKFtc//Kc1aJ58Xo2
	i7NNb9gtLu+aw2Zxu3EFmwOrx/65a9g9+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/d
	Vsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2inkkJZYk4pUCggsbhYSd8O04TQEDdd
	C5jGCF3fkCC4HiMDNJCwhjHj68SfrAUL2SqeHVjH1sC4jLWLkZNDQsBE4sjFp2wQtpjEhXvr
	gWwuDiGB6YwSj5efZYZwGpkk3lydygJSxSagJbH/xQ2wDhEBBYnNvc/AJjELVEv8f/OIHcQW
	FvCUOH30CpjNIqAqsfjiD7B6XgEXie3XlkBtlpP4sAeinlPAVaL3TwsziC0EVDNpwW7WCYy8
	CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx8cz6R2MqxosDjEKcDAq8fBOcBYLEmJN
	LCuuzD3EKMHBrCTCa7MKKMSbklhZlVqUH19UmpNafIgxGeiqicxSosn5wNjNK4k3NDYxM7I0
	Mje0MDI2J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQZG75mJ+nYCK/VPe2vVNsukTrLb
	YXvmK9//A4eXuJ/haHn86U7uf6sqlQPnbvs8Lld6nPL5mM2HtGVbz6pKJ33Z6NdQ6jgj7vfl
	BQGOK+9dfMZgdoj3l9a35Qomm+UjLLyf57gySCeHvJvQ9i910pmn+9M+i7+Z9EPqgP4Ch5yq
	cOMl3Zw6nq9XKbEUZyQaajEXFScCAMh2V2bTAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove unnecessary extern declaration (extcon_set_state).
checkpatch found this coding style issue.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/extcon/extcon-class.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 7704a3d..b8589cc 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -129,7 +129,6 @@ static ssize_t state_show(struct device *dev, struct device_attribute *attr,
 	return count;
 }
 
-int extcon_set_state(struct extcon_dev *edev, u32 state);
 static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 			   const char *buf, size_t count)
 {
-- 
1.8.0

