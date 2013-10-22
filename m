Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab3JVMwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 08:52:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32891 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab3JVMwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 08:52:10 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68e-b7f416d0000020d6-c7-526674f54c8e
Content-transfer-encoding: 8BIT
From: Chanwoo Choi <cw00.choi@samsung.com>
To: anton@enomsg.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: dwmw2@infradead.org, grant.likely@linaro.org, rob.herring@calxeda.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        cw00.choi@samsung.com
Subject: [PATCH 4/4] charger-manager: Remove build warning fo unused variable
Date: Tue, 22 Oct 2013 21:51:57 +0900
Message-id: <1382446317-32613-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1382446317-32613-1-git-send-email-cw00.choi@samsung.com>
References: <1382446317-32613-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWyRsSkRPdbSVqQwe3zrBYHt2paXP/ynNVi
	/pFzrBYTV05mtjjwZwejxdmmN+wWl3fNYbO43biCzeLwigNMDpweCz5fYfeY0P+J0WPzCi2P
	O9f2sHn0bVnF6PF5k1wAWxSXTUpqTmZZapG+XQJXxtrTm9kKZrBXXJg0mb2BcQlbFyMnh4SA
	icTsa30sELaYxIV764HiXBxCAksZJeYv/cMMU7Ry7XFGiMQiRol1q++wgyR4BQQlfky+B9TN
	wcEsIC9x5FI2SJhZQF1i0rxFzBD1jUwSC26uB9vAJqAlsf/FDbDNIgJ+EtffbmMCKWIWmM4o
	sXJhHytIQljAV2L6ur2MIDaLgKrEpMMnGEEW8Aq4SsxtcoA4SE7iw55HYDdwCrhJ7Jv6iwnE
	FgIquftnEivITAmBt+wSl158g5ojIPFt8iGwQyUEZCU2HYB6TFLi4IobLBMYxWYheWcWwjuz
	kLyzgJF5FaNoakFyQXFSepGRXnFibnFpXrpecn7uJkZgPJ7+96xvB+PNA9aHGJOBNk5klhJN
	zgfGc15JvKGxmZGFqYmpsZG5pRlpwkrivIseJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRq
	YJzSPevE76U5zjYrur11kqMb9yfrTP4ZUbfhyX1fA6ZzPt31eq/Ovz5qKPfGKPmasiS/pbfm
	3HK5XWscKgR3uPip6xWy2l4J+Fa9vTfi4p6Lj7asOm3x5mCv3cYelldrmxK/PnayNL80xaT3
	ieUv/4kexeVO1V/T1aQ3C2eUn5C/w/MyNKF3vxJLcUaioRZzUXEiAAqm0PDdAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jAd2vJWlBBqv7rC0ObtW0uP7lOavF
	/CPnWC0mrpzMbHHgzw5Gi7NNb9gtLu+aw2Zxu3EFm8XhFQeYHDg9Fny+wu4xof8To8fmFVoe
	d67tYfPo27KK0ePzJrkAtqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8
	xNxUWyUXnwBdt8wcoKOUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBlr
	T29mK5jBXnFh0mT2BsYlbF2MnBwSAiYSK9ceZ4SwxSQu3FsPFOfiEBJYxCixbvUddpAEr4Cg
	xI/J91i6GDk4mAXkJY5cygYJMwuoS0yat4gZor6RSWLBzfUsIAk2AS2J/S9ugC0QEfCTuP52
	GxNIEbPAdEaJlQv7WEESwgK+EtPX7QXbzCKgKjHp8AlGkAW8Aq4Sc5scIA6Sk/iw5xHYDZwC
	bhL7pv5iArGFgEru/pnEOoFRYBaS82YhnDcLyXkLGJlXMYqmFiQXFCel5xrpFSfmFpfmpesl
	5+duYgRH+zPpHYyrGiwOMQpwMCrx8GZYpQYJsSaWFVfmHmKU4GBWEuFt9k0LEuJNSaysSi3K
	jy8qzUktPsSYDHT3RGYp0eR8YCLKK4k3NDYxM7I0Mje0MDI2J01YSZz3YKt1oJBAemJJanZq
	akFqEcwWJg5OqQZGYSnB4iNtlW5NvzetLszqjrxj+rR5XcGiiufLli+btLsl9Lb+wuuT7Y9V
	6VZZhcQHHCucW5N/7KndBfsljv07fsapfGoqeW/UV/8rK/7sHtmXnG+szJgDTj+V+X5yT9Ce
	p02tCkx6Npqy3LePbv25rP2FyZ4zZ32u/mJQXRO/+k9lBqf98ye8SizFGYmGWsxFxYkAufsd
	bDoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/power/charger-manager.c: In function ‘_cm_monitor’:
drivers/power/charger-manager.c:598:23: warning: unused variable ‘desc’ [-Wunused-variable]

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/power/charger-manager.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 02a395c..02b4d76 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -595,7 +595,6 @@ static int read_battery_temperature(struct charger_manager *cm,
  */
 static bool _cm_monitor(struct charger_manager *cm)
 {
-	struct charger_desc *desc = cm->desc;
 	int temp = read_battery_temperature(cm, &cm->last_temp_mC);
 
 	dev_dbg(cm->dev, "monitoring (%2.2d.%3.3dC)\n",
-- 
1.8.0

