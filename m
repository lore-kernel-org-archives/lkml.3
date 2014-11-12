Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaKLP2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:28:22 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64367 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbaKLP2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:28:20 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-71-54637c91507d
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] extcon: max14577: Fix obvious typo in company name in copyright
Date: Wed, 12 Nov 2014 16:28:09 +0100
Message-id: <1415806089-19684-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPJMWRmVeSWpSXmKPExsVy+t/xy7oTa5JDDLafY7e4/uU5q8XrF4YW
	l3fNYbO43biCzYHFo2/LKkaPz5vkApiiuGxSUnMyy1KL9O0SuDJe9fawFFxhrXj19zZTA+N9
	li5GTg4JAROJKQ9msUPYYhIX7q1n62Lk4hASWMoosfXkEhYIp49JYvHco0wgVWwCxhKbly9h
	A7FFBAolnmy4CmYzCxhK/Hz3B2ySsECAxLct78HqWQRUJVY3HgKr4RVwl/h/+xnUZjmJk8cm
	s05g5F7AyLCKUTS1NLmgOCk911CvODG3uDQvXS85P3cTI8TTX3YwLj5mdYhRgINRiYe3gic5
	RIg1say4MvcQowQHs5II77QSoBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGqXX8uzdOe3dZfOmZ
	jm89PA8eNbRNPXTV8BOH/r3k2AyV/sCO/bLms7tvhYv7b/PRYE+61OSmJfXs5e4Hmzcdjpb5
	XrvG2oPzl5H2dSPn2Zud3nWX/q+dqRKwKW8/S3xS8AKhR+mfF9k8sLkQ0OvsHFTYzHKjfv++
	CyZfZhn/DY6ob3M50jhTiaU4I9FQi7moOBEAxJ3bs9IBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a typo in name of company in copyright comment.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/extcon/extcon-max14577.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
index dfc2fd370eb3..c1bf0cf747b0 100644
--- a/drivers/extcon/extcon-max14577.c
+++ b/drivers/extcon/extcon-max14577.c
@@ -1,7 +1,7 @@
 /*
  * extcon-max14577.c - MAX14577/77836 extcon driver to support MUIC
  *
- * Copyright (C) 2013,2014 Samsung Electrnoics
+ * Copyright (C) 2013,2014 Samsung Electronics
  * Chanwoo Choi <cw00.choi@samsung.com>
  * Krzysztof Kozlowski <k.kozlowski@samsung.com>
  *
-- 
1.9.1

