Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbaEGIIC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:08:02 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:65131 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaEGIH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:07:56 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-e3-5369e9dad57d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Stephen Warren'" <swarren@nvidia.com>,
        "'Laxman Dewangan'" <ldewangan@nvidia.com>
References: <01e101cf69c9$abd91f70$038b5e50$%han@samsung.com>
In-reply-to: <01e101cf69c9$abd91f70$038b5e50$%han@samsung.com>
Subject: [PATCH 3/5] regulator: palmas: Make of_device_id array const
Date: Wed, 07 May 2014 17:07:54 +0900
Message-id: <01ed01cf69cb$73032fe0$59098fa0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9pyau3FkiFWFjRR4iSx3x0aUKqEQAAZnuw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t8zQ91bLzODDQ7OMLaY+vAJm8XlhZdY
	LZbuW81i8e1KB5PF5V1z2CxuTG9hdWDz2DnrLrvHplWdbB69ze/YPPq2rGL0+LxJLoA1issm
	JTUnsyy1SN8ugSvjxdsTzAXL2Sr+/NzD2MC4grWLkZNDQsBE4vyJf+wQtpjEhXvr2boYuTiE
	BJYxShw8f4gJpujS9jfMEInpjBLvz3ZDVf1mlJh49AQbSBWbgJrEly+HgUZxcIgIqEr8f+UO
	UsMscIBRouHFJFaQuJCArcSjPfUg5ZwCdhIN26aCtQoLuErs29gNdgULUGvDxPtMIOW8QOX3
	N6qBhHkFBCV+TL7HAmIzC2hJrN95nAnClpfYvOYtM0i5hIC6xKO/uiBhEQEjiR0/tjNClIhI
	7HvxjhHkGgmBt+wSW2d+ZIJYJSDxbfIhFoheWYlNB5gh3pWUOLjiBssERolZSDbPQrJ5FpLN
	s5CsWMDIsopRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjJGL7dzDePWB9iDEZaP1EZinR5Hxg
	xOeVxBsamxlZmJqYGhuZW5qRJqwkznv/YVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsa9
	TtNEJs2TP5i7ceuNrMmyz1N1FZcdOWZgJTPjCcvjStmVfhtyGuYJ/pi0NlDSLW7huZ26Bvrr
	VizP+Np9JO6rdeO9oOfJiRV/OEzyvh+tYzZ9sLQ38bGgnjLH3QP31Vs1tYK2Hc8+yFkbqsx5
	f6baX8Pzih/i32Uc8mV6qWyf0HE+L7LikaUSS3FGoqEWc1FxIgBoR/9Q7gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsVy+t9jQd1bLzODDZo26FtMffiEzeLywkus
	Fkv3rWax+Halg8ni8q45bBY3prewOrB57Jx1l91j06pONo/e5ndsHn1bVjF6fN4kF8Aa1cBo
	k5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0gpJCWWJO
	KVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x48XbE8wFy9kq/vzcw9jAuIK1i5GT
	Q0LAROLS9jfMELaYxIV769m6GLk4hASmM0q8P9sN5fxmlJh49AQbSBWbgJrEly+H2bsYOThE
	BFQl/r9yB6lhFjjAKNHwYhIrSFxIwFbi0Z56kHJOATuJhm1TwVqFBVwl9m3sZgexWYBaGybe
	ZwIp5wUqv79RDSTMKyAo8WPyPRYQm1lAS2L9zuNMELa8xOY1b5lByiUE1CUe/dUFCYsIGEns
	+LGdEaJERGLfi3eMExiFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5y
	fu4mRnA6eCa9g3FVg8UhRgEORiUeXou3GcFCrIllxZW5hxglOJiVRHh3XcwMFuJNSaysSi3K
	jy8qzUktPsSYDPTnRGYp0eR8YKrKK4k3NDYxM7I0MrMwMjE3J01YSZz3YKt1oJBAemJJanZq
	akFqEcwWJg5OqQbG8E1/NpeW1SQad1+SfhjIsafh4gw/s3OrjRYYn4zk71p4SHnau22dHU52
	j39IzjYUdtgpqb7tiktKUu7MPO4/N2XCD7z9sV5QPvf0gv+7N66MS2nYfeAhU9XhT84c+ley
	p+15wGIosshaoEjcp4F375Rz2ct4iibNeWB4cWHKS5nK5fpOFzaxKbEUZyQaajEXFScCAOvc
	TK1LAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions
handle it as const.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/palmas-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 9c62b1d..671cb9f 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -1199,7 +1199,7 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static struct of_device_id of_palmas_match_tbl[] = {
+static const struct of_device_id of_palmas_match_tbl[] = {
 	{ .compatible = "ti,palmas-pmic", },
 	{ .compatible = "ti,twl6035-pmic", },
 	{ .compatible = "ti,twl6036-pmic", },
-- 
1.7.10.4


