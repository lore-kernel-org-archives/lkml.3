Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaJAGow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 02:44:52 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:23286 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaJAGoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 02:44:11 -0400
X-AuditID: cbfee68f-f791c6d000004834-ef-542ba2b646c7
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Jaewon Kim <jaewon02.kim@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH RESEND v5 2/3] mfd: max77693: add haptic of_compatible in
 mfd_cell
Date: Wed, 01 Oct 2014 15:43:57 +0900
Message-id: <1412145838-7563-3-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1412145838-7563-1-git-send-email-jaewon02.kim@samsung.com>
References: <1412145838-7563-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsWyRsSkRHfbIu0Qg+mbrS2uf3nOanF40QtG
	ix0NR1gt7n89ymhxedccNgdWj52z7rJ73Lm2h82jb8sqRo/Pm+QCWKK4bFJSczLLUov07RK4
	Mi5eusFY8IqtYk3bQbYGxgusXYycHBICJhKTXq9lgbDFJC7cW88GYgsJLGWU6JysC1Pzdedf
	oBouoPh0Rok1Lw8xQzhtTBJLzu5lAqliE9CW+L5+MdBUDg4RARWJc2/MQWqYBeYxSpy/vQds
	qrBAiMT/GxsZQWwWAVWJSW3dYL28Au4Se6+sZAHplRBQkJgzyQYkzCngIXGm+Qg7SFgIqOTL
	8xqQkRICzewSk1r+sUKMEZD4NvkQVKusxKYDzBA3S0ocXHGDZQKj8AJGhlWMoqkFyQXFSelF
	xnrFibnFpXnpesn5uZsYgUF8+t+z/h2Mdw9YH2IU4GBU4uFVSNAOEWJNLCuuzD3EaAq0YSKz
	lGhyPjBW8kriDY3NjCxMTUyNjcwtzZTEeRdK/QwWEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnV
	wCh8lb396QJlIy9tL403txwkn+Q+nfqaKyfswJ2S1qg/zPtnhEW5yjhHxRhu2GZ6LEMgImfz
	r5jbC9XdypNndZ0VOPiM8e4O4bDE37qCQtEeC75deym34dItA32d2ddUeNfMNAiZffqDSth1
	Hf68N9xGf/Zxi8rHP7f47X5m288e+3b7Hx+MHJVYijMSDbWYi4oTAUtjIXZdAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t9jQd1ti7RDDH5PNbG4/uU5q8XhRS8Y
	LXY0HGG1uP/1KKPF5V1z2BxYPXbOusvucefaHjaPvi2rGD0+b5ILYIlqYLTJSE1MSS1SSM1L
	zk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqspFCWmFMKFApILC5W0rfD
	NCE0xE3XAqYxQtc3JAiux8gADSSsYcy4eOkGY8Ertoo1bQfZGhgvsHYxcnJICJhIfN35lwXC
	FpO4cG89WxcjF4eQwHRGiTUvDzFDOG1MEkvO7mUCqWIT0Jb4vn4xUDcHh4iAisS5N+YgNcwC
	8xglzt/ewwZSIywQIvH/xkZGEJtFQFViUls3WC+vgLvE3isrWUB6JQQUJOZMsgEJcwp4SJxp
	PsIOEhYCKvnyvGYCI+8CRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMFR8kxqB+PKBotD
	jAIcjEo8vAoJ2iFCrIllxZW5hxglOJiVRHgnVgCFeFMSK6tSi/Lji0pzUosPMZoC3TSRWUo0
	OR8YwXkl8YbGJmZGlkbmhhZGxuZK4rwHWq0DhQTSE0tSs1NTC1KLYPqYODilGhjdlc9cMBYL
	b+mqZLpX6cj+svT4wW3qc0P0vfLObDbz2MvmwlDsOvfK16uvk3Yu7+CrEFEvzb4mO+/fz++b
	gt3nB3Of9Z8cMtHuXkNRqbC4qiaTxp9JkVuFc2sTzX/3un7Q+TM1ScBnZY3f3i6eXWx5zq8n
	63hmVhYkS4jPS2wP87V8dm1DgRJLcUaioRZzUXEiAO+FnkuoAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add haptic of_compatible in order to use the haptic
device driver using Devicetree.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/max77693.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index fbfed56..5b516fe 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -46,7 +46,10 @@ static const struct mfd_cell max77693_devs[] = {
 	{ .name = "max77693-charger", },
 	{ .name = "max77693-flash", },
 	{ .name = "max77693-muic", },
-	{ .name = "max77693-haptic", },
+	{
+		.name = "max77693-haptic",
+		.of_compatible = "maxim,max77693-haptic",
+	},
 };
 
 static const struct regmap_config max77693_regmap_config = {
-- 
1.7.9.5

