Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381Ab3HMNiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:38:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:43449 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932572Ab3HMNh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:37:26 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-76-520a3694cce0
From: Sangjung Woo <sangjung.woo@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sangjung Woo <sangjung.woo@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>, linux-kernel@vger.kernel.org,
        Myugnjoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] drivers/rtc/rtc-max77686.c: Fix wrong register
Date: Tue, 13 Aug 2013 22:37:12 +0900
Message-id: <1376401032-31244-1-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsWyRsSkWHeKGVeQwYROfos569ewWXSefcJs
	cXnXHDaL240r2CwW7ClxYPU4MeM3i0ffllWMHp83yQUwR3HZpKTmZJalFunbJXBlTFsUVDCf
	veLUlstMDYw9bF2MnBwSAiYSM/7fZ4WwxSQu3FsPFOfiEBJYyigx/9R+Jpiijy9b2SES0xkl
	tpyaCFXVxiSxYc1/sCo2AV2JJwcuM4PYIkD2que7wGxmgXmMEhtfeoLYwgL2EnOP7WEBsVkE
	VCU6F3aD1fAKeEisv3WTsYuRA2ibgsScSTYg8yUEHrNJzGv5xw5RLyDxbfIhFogaWYlNB5gh
	jpOUOLjiBssERsEFjAyrGEVTC5ILipPSiwz1ihNzi0vz0vWS83M3MQJD8fS/Z707GG8fsD7E
	mAw0biKzlGhyPjCU80riDY3NjCxMTUyNjcwtzUgTVhLnVWuxDhQSSE8sSc1OTS1ILYovKs1J
	LT7EyMTBKdXAyPs3z/0UbzPX6nV7Tz05uH3Zvkgex560Z5sYK1Q/XnE80LTo/D5jmQC/n9e/
	O6cGxZz60+StGWPzNqJLVXbDrjeTZOwNP50/vsOj48yz7r9qG8Mu/JSym3E0z1Y0/3vTW7Pz
	YYuurTWOvSdyxyr11b8MWXv2Yh2vM3e2HtJSigyduvTZ8eAfa5VYijMSDbWYi4oTAfrejjVb	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t9jQd0pZlxBBjfPs1vMWb+GzaLz7BNm
	i8u75rBZ3G5cwWaxYE+JA6vHiRm/WTz6tqxi9Pi8SS6AOaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCGMWPaoqCC+ewVp7ZcZmpg7GHrYuTkkBAwkfj4spUdwhaTuHBvPVCc
	i0NIYDqjxJZTE6GcNiaJDWv+M4FUsQnoSjw5cJkZxBYBslc93wVmMwvMY5TY+NITxBYWsJeY
	e2wPC4jNIqAq0bmwG6yGV8BDYv2tm4xdjBxA2xQk5kyymcDIvYCRYRWjaGpBckFxUnqukV5x
	Ym5xaV66XnJ+7iZGcKA/k97BuKrB4hCjAAejEg9vxkeOICHWxLLiytxDjBIczEoivHGMXEFC
	vCmJlVWpRfnxRaU5qcWHGJOBlk9klhJNzgdGYV5JvKGxiZmRpZG5oYWRsTlpwkrivAdbrQOF
	BNITS1KzU1MLUotgtjBxcEo1MG5edCdyv3OW4Ssbx0+fWwVZdF5/Yc45+32O0hMTntS5Gd9e
	TzTVjNtjdPbZd4X3LAf1juvnVBwqEeneqHJ9UeM1tlMyM55PcDpzwVYg1zdv07eQ1m8PJpq2
	Tk74dT3jVnGf++QJgqV/wr64b9+leZLJ/mJr6n7uH/ss0rczC+xTK2Y7Uer+JleJpTgj0VCL
	uag4EQA5Y5WYuAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix to read the wrong register when cheching whether the RTC timer has
reached or not.

Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
Signed-off-by: Myugnjoo Ham <myungjoo.ham@samsung.com>
Reviewed-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/rtc/rtc-max77686.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
index 9915cb9..a1140c8 100644
--- a/drivers/rtc/rtc-max77686.c
+++ b/drivers/rtc/rtc-max77686.c
@@ -240,7 +240,7 @@ static int max77686_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	}
 
 	alrm->pending = 0;
-	ret = regmap_read(info->max77686->regmap, MAX77686_REG_STATUS1, &val);
+	ret = regmap_read(info->max77686->regmap, MAX77686_REG_STATUS2, &val);
 	if (ret < 0) {
 		dev_err(info->dev, "%s:%d fail to read status1 reg(%d)\n",
 				__func__, __LINE__, ret);
-- 
1.7.9.5

