Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbaA1MTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:19:06 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20311 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149AbaA1MTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:19:03 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-56-52e7a035be18
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 03/18] mfd: max14577: Remove not needed header inclusion
Date: Tue, 28 Jan 2014 13:18:27 +0100
Message-id: <1390911522-28209-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprALMWRmVeSWpSXmKPExsVy+t/xa7qmC54HGRxZwmMx9eETNovrX56z
	Wrx+YWhxtukNu8X9r0cZLb5d6WCy2PT4GqvF5V1z2CzWHrnLbnG7cQWbxeluVgduj52z7rJ7
	bFrVyeZx59oeNo95JwM9Ni+p9+jbsorR4/MmuQD2KC6blNSczLLUIn27BK6MTWuWsxccZqt4
	f7ObpYHxAGsXIyeHhICJxJfDR1ggbDGJC/fWs3UxcnEICSxllPh+aC8LhNPHJNG9ZQ4TSBWb
	gLHE5uVLwKpEBFYzSaxZMBWsnVmgl1Hi5m4PEFtYwEPi7qdWdhCbRUBV4tmW1WwgNq+Au8S2
	u4uA4hxA6xQk5kyyAQlzApW/utoINl8IqOTU8XcsExh5FzAyrGIUTS1NLihOSs811CtOzC0u
	zUvXS87P3cQICcUvOxgXH7M6xCjAwajEw9vR+SxIiDWxrLgy9xCjBAezkghv4uznQUK8KYmV
	ValF+fFFpTmpxYcYmTg4pRoYI1iWsXDeqdU4ebj0Cn+gitGqvzvYssTX7ryaGJj176nwBKNJ
	6naWvduYvVoPxS6W87/jGzuvp+q1z5kGY37puHOTP9yq2fPZLjqCjftVbcbtHZ4VIs1xptsd
	uSffX5S8WXd/XX1qZl5rvvV+rvWtdTp3/mz+rjvzzJqArPJOc5Es64ggv99KLMUZiYZazEXF
	iQC0nZk2IwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove not needed max14577-private.h header inclusion in the main driver
header. Remove obvious comment.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 include/linux/mfd/max14577.h |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/mfd/max14577.h b/include/linux/mfd/max14577.h
index 247b021dfaaf..736d39c3ec0d 100644
--- a/include/linux/mfd/max14577.h
+++ b/include/linux/mfd/max14577.h
@@ -25,13 +25,8 @@
 #ifndef __MAX14577_H__
 #define __MAX14577_H__
 
-#include <linux/mfd/max14577-private.h>
 #include <linux/regulator/consumer.h>
 
-/*
- * MAX14577 Regulator
- */
-
 /* MAX14577 regulator IDs */
 enum max14577_regulators {
 	MAX14577_SAFEOUT = 0,
-- 
1.7.9.5

