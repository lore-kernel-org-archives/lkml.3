Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383Ab3HTHEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:04:45 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16183 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3HTHEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:04:44 -0400
X-AuditID: cbfee68e-b7f276d000002279-89-5213150a94e0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 2/6] mfd: max8998: use devm_*() functions
Date: Tue, 20 Aug 2013 16:04:42 +0900
Message-id: <005601ce9d73$8b55a9d0$a200fd70$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6dc2U89w/mQScDQtCxAwkJbo5izA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zI10uUeEgg1sn9C0uL7zEanH/61FG
	i8u75rBZnO5mdWDxuHNtD5vHvJOBHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJXx7E8Xe8FO
	jopbCxexNjD+ZOti5OSQEDCRWPZgAxOELSZx4d56oDgXh5DAMkaJJU962WGKLu+ZzAKRmM4o
	Men7cyYI5xejRMPLdlaQKjYBNYkvXw4DdXBwiAj4STSsAGtmFnCS+LllJguILSxgKbFy6X6w
	bSwCqhILLk8Gu4IXKL5z7hN2CFtQ4sfkeywQvVoS63ceZ4Kw5SU2r3nLDHGQgsSOs68ZIVbp
	Sbz8IARRIiKx78U7RpDTJARWsUtcf/2YGWKXgMS3yYdYQOolBGQlNh2AGiMpcXDFDZYJjGKz
	kGyehWTzLCSbZyFZsYCRZRWjaGpBckFxUnqRkV5xYm5xaV66XnJ+7iZGSIT17WC8ecD6EGMy
	0PqJzFKiyfnACM0riTc0NjOyMDUxNTYytzQjTVhJnFetxTpQSCA9sSQ1OzW1ILUovqg0J7X4
	ECMTB6dUA+O6/nPZEXdXX37LK8TB+UCw6V3O1euP4zdETq9ezry3TzPvtvCXq/sLIz73nFja
	JvohvW1+1Jumzv/sD3+9LlON/FCUoFo57bvd8b1HJ2dbKbZrNM054tKgU55ta+hx/d5zsQ6n
	fyHxQkf6Nmc+uR8lHjrh5tNFWxfsFloVWv4t5qe/vm7/v24lluKMREMt5qLiRABfbHkBxgIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jQV0uUeEggyk3tS0uL7zEanH/61FG
	i8u75rBZnO5mdWDxuHNtD5vHvJOBHn1bVjF6fN4kF8AS1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvh2lCaIibrgVM
	Y4Sub0gQXI+RARpIWMeY8exPF3vBTo6KWwsXsTYw/mTrYuTkkBAwkbi8ZzILhC0mceHeeqA4
	F4eQwHRGiUnfnzNBOL8YJRpetrOCVLEJqEl8+XKYvYuRg0NEwE+iYQU7SJhZwEni55aZYIOE
	BSwlVi7dzwRiswioSiy4PBlsGS9QfOfcJ+wQtqDEj8n3WCB6tSTW7zzOBGHLS2xe85YZ4iAF
	iR1nXzNCrNKTePlBCKJERGLfi3eMExgFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rqFe
	cWJucWleul5yfu4mRnD8PpPawbiyweIQowAHoxIPb6eSUJAQa2JZcWXuIUYJDmYlEV6X/0Ah
	3pTEyqrUovz4otKc1OJDjMlAj05klhJNzgemlrySeENjEzMjSyMzCyMTc3PShJXEeQ+0WgcK
	CaQnlqRmp6YWpBbBbGHi4JRqYHSSWPZsZ0zZraawO3KJXN9Lrz8+UN3LtnPR9CkCtyPvbPtg
	sfFxkfjSPTqvlxfMkXvdoGeaMK92WcIBwfhYi5eWEi5iO+Jmzo/aMlnOW+M2P8Mi85PH50xr
	2XzJ7/JF4SsSGpzL23O2Ts2stylp9nQxCZeeEenZ33e39y7v3t0Gdk6Fp1P5BJRYijMSDbWY
	i4oTAcN6S0IjAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/max8998.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
index 45bffb8..fe6332d 100644
--- a/drivers/mfd/max8998.c
+++ b/drivers/mfd/max8998.c
@@ -188,7 +188,8 @@ static int max8998_i2c_probe(struct i2c_client *i2c,
 	struct max8998_dev *max8998;
 	int ret = 0;
 
-	max8998 = kzalloc(sizeof(struct max8998_dev), GFP_KERNEL);
+	max8998 = devm_kzalloc(&i2c->dev, sizeof(struct max8998_dev),
+				GFP_KERNEL);
 	if (max8998 == NULL)
 		return -ENOMEM;
 
@@ -246,7 +247,6 @@ err:
 	mfd_remove_devices(max8998->dev);
 	max8998_irq_exit(max8998);
 	i2c_unregister_device(max8998->rtc);
-	kfree(max8998);
 	return ret;
 }
 
@@ -257,7 +257,6 @@ static int max8998_i2c_remove(struct i2c_client *i2c)
 	mfd_remove_devices(max8998->dev);
 	max8998_irq_exit(max8998);
 	i2c_unregister_device(max8998->rtc);
-	kfree(max8998);
 
 	return 0;
 }
-- 
1.7.10.4


