Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab3COJPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 05:15:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32067 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab3COJP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 05:15:29 -0400
X-AuditID: cbfee690-b7f656d0000007e3-f5-5142e6b06c7d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: "'Linus Walleij'" <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <006201ce215d$6f133d10$4d39b730$%han@samsung.com>
In-reply-to: <006201ce215d$6f133d10$4d39b730$%han@samsung.com>
Subject: [PATCH 4/6] gpio: max732x: use devm_kzalloc()
Date: Fri, 15 Mar 2013 18:15:28 +0900
Message-id: <006501ce215d$a275fe40$e761fac0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4hXW7HXikowtUaTheLztVYvIsx2AAACgTw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zI90Nz5wCDe4uk7K4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZHQ3HWArmcFR07T7F1sB4m62LkZNDQsBEYmbrf0YIW0ziwr31
	QHEuDiGBZYwS32Z+YIEpWvbqIgtEYhGjxOmDm5khnNlMEk/fLQQbxSagJvHly2F2EFtEQE/i
	xoUOsLHMAkUSz7tmsYLYQgK2EkeufwKbyilgJ/FsXR9YXFjATOLHp3dgvSwCqhKbFj4Fi/MC
	1R/YsogdwhaU+DH5HgvETC2J9TuPM0HY8hKb17wFOogD6FJ1iUd/dSFOMJJomHyPFaJERGLf
	i3dQXy5ilzg+vRpilYDEt8mHWCBaZSU2HWCGKJGUOLjiBssERolZSBbPQrJ4FpLFs5BsWMDI
	sopRNLUguaA4Kb3IRK84Mbe4NC9dLzk/dxMjJLIm7GC8d8D6EGMy0PqJzFKiyfnAyMwriTc0
	NjOyMDUxNTYytzQjTVhJnFe9xTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6PzZKFLe3v5
	/NWjz//1rHecsFBnmzr33H0b56remCwa3mMd1fXzSkND87rkVPfjU7vmmb2ZUt/Jt2Hrmn8X
	Yq62afpp974zmDi1+l73A65b32vmhqiU/uCTP3RZn3nW52WbTPaLPVnGMymt5bHF7ngLHf8e
	dnMX9WaNyCfV5/b8buNaVLhiSYsSS3FGoqEWc1FxIgBr5vSNwgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xgO6GZ06BBp8eillc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjI6GYywFczgqunafYmtg
	vM3WxcjJISFgIrHs1UUWCFtM4sK99UBxLg4hgUWMEqcPbmaGcGYzSTx9txCsg01ATeLLl8Ps
	ILaIgJ7EjQsdjCA2s0CRxPOuWawgtpCArcSR65/ApnIK2Ek8W9cHFhcWMJP48ekdWC+LgKrE
	poVPweK8QPUHtixih7AFJX5MvscCMVNLYv3O40wQtrzE5jVvgQ7iALpUXeLRX12IE4wkGibf
	Y4UoEZHY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7
	iREcuc+kdzCuarA4xCjAwajEw+vw0DFQiDWxrLgy9xCjBAezkgjvx4tOgUK8KYmVValF+fFF
	pTmpxYcYk4EencgsJZqcD0wqeSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1I
	LYLZwsTBKdXAmHrUeXZOtfrLP9UqzyPEZ8U76Jy68elpaODMab/+zk9atvJR3abJW7sPqyis
	l+P5o/daZfo9ZfGlp7vM3iQmhHVtqc7pk3lkJrHvs+jaNe0z+jbe1zl6dUf85Wufr5mZ7ezj
	8wvRPWe5JnHKu6uHeM5Ebfzf84t7mbXgkiCBVla3x2cWc8Q8VVViKc5INNRiLipOBAB/cI6z
	IAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/gpio/gpio-max732x.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-max732x.c b/drivers/gpio/gpio-max732x.c
index 1e0467c..d4b51b1 100644
--- a/drivers/gpio/gpio-max732x.c
+++ b/drivers/gpio/gpio-max732x.c
@@ -589,7 +589,8 @@ static int max732x_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	chip = kzalloc(sizeof(struct max732x_chip), GFP_KERNEL);
+	chip = devm_kzalloc(&client->dev, sizeof(struct max732x_chip),
+			GFP_KERNEL);
 	if (chip == NULL)
 		return -ENOMEM;
 	chip->client = client;
@@ -647,7 +648,6 @@ static int max732x_probe(struct i2c_client *client,
 
 out_failed:
 	max732x_irq_teardown(chip);
-	kfree(chip);
 	return ret;
 }
 
@@ -680,7 +680,6 @@ static int max732x_remove(struct i2c_client *client)
 	if (chip->client_dummy)
 		i2c_unregister_device(chip->client_dummy);
 
-	kfree(chip);
 	return 0;
 }
 
-- 
1.7.2.5


