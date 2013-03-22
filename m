Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113Ab3CVCPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 22:15:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:24160 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab3CVCPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 22:15:39 -0400
X-AuditID: cbfee68d-b7f786d000005188-49-514bbeca0d2f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00bb01ce26a3$0d69b800$283d2800$%han@samsung.com>
In-reply-to: <00bb01ce26a3$0d69b800$283d2800$%han@samsung.com>
Subject: [PATCH 2/2] rtc: rtc-88pm80x: add CONFIG_PM_SLEEP to suspend/resume
 functions
Date: Fri, 22 Mar 2013 11:15:37 +0900
Message-id: <00bc01ce26a3$24cfdc90$6e6f95b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4mow1NhbkZdmKeSwuK3nkgccWzIwAAAX2Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zI91T+7wDDXZu47JYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANYrLJiU1J7Ms
	tUjfLoEr4/35SUwF0zgqbj/4wdrA+Juti5GTQ0LAROLF1K/sELaYxIV764HiXBxCAssYJa78
	+ccCU9R5dg8zRGIRo0TT/XdQzi9GiadrNoGNYhNQk/jy5TDQKA4OEQF9ibYWDZAaZoFeRokz
	vbvBVggJ2ErsO7+eCcTmFLCTeH/oN1hcWCBCYsb6SawgNouAqsSc1tdgm3mB6i8uaICyBSV+
	TL4HZjMLaEms33mcCcKWl9i85i0zyF4JAXWJR391QcIiAkYS6zf2QpWISOx78Y4R5B4JgXvs
	En937WaG2CUg8W3yIRaIXlmJTQeYIR6WlDi44gbLBEaJWUg2z0KyeRaSzbOQrFjAyLKKUTS1
	ILmgOCm9yFCvODG3uDQvXS85P3cTIyRWe3cw3j5gfYgxGWj9RGYp0eR8YKznlcQbGpsZWZia
	mBobmVuakSasJM6r1mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHx/OvVnwyTG+r3+97K
	NXM/oHFR5szJuC7/pwXOXiraF5s22X1k+CKuIBln2vRFf/Wv13X/Ft5JqPL1/8li5mS5oEIl
	6O0h55TAjvsXBP9Y3Nh7ZaXg1Q+vZ3Srfp+/UKWgujOL88FmkYkbbq0J8uiV9D7/S/78mQkP
	PjCuecu+QYEj7ZLU+twFSizFGYmGWsxFxYkAm+vPpusCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jAd1T+7wDDTYsZLNYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMeP9+UlMBdM4Km4/+MHawPibrYuRk0NCwESi
	8+weZghbTOLCvfVAcS4OIYFFjBJN998xQzi/GCWertkE1sEmoCbx5cth9i5GDg4RAX2JthYN
	kBpmgV5GiTO9u9lBaoQEbCX2nV/PBGJzCthJvD/0GywuLBAhMWP9JFYQm0VAVWJO62sWEJsX
	qP7iggYoW1Dix+R7YDazgJbE+p3HmSBseYnNa94yg+yVEFCXePRXFyQsImAksX5jL1SJiMS+
	F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOBE8Ex6
	B+OqBotDjAIcjEo8vBo63oFCrIllxZW5hxglOJiVRHgjU4BCvCmJlVWpRfnxRaU5qcWHGJOB
	Hp3ILCWanA9MUnkl8YbGJmZGlkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnV
	wBj/iakuUPzGzIoI6wiF1csd9quyWjgk3hJkaP2zTFTq71+hVqdr3YwKv3ZL+c1l5l8jlLrH
	gj3PMkOXhT9j6txMJqWgzVeKN+5mfLJbqXav2lbud49XfPmy89GdJvU2xb8Ln+1coMCcrL5y
	k69vv+X8Q0/23l/Ote91yZKV4t2/HD4eO6Cz4boSS3FGoqEWc1FxIgDK7o91SAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CONFIG_PM_SLEEP to suspend/resume functions to fix the following
build warning when CONFIG_PM_SLEEP is not selected. This is because
sleep PM callbacks defined by SIMPLE_DEV_PM_OPS are only used when
the CONFIG_PM_SLEEP is enabled.

drivers/rtc/rtc-88pm80x.c:238:12: warning: 'pm80x_rtc_suspend' defined but not used [-Wunused-function]
drivers/rtc/rtc-88pm80x.c:243:12: warning: 'pm80x_rtc_resume' defined but not used [-Wunused-function]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-88pm80x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-88pm80x.c b/drivers/rtc/rtc-88pm80x.c
index 76f9505..f3742f3 100644
--- a/drivers/rtc/rtc-88pm80x.c
+++ b/drivers/rtc/rtc-88pm80x.c
@@ -234,7 +234,7 @@ static const struct rtc_class_ops pm80x_rtc_ops = {
 	.alarm_irq_enable = pm80x_rtc_alarm_irq_enable,
 };
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int pm80x_rtc_suspend(struct device *dev)
 {
 	return pm80x_dev_suspend(dev);
-- 
1.7.2.5


