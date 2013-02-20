Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963Ab3BTGJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 01:09:30 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:36764 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758939Ab3BTGJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 01:09:29 -0500
X-AuditID: cbfee68e-b7fc26d000001938-af-512468976ec4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 01/11] mfd: 88pm860x: drop devm_kfree of devm_kzalloc'd data
Date: Wed, 20 Feb 2013 15:09:27 +0900
Message-id: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4PMNZl2zNDd+kPTaydPUTuUPUSLQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t8zI93pGSqBBttfG1hc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MHbunshZs56qY9vIPSwPjJo4uRk4OCQETiUs357BC2GISF+6t
	Z+ti5OIQEljGKNHzeiVzFyMHWFHvfhWI+HRGifNHl7JDOLOZJDat28oG0s0moCbx5cthdhBb
	REBLovvYeTaQZmYBF4mj00RAwsICPhInZrWCLWMRUJV49nwjM4jNK2Ar8fHICVYIW1Dix+R7
	LCA2M9CY9TuPM0HY8hKb17yFukdd4tFfXYhNehLbL/9ghygRkdj34h0jyGkSAt3sEpfeLWWE
	2CUg8W3yIRaIXlmJTQeYIf6VlDi44gbLBEaxWUg2z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCm9
	yEivODG3uDQvXS85P3cTIyRO+nYw3jxgfYgxGWj9RGYp0eR8YJzllcQbGhubmJmYmphbmpqb
	kiasJM4rf0kmUEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOj8DfF4htxE0q/RcsqvckWFN17
	4bGf69yeX7/WH1Dd+kdke9D3yEaZ7F7f+24Ty/7WbDI1DTk066vKtz+rY7urw3z8njhtDDd4
	9+/+qtm5m+ZsvBIhPkO586RwUrH13qsTvBavi1w/NaakXX7FveuPH2/L5mAoTVgm86JF9S1n
	uoDAJM1rRncmK7EUZyQaajEXFScCAAK+rzqpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jQd3pGSqBBh29OhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY8fuqawF27kqpr38w9LA
	uImji5GDQ0LARKJ3v0oXIyeQKSZx4d56ti5GLg4hgemMEuePLmWHcGYzSWxat5UNpIpNQE3i
	y5fD7CC2iICWRPex82wgg5gFXCSOThMBCQsL+EicmNXKCmKzCKhKPHu+kRnE5hWwlfh45AQr
	hC0o8WPyPRYQmxlozPqdx5kgbHmJzWveMkPcpi7x6K8uxCY9ie2Xf7BDlIhI7HvxjnECo8As
	JJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjsJn0jsYVzVYHGIU
	4GBU4uFtWKgcKMSaWFZcmXuIUYKDWUmEt9lJJVCINyWxsiq1KD++qDQntfgQYzLQoxOZpUST
	84EJIq8k3tDYxMzI0sjMwsjE3Jw0YSVxXsZTTwKEBNITS1KzU1MLUotgtjBxcEo1MJpMCZJJ
	ldb5/6irWF653Gy5U+rBa3dTaqsObHNQO3R/0b0L0g9Opb4QKV13TN2HY3dtwckT+6osji9Y
	YeqtdXPT/5c94goL/edG5uX/OhO6vOLK4bI7UetuVOb/medX/UJCa+nCFpMlC/L8dbqPMSVU
	7j2ROd2n/hWvXcqsO6Wctx98XvxJ/YwSS3FGoqEWc1FxIgBcuJIbBgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_kfree() allocates memory that is released when a driver detaches.
Thus, there is no reason to explicitly call devm_kfree() in probe or remove
functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/88pm860x-core.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index 893fc1b..31ca555 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -1144,17 +1144,15 @@ static int pm860x_probe(struct i2c_client *client,
 			return -ENOMEM;
 		ret = pm860x_dt_init(node, &client->dev, pdata);
 		if (ret)
-			goto err;
+			return ret;
 	} else if (!pdata) {
 		pr_info("No platform data in %s!\n", __func__);
 		return -EINVAL;
 	}
 
 	chip = kzalloc(sizeof(struct pm860x_chip), GFP_KERNEL);
-	if (chip == NULL) {
-		ret = -ENOMEM;
-		goto err;
-	}
+	if (chip == NULL)
+		return -ENOMEM;
 
 	chip->id = verify_addr(client);
 	chip->regmap = regmap_init_i2c(client, &pm860x_regmap_config);
@@ -1194,10 +1192,6 @@ static int pm860x_probe(struct i2c_client *client,
 
 	pm860x_device_init(chip, pdata);
 	return 0;
-err:
-	if (node)
-		devm_kfree(&client->dev, pdata);
-	return ret;
 }
 
 static int pm860x_remove(struct i2c_client *client)
-- 
1.7.2.5


