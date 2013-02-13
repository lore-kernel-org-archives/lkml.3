Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab3BMJfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:35:22 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:43568 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab3BMJfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:35:11 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-a5-511b5e4dd34d
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 2/9] extcon: max77693: Convert to devm_input_allocate_device()
Date: Wed, 13 Feb 2013 18:35:05 +0900
Message-id: <1360748105-21841-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t8zTV3fOOlAg8OzxC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGwbWbWQua2CpW/r7P1MA4gbWLkZNDQsBE4t+GXjYIW0ziwr31
	QDYXh5DAMkaJKd0LmWGK3jZcZQGxhQQWMUoc2OgJUbSASWLm4uNgCTYBLYn9L26ATRIRkJN4
	cvsPWDOzQK3E6ct3wWxhAT+J9lnb2UFsFgFVibW3PoPFeQVcJdY1TYG6Qk7iw55H7CALJAR2
	sEnMeQgxlEVAQOLb5ENAyziAErISmw5AHScpcXDFDZYJjIILGBlWMYqmFiQXFCel5xrqFSfm
	Fpfmpesl5+duYoSElNQOxpUNFocYBTgYlXh4HUKkAoVYE8uKK3MPMUpwMCuJ8Dr6SwcK8aYk
	VlalFuXHF5XmpBYfYkwGWj6RWUo0OR8Y7nkl8YbGBsaGhpaGZqaWpgakCSuJ8zKeehIgJJCe
	WJKanZpakFoEs4WJg1OqgXE1x+TUt/x+uYk87PH1al+e3nae5TrLxSy15c6rxX2TlQS/FLtP
	Pe0pt/aI48t79yffrX/iwLSd75VbbF6sQgAnO6v7a/vr6ZqGP7av+bavKaDOvrYkwzjyB8ei
	LyfWbWp8ztl24VfM5tVzT3Avvnmi4+KS2Y6bMrimJvOnPfu58NQqw52/PnMrsRRnJBpqMRcV
	JwIAzgTZiW0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+xgK5XnHSgwd+zxhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4+DazawFTWwVK3/fZ2pg
	nMDaxcjJISFgIvG24SoLhC0mceHeejYQW0hgEaPEgY2eXYxcQPYCJomZi4+DFbEJaEnsf3ED
	rEhEQE7iye0/zCA2s0CtxOnLd8FsYQE/ifZZ29lBbBYBVYm1tz6DxXkFXCXWNU1hg1gmJ/Fh
	zyP2CYzcCxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEB+wzqR2MKxssDjEKcDAq8fA6
	hEgFCrEmlhVX5h5ilOBgVhLhdfSXDhTiTUmsrEotyo8vKs1JLT7EmAy0fSKzlGhyPjCa8kri
	DY1NzIwsjcyMTcyNjUkTVhLnZTz1JEBIID2xJDU7NbUgtQhmCxMHp1QDY/Te6zs9Y/REu7IY
	XkU9+3DYvv71ow1+IR8OmXLtlOEtsL7yf3/tXd8EIa/Gd+9MZ+xv/JxZu0yUNaWPzVYnfZLL
	cslly6bfff9g8t7TM7MPBtp0nnhTKLPrbJrzOuNn1t+jCmdy3PzyfNWUsod3j7LvWK6yfdpU
	7cSm4DCDWxXv6z5477+nd1KJpTgj0VCLuag4EQDZsJEHnAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/extcon/extcon-max77693.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index a645268..3b1f238 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -1066,7 +1066,7 @@ static int max77693_muic_probe(struct platform_device *pdev)
 	}
 
 	/* Register input device for button of dock device */
-	info->dock = input_allocate_device();
+	info->dock = devm_input_allocate_device(&pdev->dev);
 	if (!info->dock) {
 		dev_err(&pdev->dev, "%s: failed to allocate input\n", __func__);
 		return -ENOMEM;
-- 
1.8.0

