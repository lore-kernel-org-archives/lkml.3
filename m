Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaBZBTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 20:19:37 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:59938 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaBZBTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:19:35 -0500
X-AuditID: cbfee690-b7f266d00000287c-17-530d4123d1bd
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Laxman Dewangan'" <ldewangan@nvidia.com>
Subject: [PATCH 1/3] regulator: tps80031: remove unnecessary parentheses
Date: Wed, 26 Feb 2014 10:19:30 +0900
Message-id: <002e01cf3290$ccda9430$668fbc90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-language: ko
Thread-index: Ac8ykMzEt0AEx/NVROGPrQsXYu79Gw==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zQ11lR95ggxNfBCymPnzCZnF54SVW
	i6X7VrNYfLvSwWRxedccNgdWj52z7rJ7bFrVyebR2/yOzaNvyypGj8+b5AJYo7hsUlJzMstS
	i/TtErgyNt1YyVzwlq3if28zewPjE9YuRg4OCQETiV9LY7oYOYFMMYkL99azdTFycQgJLGOU
	uLlhOStEwkTi4pN3rBCJRYwSM3YcY4FwfjNK3Gn8zgJSxSagJvHly2F2kKkiAqoS/1+5g9Qw
	C0xnlDg78z47SI2wgIfE0Z49YFNZgGreHfgNZvMK2Eoc3DaZHcIWlPgx+R7YTGYBLYn1O48z
	QdjyEpvXvGWGuFpd4tFfXYiwiMS+F+8YQWwRAT2J/r/PmCCOPsYu0bK9BGKVgMS3yYdYIFpl
	JTYdYIYokZQ4uOIGywRGsVlIFs9CsngWksWzkGxbwMiyilE0tSC5oDgpvchErzgxt7g0L10v
	OT93EyMk7ibsYLx3wPoQYzLQ+onMUqLJ+cC4zSuJNzQ2M7IwNTE1NjK3NCNNWEmcV+1RUpCQ
	QHpiSWp2ampBalF8UWlOavEhRiYOTqkGRj7Npme3P0jFt/yJeTG5MMs+0Sqmw3Sths6067Pr
	OPtv7I88bPeY0VWbZYb4vePMUxRLHj8KYHcpjNxTXmxya4OL/lrzl4bbp338pXXbedn/wI7D
	TyYWKMqd0RfjeLufkeXNr31Reb8vp6z2uldoKSLa+4VjuUH1tQ9Xln+7xX6ngD2Fr98rUYml
	OCPRUIu5qDgRAGT1TdLRAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAV1lR95gg5mzeS2mPnzCZnF54SVW
	i6X7VrNYfLvSwWRxedccNgdWj52z7rJ7bFrVyebR2/yOzaNvyypGj8+b5AJYoxoYbTJSE1NS
	ixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAtisplCXmlAKFAhKL
	i5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYMzbdWMlc8Jat4n9vM3sD4xPWLkZODgkBE4mL
	T95B2WISF+6tZ+ti5OIQEljEKDFjxzEWCOc3o8Sdxu8sIFVsAmoSX74cZu9i5OAQEVCV+P/K
	HaSGWWA6o8TZmffZQWqEBTwkjvbsAZvKAlTz7sBvMJtXwFbi4LbJ7BC2oMSPyffAZjILaEms
	33mcCcKWl9i85i0zyHwJAXWJR391IcIiEvtevGMEsUUE9CT6/z5jmsAoMAvJpFlIJs1CMmkW
	kvYFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYIj+5nUDsaVDRaHGAU4GJV4eANYeIOF
	WBPLiitzDzFKcDArifBafOMJFuJNSaysSi3Kjy8qzUktPsSYDPToRGYp0eR8YNLJK4k3NDYx
	M7I0MrMwMjE3J01YSZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQZGdw6nkP716bZJ15f6xGnm
	bN3xS7KdVV734/n4MJunLaIJEz9xOTZz3xLji6hXVn/XU+fbzqEx74RT6JEnV36oZAZW2UZr
	dq9IfmvRmtbxrtJuTcucxRwc+2+9nJ040467cOUTcbU1wmKrGv76v2KQyD52eHn3vksiS92C
	OHck5CR0ph3yZlFiKc5INNRiLipOBADmHcsvMAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary parentheses in order to fix the following
checkpatch error.

  ERROR: return is not a function, parentheses are not required

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/tps80031-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/tps80031-regulator.c b/drivers/regulator/tps80031-regulator.c
index ac88c98..26aa6d9 100644
--- a/drivers/regulator/tps80031-regulator.c
+++ b/drivers/regulator/tps80031-regulator.c
@@ -115,7 +115,7 @@ static int tps80031_reg_is_enabled(struct regulator_dev *rdev)
 			ri->rinfo->state_reg, ret);
 		return ret;
 	}
-	return ((reg_val & TPS80031_STATE_MASK) == TPS80031_STATE_ON);
+	return (reg_val & TPS80031_STATE_MASK) == TPS80031_STATE_ON;
 }
 
 static int tps80031_reg_enable(struct regulator_dev *rdev)
-- 
1.7.10.4


