Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab3IPE4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 00:56:49 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56364 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab3IPE4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 00:56:46 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-a6-52368f8b9660
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jens Axboe'" <axboe@kernel.dk>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000101ceb299$03b50b20$0b1f2160$%han@samsung.com>
In-reply-to: <000101ceb299$03b50b20$0b1f2160$%han@samsung.com>
Subject: [PATCH 2/2] block: sx8: remove unnecessary pci_set_drvdata()
Date: Mon, 16 Sep 2013 13:56:42 +0900
Message-id: <000201ceb299$232faaf0$698f00d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6ymQNolKFi0ZN3SoCAKtWb5a/8NwAAAwDQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zI93ufrMgg1crpCzmrF/DZrH6bj+b
	xeWFl1gtLu+aw+bA4nH5bKnHiRm/WTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr49fJZ0wF
	c1gr/uw4xNjAuJSli5GTQ0LARGLLlRuMELaYxIV769m6GLk4hASWMUo0TpzMBlP0YOpZZojE
	dEaJGau7oZxfjBKfThxjAqliE1CT+PLlMHsXIweHiIC+RFuLBkiYWSBNouH/drANQgK2EtP3
	bWAFsTkF7CSOr54CtkBYwFVi76lrYHEWAVWJl7NeMYPYvED1R568ZoewBSV+TL7HAjFTS2L9
	zuNMELa8xOY1b5lB1koIqEs8+qsLcYGRxNfeJIgKEYl9L94xglwsIXCKXaL34GomiFUCEt8m
	H2KBaJWV2HSAGeJdSYmDK26wTGCUmIVk8Swki2chWTwLyYoFjCyrGEVTC5ILipPSi0z0ihNz
	i0vz0vWS83M3MUIicsIOxnsHrA8xJgOtn8gsJZqcD4zovJJ4Q2MzIwtTE1NjI3NLM9KElcR5
	1VusA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwCs5ZLP/hnpKqVb8pS0bdQsFmSbdc2z3W
	f2pN4sw5uZXsOn905HSl8ik+fPDhkPOiNov8/ptiTr8/lpw8PEc0yCE8yLHiaG/hp717V966
	cWUvj9KlPUybX+lWbWg4t/JCi/eTueYC1wJsS78eOJYbVaadeuVQqRnX81fTu/ebSG5ZJK3W
	YsqmxFKckWioxVxUnAgAYgyCp94CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jQd3ufrMgg88HxSzmrF/DZrH6bj+b
	xeWFl1gtLu+aw+bA4nH5bKnHiRm/WTz6tqxi9Pi8SS6AJaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMePXyWdMBXNYK/7sOMTYwLiUpYuRk0NCwETiwdSzzBC2mMSFe+vZ
	uhi5OIQEpjNKzFjdzQzh/GKU+HTiGBNIFZuAmsSXL4fZuxg5OEQE9CXaWjRAwswCaRIN/7cz
	gthCArYS0/dtYAWxOQXsJI6vnsIGYgsLuErsPXUNLM4ioCrxctYrsMW8QPVHnrxmh7AFJX5M
	vscCMVNLYv3O40wQtrzE5jVvmUHWSgioSzz6qwtxgZHE194kiAoRiX0v3jFOYBSahWTQLCSD
	ZiEZNAtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwfH+THoH46oGi0OMAhyMSjy8
	BppmQUKsiWXFlbmHGCU4mJVEeKP9gEK8KYmVValF+fFFpTmpxYcYk4H+nMgsJZqcD0xFeSXx
	hsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAuEXgROnq75vyTop5
	5ptMdk130rm2fIqpOZPW7x+tDdcWpCy5fPS0fYNFINv/ByFNMbm8Uhe07WVUlr5aI3dg3qGP
	iRey1pwvuVgbErC74dHi9nnc6bJxiw3fPLA/EPVolu+lkq67eU//Lf9qrTnBJeuhQHXfrEx7
	1YMXJCqr/k859zV83Y/vvkosxRmJhlrMRcWJAIFhmlE7AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/block/sx8.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
index 7b2ac95..d5e2d12 100644
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -1744,7 +1744,6 @@ static void carm_remove_one (struct pci_dev *pdev)
 	kfree(host);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
 }
 
 module_pci_driver(carm_driver);
-- 
1.7.10.4


