Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbaFRFaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 01:30:25 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:27958 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbaFRFaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 01:30:23 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-2b-53a123eee373
From: Jingoo Han <jg1.han@samsung.com>
To: "'Chanwoo Choi'" <cw00.choi@samsung.com>
Cc: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Charles Keepax'" <ckeepax@opensource.wolfsonmicro.com>,
        "'Krzysztof Kozlowski'" <k.kozlowski@samsung.com>
Subject: [PATCH] extcon: Remove unnecessary OOM messages
Date: Wed, 18 Jun 2014 14:30:21 +0900
Message-id: <000401cf8ab6$6613d350$323b79f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+KtmXlpqSQ3jFeSEyhVZYM4WdN+g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t8zQ913yguDDda/5bD4N+UGu8X1L89Z
	LS4vvMRq8fqFocXlXXPYLG43rmBzYPN4OfE3m0ffllWMHp83yQUwR3HZpKTmZJalFunbJXBl
	HOnvYC04Llqxs3UBawNji1AXIyeHhICJxNS29UwQtpjEhXvr2boYuTiEBJYxSrS//cvexcgB
	VtS2QgOkRkhgOqPEgrecEDW/GSUaZ39lB0mwCahJfPlyGMwWEdCSmNg5kwmkiFngHqPEjEvv
	2UASwgIWEjtXfWICGcoioCpx8SAXSJhXwFbi9bYfrBC2oMSPyfdYQGxmoDnrdx5ngrDlJTav
	ecsMcY+6xKO/uhCr9CT23L/EClEiIrHvxTtGiF92sUu83Qc2hkVAQOLb5EMsEK2yEpsOMEOU
	SEocXHGDZQKj2Cwki2chWTwLyeJZSDYsYGRZxSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7iRES
	aX07GG8esD7EmAy0fiKzlGhyPjBS80riDY3NjCxMTUyNjcwtzUgTVhLnXfQwKUhIID2xJDU7
	NbUgtSi+qDQntfgQIxMHp1QDI+fqPWxfLRYX+bn637vxgYXjeFDk8knVjhUt77uyc9JaLvqV
	dTnP8vYKWZ7t/3rCTweJu/NfnH573jH+v8BehcV2vw3tf0xtzDw1efJ9CY0V2+IaOQzymZ4X
	Be87qvhkyivHo9t5oyW5584raMn6U27pdNVX//GJLukX9Qbr6u6ttYr8bLj2pBJLcUaioRZz
	UXEiAE1drMbKAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jQd13yguDDR48ZbH4N+UGu8X1L89Z
	LS4vvMRq8fqFocXlXXPYLG43rmBzYPN4OfE3m0ffllWMHp83yQUwRzUw2mSkJqakFimk5iXn
	p2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA7VVSKEvMKQUKBSQWFyvp22Ga
	EBripmsB0xih6xsSBNdjZIAGEtYxZhzp72AtOC5asbN1AWsDY4tQFyMHh4SAiUTbCo0uRk4g
	U0ziwr31bCC2kMB0RokFbzm7GLmA7N+MEo2zv7KDJNgE1CS+fDkMZosIaElM7JzJBFLELHCP
	UWLGpfdg3cICFhI7V31iAlnAIqAqcfEgF0iYV8BW4vW2H6wQtqDEj8n3WEBsZqA563ceZ4Kw
	5SU2r3nLDHGbusSjv7oQq/Qk9ty/xApRIiKx78U7xgmMArOQTJqFZNIsJJNmIWlZwMiyilE0
	tSC5oDgpPddIrzgxt7g0L10vOT93EyM4kp9J72Bc1WBxiFGAg1GJh5cjd0GwEGtiWXFl7iFG
	CQ5mJRHe90wLg4V4UxIrq1KL8uOLSnNSiw8xJgP9OZFZSjQ5H5hk8kriDY1NzIwsjcwsjEzM
	zUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBkWeGTMOeh3l6/3Z9UDz+Si07UmynCUPT
	y29zP8XP4T9kOKFN+z3PE8cyu5MzmEs327AmrZ3/8IH09J97OvI+npRmu6Cao2EeLCRo+8yR
	t7+Zi2cF0/SXO9q+7XT2mnHtwIZo4Y7jt5wbIpxsw24c5GT6ri+iNLknvUe2bp/kjKl+S14Y
	33j4UImlOCPRUIu5qDgRAEt+M8woAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The site-specific OOM messages are unnecessary, because they
duplicate the MM subsystem generic OOM message. The following
checkpatch warning is also removed.

  WARNING: Possible unnecessary 'out of memory' message

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/extcon/extcon-arizona.c  |    4 +---
 drivers/extcon/extcon-max14577.c |    5 ++---
 drivers/extcon/extcon-max77693.c |    5 ++---
 drivers/extcon/extcon-max8997.c  |    4 +---
 4 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 6c84e3d..90223a3 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -1103,10 +1103,8 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 		return -EPROBE_DEFER;
 
 	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
-	if (!info) {
-		dev_err(&pdev->dev, "Failed to allocate memory\n");
+	if (!info)
 		return -ENOMEM;
-	}
 
 	info->micvdd = devm_regulator_get(arizona->dev, "MICVDD");
 	if (IS_ERR(info->micvdd)) {
diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
index d49e891..7309743 100644
--- a/drivers/extcon/extcon-max14577.c
+++ b/drivers/extcon/extcon-max14577.c
@@ -692,10 +692,9 @@ static int max14577_muic_probe(struct platform_device *pdev)
 	u8 id;
 
 	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
-	if (!info) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
+	if (!info)
 		return -ENOMEM;
-	}
+
 	info->dev = &pdev->dev;
 	info->max14577 = max14577;
 
diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 2c7c3e1..47998a2 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -1099,10 +1099,9 @@ static int max77693_muic_probe(struct platform_device *pdev)
 
 	info = devm_kzalloc(&pdev->dev, sizeof(struct max77693_muic_info),
 				   GFP_KERNEL);
-	if (!info) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
+	if (!info)
 		return -ENOMEM;
-	}
+
 	info->dev = &pdev->dev;
 	info->max77693 = max77693;
 	if (info->max77693->regmap_muic) {
diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index d9f7f1b..045e230 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -661,10 +661,8 @@ static int max8997_muic_probe(struct platform_device *pdev)
 
 	info = devm_kzalloc(&pdev->dev, sizeof(struct max8997_muic_info),
 			    GFP_KERNEL);
-	if (!info) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
+	if (!info)
 		return -ENOMEM;
-	}
 
 	info->dev = &pdev->dev;
 	info->muic = max8997->muic;
-- 
1.7.10.4


