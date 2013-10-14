Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab3JNIv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 04:51:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36901 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab3JNIv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 04:51:27 -0400
X-AuditID: cbfee68e-b7f756d000004512-35-525bb0870259
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Sascha Hauer'" <s.hauer@pengutronix.de>
References: <000001cec8b9$931f4c90$b95de5b0$%han@samsung.com>
In-reply-to: <000001cec8b9$931f4c90$b95de5b0$%han@samsung.com>
Subject: [PATCH 07/11] regulator: mc13892: Fix checkpatch issue
Date: Mon, 14 Oct 2013 17:51:19 +0900
Message-id: <000601cec8ba$8cef0530$a6cd0f90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7IuZK01KcLw1AZSDCREfGxHfkpOgAAMjzA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zA932DdFBBi2bLSymPnzCZnF54SVW
	i29XOpgsLu+aw2bxd/smFgdWj52z7rJ7bFrVyebR/9fAo2/LKkaPz5vkAlijuGxSUnMyy1KL
	9O0SuDJunlrIXvBPtGLRkRbWBsbFwl2MnBwSAiYSj5vuskDYYhIX7q1n62Lk4hASWMYosX//
	Z3aYopn3tjNDJKYzSrw538wI4fxilLjwpgusik1ATeLLl8NANgeHiICqxP9X7iA1zALTGCVW
	9b1lBqkRErCVuHv6EpjNKWAnsfDbLrDVwgL2EusvfQfrZQHq7V+tAhLmBSrfuOQ2O4QtKPFj
	8j2wcmYBLYn1O48zQdjyEpvXgIznADpUXeLRX12QsIiAkcSWsz3sECUiEvtevAM7WULgFrvE
	3iuPwXpZBAQkvk0+xALRKyux6QAzxL+SEgdX3GCZwCgxC8nmWUg2z0KyeRaSFQsYWVYxiqYW
	JBcUJ6UXGekVJ+YWl+al6yXn525ihMRp3w7GmwesDzEmA62fyCwlmpwPjPO8knhDYzMjC1MT
	U2Mjc0sz0oSVxHnVWqwDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTC2Jqh8uHPnZYJVWVv+
	NSPVvubJep1ne3dNmnvoyGbJVce8FmScK2FpYTNiZy3kCHZy6pv82OD5l5BPn8tsjJp9Hj9d
	zc2z5+5Rfp6F+26scL3ScNfd1O5nwo+JbIdSrpXuvWO9Xsb4ZveZRcK/zKdeM+leF7A682JZ
	5vwJYQdkL96Y4J0ScldIiaU4I9FQi7moOBEAZMHfa+kCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd32DdFBBtfXmFhMffiEzeLywkus
	Ft+udDBZXN41h83i7/ZNLA6sHjtn3WX32LSqk82j/6+BR9+WVYwenzfJBbBGNTDaZKQmpqQW
	KaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAtV1IoS8wpBQoFJBYX
	K+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm3Dy1kL3gn2jFoiMtrA2Mi4W7GDk5JARMJGbe
	284MYYtJXLi3nq2LkYtDSGA6o8Sb882MEM4vRokLb7rYQarYBNQkvnw5DGRzcIgIqEr8f+UO
	UsMsMI1RYlXfW7BJQgK2EndPXwKzOQXsJBZ+28UCYgsL2Eusv/QdrJcFqLd/tQpImBeofOOS
	2+wQtqDEj8n3wMqZBbQk1u88zgRhy0tsXgMyngPoUHWJR391QcIiAkYSW872sEOUiEjse/GO
	cQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAhOAs+kdzCu
	arA4xCjAwajEwyvgFB0kxJpYVlyZe4hRgoNZSYRXcB5QiDclsbIqtSg/vqg0J7X4EGMy0J8T
	maVEk/OBCSqvJN7Q2MTMyNLIzMLIxNycNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhi5
	dXx4P7w/eW3yN5au7uhlrYoLOa1E5nja1y04+NVgRfptn5nLbgV7TnnXfEnto8+z8BnuJiGu
	y2Oz2avSn8v//Nb2cZ390lgVfa9XUgpb4vevO/Ns3dQbl9my7pV2BTyd9OOcVOz1kCauSman
	+6UWiwt2GLYfZGidxrf++lWRe89fT0h5PD9LiaU4I9FQi7moOBEAjyZLrEYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following checkpatch warnings.

  WARNING: Avoid unnecessary line continuations
  WARNING: line over 80 characters

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/mc13892-regulator.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index 96c9f80..f374fa5 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -274,25 +274,25 @@ static struct mc13xxx_regulator mc13892_regulators[] = {
 	MC13892_SW_DEFINE(SW4, SWITCHERS3, SWITCHERS3, mc13892_sw),
 	MC13892_FIXED_DEFINE(SWBST, SWITCHERS5, mc13892_swbst),
 	MC13892_FIXED_DEFINE(VIOHI, REGULATORMODE0, mc13892_viohi),
-	MC13892_DEFINE_REGU(VPLL, REGULATORMODE0, REGULATORSETTING0,	\
+	MC13892_DEFINE_REGU(VPLL, REGULATORMODE0, REGULATORSETTING0,
 		mc13892_vpll),
-	MC13892_DEFINE_REGU(VDIG, REGULATORMODE0, REGULATORSETTING0,	\
+	MC13892_DEFINE_REGU(VDIG, REGULATORMODE0, REGULATORSETTING0,
 		mc13892_vdig),
-	MC13892_DEFINE_REGU(VSD, REGULATORMODE1, REGULATORSETTING1,	\
+	MC13892_DEFINE_REGU(VSD, REGULATORMODE1, REGULATORSETTING1,
 		mc13892_vsd),
-	MC13892_DEFINE_REGU(VUSB2, REGULATORMODE0, REGULATORSETTING0,	\
+	MC13892_DEFINE_REGU(VUSB2, REGULATORMODE0, REGULATORSETTING0,
 		mc13892_vusb2),
-	MC13892_DEFINE_REGU(VVIDEO, REGULATORMODE1, REGULATORSETTING1,	\
+	MC13892_DEFINE_REGU(VVIDEO, REGULATORMODE1, REGULATORSETTING1,
 		mc13892_vvideo),
-	MC13892_DEFINE_REGU(VAUDIO, REGULATORMODE1, REGULATORSETTING1,	\
+	MC13892_DEFINE_REGU(VAUDIO, REGULATORMODE1, REGULATORSETTING1,
 		mc13892_vaudio),
-	MC13892_DEFINE_REGU(VCAM, REGULATORMODE1, REGULATORSETTING0,	\
+	MC13892_DEFINE_REGU(VCAM, REGULATORMODE1, REGULATORSETTING0,
 		mc13892_vcam),
-	MC13892_DEFINE_REGU(VGEN1, REGULATORMODE0, REGULATORSETTING0,	\
+	MC13892_DEFINE_REGU(VGEN1, REGULATORMODE0, REGULATORSETTING0,
 		mc13892_vgen1),
-	MC13892_DEFINE_REGU(VGEN2, REGULATORMODE0, REGULATORSETTING0,	\
+	MC13892_DEFINE_REGU(VGEN2, REGULATORMODE0, REGULATORSETTING0,
 		mc13892_vgen2),
-	MC13892_DEFINE_REGU(VGEN3, REGULATORMODE1, REGULATORSETTING0,	\
+	MC13892_DEFINE_REGU(VGEN3, REGULATORMODE1, REGULATORSETTING0,
 		mc13892_vgen3),
 	MC13892_FIXED_DEFINE(VUSB, USB1, mc13892_vusb),
 	MC13892_GPO_DEFINE(GPO1, POWERMISC, mc13892_gpo),
@@ -476,8 +476,8 @@ static int mc13892_sw_regulator_set_voltage_sel(struct regulator_dev *rdev,
 	}
 
 	mc13xxx_lock(priv->mc13xxx);
-	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13892_regulators[id].vsel_reg, mask,
-			      reg_value);
+	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13892_regulators[id].vsel_reg,
+			      mask, reg_value);
 	mc13xxx_unlock(priv->mc13xxx);
 
 	return ret;
-- 
1.7.10.4


