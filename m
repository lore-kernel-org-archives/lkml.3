Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab3JNIoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 04:44:23 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35697 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab3JNIoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 04:44:22 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-1c-525baee46f39
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 01/11] regulator: core: Fix checkpatch issue
Date: Mon, 14 Oct 2013 17:44:20 +0900
Message-id: <000001cec8b9$931f4c90$b95de5b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7IuZK01KcLw1AZSDCREfGxHfkpOg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zY90n66KDDKZ0KlpMffiEzeLywkus
	Ft+udDBZXN41h82BxWPnrLvsHptWdbJ59G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8aZLU8Y
	C37yVkx8fomtgfE7VxcjJ4eEgInE9tvL2CFsMYkL99azdTFycQgJLGOU2LN3OiNM0f+tz6ES
	ixglblx4ANYhJPCLUeLfW30Qm01ATeLLl8NAcQ4OEQFVif+v3EFMZoFcie5t6SAVwgI2Erfa
	vzGD2CxAFb/2vGEFsXkFbCVWNX1lg7AFJX5MvscCYjMLaEms33mcCcKWl9i85i0zyEgJAXWJ
	R391IRbpSbxoFoaoEJHY9+IdI8iREgKb2CUW3V3BBrFKQOLb5EMsEK2yEpsOMEM8JSlxcMUN
	lgmMYrOQLJ6FZPEsJItnIVmxgJFlFaNoakFyQXFSepGxXnFibnFpXrpecn7uJkZIfPXvYLx7
	wPoQYzLQ+onMUqLJ+cD4zCuJNzQ2M7IwNTE1NjK3NCNNWEmcV63FOlBIID2xJDU7NbUgtSi+
	qDQntfgQIxMHp1QDo956TYUF5d1fptZZ3XRYq3IuLS4zyyomrOzvtStxJcWtX7q2SL04c1Bl
	6t+V2c+3Xymaf7XxaMs0C4f1rq7Ja/rqj/UfWp+VYcC5UX6LuPNliRw344p+p8/KZ4/O8Dzy
	64MlT//bdle2/kffvq960WSgsYDTMive8YbLUo0Hl3P9fWJ0Xyg1KbEUZyQaajEXFScCAJoY
	CPvFAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xgO6TddFBBsfuylhMffiEzeLywkus
	Ft+udDBZXN41h82BxWPnrLvsHptWdbJ59G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhHWPGmS1PGAt+8lZMfH6JrYHxO1cXIyeHhICJxP+tz9kgbDGJC/fW
	A9lcHEICixglblx4wA6SEBL4xSjx760+iM0moCbx5cthoDgHh4iAqsT/V+4gJrNArkT3tnSQ
	CmEBG4lb7d+YQWwWoIpfe96wgti8ArYSq5q+skHYghI/Jt9jAbGZBbQk1u88zgRhy0tsXvOW
	GWSkhIC6xKO/uhCL9CReNAtDVIhI7HvxjnECo8AsJINmIRk0C8mgWUhaFjCyrGIUTS1ILihO
	Ss811CtOzC0uzUvXS87P3cQIjt5nUjsYVzZYHGIU4GBU4uEVcIoOEmJNLCuuzD3EKMHBrCTC
	KzgPKMSbklhZlVqUH19UmpNafIgxGejPicxSosn5wMSSVxJvaGxiZmRpZGZhZGJuTpqwkjjv
	gVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MgXurpkxT6/Wym5ByJr6zeZ200uKog05sm1mKo2y0
	hc9PznpwUMz1xi/xz8X23LdLLl09U7b7S+0nUeFHxb4n4u6smtzU6/P2dNVK7+JZ8TdKQmQv
	3n5zQkD+e6Fqxqowh+dRNp3z+BfPao4MXzbfxvRg28QVEz5qf+rd7L1qcdWav0r7M2dyKrEU
	ZyQaajEXFScCAEY9y1AiAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following checkpatch errors and warnings.

  ERROR: trailing whitespace
  WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/core.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 13263d1..e8ccf20 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1287,9 +1287,8 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
 	 * If we have return value from dev_lookup fail, we do not expect to
 	 * succeed, so, quit with appropriate error value
 	 */
-	if (ret && ret != -ENODEV) {
+	if (ret && ret != -ENODEV)
 		goto out;
-	}
 
 	if (!devname)
 		devname = "deviceless";
@@ -2238,7 +2237,7 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 	ret = regulator_check_voltage(rdev, &min_uV, &max_uV);
 	if (ret < 0)
 		goto out;
-	
+
 	/* restore original values in case of error */
 	old_min_uV = regulator->min_uV;
 	old_max_uV = regulator->max_uV;
@@ -2252,7 +2251,7 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 	ret = _regulator_do_set_voltage(rdev, min_uV, max_uV);
 	if (ret < 0)
 		goto out2;
-	
+
 out:
 	mutex_unlock(&rdev->mutex);
 	return ret;
@@ -3657,9 +3656,8 @@ static int __init regulator_init_complete(void)
 			 * goes wrong. */
 			rdev_info(rdev, "disabling\n");
 			ret = ops->disable(rdev);
-			if (ret != 0) {
+			if (ret != 0)
 				rdev_err(rdev, "couldn't disable: %d\n", ret);
-			}
 		} else {
 			/* The intention is that in future we will
 			 * assume that full constraints are provided
-- 
1.7.10.4


