Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839AbaEMK71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:59:27 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59978 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760259AbaEMK7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:59:06 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-80-5371faf7c728
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 16/16] mfd: max8907: Make of_device_id array const
Date: Tue, 13 May 2014 12:58:53 +0200
Message-id: <1399978733-13662-16-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
References: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHJMWRmVeSWpSXmKPExsVy+t/xy7rffxUGG1xdK2/x+oWhxf2vRxkt
	Lu+aw2ZxupvVgcXjzrU9bB7zTgZ69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8bb51uZC+ay
	VrSvWMbUwLiapYuRk0NCwERi6ZHvbBC2mMSFe+uBbC4OIYGljBLT/jWAJYQE+pgk3vQxg9hs
	AsYSm5cvAYuLCGRJ/JgGMYhZwFDi57s/7CC2sICTxMz9G8BsFgFVibZZl5hAbF4BD4l/vdeh
	FstJnDw2mRXE5gSKv7h9lhVil7vEjVWTWCYw8i5gZFjFKJpamlxQnJSea6RXnJhbXJqXrpec
	n7uJERImX3cwLj1mdYhRgINRiYfXg7kgWIg1say4MvcQowQHs5IIr/unwmAh3pTEyqrUovz4
	otKc1OJDjEwcnFINjIsYczPKQ2SUT8tq2PsfbO7x9s7Wf6d99tejlQuUlq+sNZuo+9LOSvLP
	4vTPXK8YHATkij7ukFfJrVpbfMTy6fdHn43Y7rOHs+0wqWS9Krybo5eZLZlt0ReOwvZoTtlo
	M4O6OTXvLTI0ZarO+SSW53/Q39ZUrP1J0vDSd8GF+RfztivM7dmrxFKckWioxVxUnAgAXurD
	3/EBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Array of struct of_device_id may be be const as expected by
of_match_table field.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/max8907.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/max8907.c b/drivers/mfd/max8907.c
index 07740314b29d..232749c8813d 100644
--- a/drivers/mfd/max8907.c
+++ b/drivers/mfd/max8907.c
@@ -305,7 +305,7 @@ static int max8907_i2c_remove(struct i2c_client *i2c)
 }
 
 #ifdef CONFIG_OF
-static struct of_device_id max8907_of_match[] = {
+static const struct of_device_id max8907_of_match[] = {
 	{ .compatible = "maxim,max8907" },
 	{ },
 };
-- 
1.9.1

