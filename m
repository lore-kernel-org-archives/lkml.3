Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaDUJhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:37:22 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60998 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbaDUJg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:36:28 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-9c-5354e6978c9d
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, gg@slimlogic.co.uk, kishon@ti.com, balbi@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        sangjung.woo@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 3/9] extcon: max8997: Use devm_extcon_dev_allocate for
 extcon_dev
Date: Mon, 21 Apr 2014 18:36:20 +0900
Message-id: <1398072986-17386-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398072986-17386-1-git-send-email-cw00.choi@samsung.com>
References: <1398072986-17386-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42JZI2JSojv9WUiwwaYbRhYH79dbTH34hM3i
	35Qb7BbXvzxntejf4mLx+oWhxYWnPWwWZ5vesFtc3jWHzeJ24wo2iwV7Shy4PTat6mTzeDnx
	N5tH35ZVjB5Tp/xl9Dh+YzuTx+dNcgFsUVw2Kak5mWWpRfp2CVwZlz82sRXM5KzY+rOugfE+
	excjJ4eEgInE7oePmCBsMYkL99azdTFycQgJLGWUaPnznAmm6PybXlYQW0hgEaPEsQZGiKIm
	Jomfv16AJdgEtCT2v7jBBmKLCChIbO59xgpSxCzQwCQx59MCsEnCAsES0x7uZgaxWQRUJdp/
	7gOKc3DwCrhKzN3jD7FMTuLDnkdg13EKuEms+9ENtdhVouN9H9hiCYFd7BKnD15nh5gjIPFt
	8iEWkDkSArISmw4wQ8yRlDi44gbLBEbhBYwMqxhFUwuSC4qT0otM9YoTc4tL89L1kvNzNzEC
	4+H0v2cTdzDeP2B9iDEZaNxEZinR5HxgPOWVxBsamxlZmJqYGhuZW5qRJqwkzpv+KClISCA9
	sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6P+r6pLDX/fb/+zo8Bgq7v6PqlHMtn3jgZabr7A8z5d
	+eRlgUf3zX/qPWZ4sXqJxIb8e2IaO1T+M3yVUlZc33Op+kucxMS2V3ONZbwzLyrs0F1awaSV
	sE2AcX1pS21Y5vdp5fFRWa+V3pryq9Tt9prO8GhpQMueG/+Fm87H8V67NCHv4e5Nv/8osRRn
	JBpqMRcVJwIAbhUrC50CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t9jAd3pz0KCDTYd1bY4eL/eYurDJ2wW
	/6bcYLe4/uU5q0X/FheL1y8MLS487WGzONv0ht3i8q45bBa3G1ewWSzYU+LA7bFpVSebx8uJ
	v9k8+rasYvSYOuUvo8fxG9uZPD5vkgtgi2pgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw
	1DW0tDBXUshLzE21VXLxCdB1y8wBOk5JoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyP
	kQEaSFjDmHH5YxNbwUzOiq0/6xoY77N3MXJySAiYSJx/08sKYYtJXLi3ng3EFhJYxChxrIGx
	i5ELyG5ikvj56wVYEZuAlsT+FzfAikQEFCQ29z5jBSliFmhgkpjzaQETSEJYIFhi2sPdzCA2
	i4CqRPvPfUBxDg5eAVeJuXv8IZbJSXzY8wjsCE4BN4l1P7pZIRa7SnS872OcwMi7gJFhFaNo
	akFyQXFSeq6RXnFibnFpXrpecn7uJkZwtD2T3sG4qsHiEKMAB6MSD++L/JBgIdbEsuLK3EOM
	EhzMSiK8EeuBQrwpiZVVqUX58UWlOanFhxiTgY6ayCwlmpwPTAR5JfGGxiZmRpZG5oYWRsbm
	pAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cCYLif17lDRXbMt1ewLT7Wv0S19+P/IVm/l
	Z9U/o3/P4FI8szlrtvIafpljezY29VWGuiglZqU4yJ95VThd6klQO1+Mnd+/KSLfW8X/1Z2Q
	mtPpO/O7xntlliXnv0eosas1TfsRldzbv/gvm9tRRSH5oN2z3Jz+epsquatudGsyTVmkLfot
	9ZQSS3FGoqEWc1FxIgANGw7O+gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use devm_extcon_dev_allocate() to simplify the memory control
of extcon device.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-max8997.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 223e6b0..15580f2 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -699,8 +699,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
 	}
 
 	/* External connector */
-	info->edev = devm_kzalloc(&pdev->dev, sizeof(struct extcon_dev),
-				  GFP_KERNEL);
+	info->edev = devm_extcon_dev_allocate(&pdev->dev, max8997_extcon_cable);
 	if (!info->edev) {
 		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
 		ret = -ENOMEM;
@@ -708,7 +707,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
 	}
 	info->edev->name = DEV_NAME;
 	info->edev->dev.parent = &pdev->dev;
-	info->edev->supported_cable = max8997_extcon_cable;
+
 	ret = extcon_dev_register(info->edev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
-- 
1.8.0

