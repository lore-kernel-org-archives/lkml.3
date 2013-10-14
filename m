Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab3JNItN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 04:49:13 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:51278 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3JNItM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 04:49:12 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-28-525bb0072068
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'MyungJoo Ham'" <myungjoo.ham@samsung.com>
References: <000001cec8b9$931f4c90$b95de5b0$%han@samsung.com>
In-reply-to: <000001cec8b9$931f4c90$b95de5b0$%han@samsung.com>
Subject: [PATCH 05/11] regulator: max8997: Fix checkpatch issue
Date: Mon, 14 Oct 2013 17:49:11 +0900
Message-id: <000401cec8ba$408c93b0$c1a5bb10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7IuZK01KcLw1AZSDCREfGxHfkpOgAAHOkA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t8zI132DdFBBjNmyVpMffiEzeLywkus
	Ft+udDBZXN41h83iduMKNgdWj52z7rJ7bFrVyebRt2UVo8fnTXIBLFFcNimpOZllqUX6dglc
	GVOvPmQuaGGvOLDkF1MD40vWLkZODgkBE4mzcx5A2WISF+6tZ+ti5OIQEljGKNG+r5UdpuhM
	10NGiMQiRonWn5Ohqn4xSny6e5kRpIpNQE3iy5fDQB0cHCICqhL/X7mDhJkFZjBKfHijA2IL
	CdhK3D19iRnE5hSwk1j4bRcLSLmwgL3Epb9SIGEWoM5P/y6DlfAClf+6eBHKFpT4MfkeC8RI
	LYn1O48zQdjyEpvXvGUGGSMhoC7x6K8uxAFGEtd65SAqRCT2vXgHdr2EwDl2iV2P77BBrBKQ
	+Db5EAtEq6zEpgPMEN9KShxccYNlAqPELCSLZyFZPAvJ4llIVixgZFnFKJpakFxQnJReZKJX
	nJhbXJqXrpecn7uJERKbE3Yw3jtgfYgxGWj9RGYp0eR8YGznlcQbGpsZWZiamBobmVuakSas
	JM6r3mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFxmfq/RVvs567N3nopoLzn9m1hTymm
	3r8eyywP/puwTFT+CV/35omcX5jYPjdw3quovyC8dukL5QoNdbk6vUCN++0Xg76kVkzs9+bc
	FMLcbz7nC4uudajZRpMvf3dOVuw9ybPh4PnJZ89qy+7kUDfYtjROunXuxdUtpWXThCwurFj0
	oU5X8OAkJZbijERDLeai4kQA3SCUzeMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRmVeSWpSXmKPExsVy+t9jAV32DdFBBj9uSFpMffiEzeLywkus
	Ft+udDBZXN41h83iduMKNgdWj52z7rJ7bFrVyebRt2UVo8fnTXIBLFENjDYZqYkpqUUKqXnJ
	+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QIuVFMoSc0qBQgGJxcVK+naY
	JoSGuOlawDRG6PqGBMH1GBmggYR1jBlTrz5kLmhhrziw5BdTA+NL1i5GTg4JAROJM10PGSFs
	MYkL99azdTFycQgJLGKUaP05Gcr5xSjx6e5lsCo2ATWJL18Os3cxcnCICKhK/H/lDhJmFpjB
	KPHhjQ6ILSRgK3H39CVmEJtTwE5i4bddLCDlwgL2Epf+SoGEWYA6P/27DFbCC1T+6+JFKFtQ
	4sfkeywQI7Uk1u88zgRhy0tsXvOWGWSMhIC6xKO/uhAHGElc65WDqBCR2PfiHeMERqFZSAbN
	QjJoFpJBs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHPnPpHYwrmywOMQowMGo
	xMMr4BQdJMSaWFZcmXuIUYKDWUmEV3AeUIg3JbGyKrUoP76oNCe1+BBjMtCfE5mlRJPzgUkp
	ryTe0NjEzMjSyMzCyMTcnDRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoYpzsqn50hYMx3
	ZO/NBT+qdl8XcbrfeHZ7sXdYd43rnyNPfly2ON/I8dv87NJ3xrHaJZMKhf6cOPuRY37DpOlf
	+/r3C3ok62ZFsRSkhZruulQR96PK6rm3X+bcEKZP/R4nltzx0uZsdHR9JOJq4rcvwvmMsvHD
	0tX1OhvazFykfzds5nh849U9JZbijERDLeai4kQA0ZA/tkADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following checkpatch warning.

  WARNING: quoted string split across lines

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/max8997.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index bcd2488..2d618fc 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -690,8 +690,9 @@ static int max8997_set_voltage_buck(struct regulator_dev *rdev,
 	if (max8997->ignore_gpiodvs_side_effect == false)
 		return -EINVAL;
 
-	dev_warn(&rdev->dev, "MAX8997 GPIO-DVS Side Effect Warning: GPIO SET:"
-			" %d -> %d\n", max8997->buck125_gpioindex, tmp_idx);
+	dev_warn(&rdev->dev,
+		"MAX8997 GPIO-DVS Side Effect Warning: GPIO SET:  %d -> %d\n",
+		max8997->buck125_gpioindex, tmp_idx);
 
 out:
 	if (new_idx < 0 || new_val < 0)
-- 
1.7.10.4


