Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835Ab3BSA4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 19:56:32 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:28948 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757346Ab3BSA42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 19:56:28 -0500
X-AuditID: cbfee690-b7f066d00000169f-9f-5122cdbaab75
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] mfd: wm8994: add missing variable initialization
Date: Tue, 19 Feb 2013 09:56:26 +0900
Message-id: <000001ce0e3b$f1d99170$d58cb450$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4OO/E3Xt6wSVqpSmmLBoSQXn1aZg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsVy+t8zA91dZ5UCDTp/aFpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mn+9XMBcsYK/oPBjZwNjD1sXIySEhYCJx4GoHM4QtJnHh3nqg
	OBeHkMAyRomVP16zwBS9PrUSrEhIYDqjxPpJ2hBFs5kkvi3fxw6SYBNQk/jy5TCYLSKgJdF9
	7DzYJGaBhYwS0/pPgE0SFnCU+LlgEiuIzSKgKvH09kEwm1fAVuLj84mMELagxI/J98DqmYEG
	rd95nAnClpfYvOYt0BUcQBepSzz6qwuxS09iyvEbUOUiEvtevGME2Ssh0Mwu8ersNXaIXQIS
	3yYfYoHolZXYdADqY0mJgytusExgFJuFZPMsJJtnIdk8C8mKBYwsqxhFUwuSC4qT0otM9IoT
	c4tL89L1kvNzNzFCImXCDsZ7B6wPMSYDrZ/ILCWanA+MtLySeENjYxMzE1MTc0tTc1PShJXE
	eeUvyQQKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYEzKjJy7jGcnf9ma1ObVyaoeO/rTLtdF
	JG7nK9nuorkntmrB91/Bz4sWdMoEX9t75PZsK5lkc6/C3EJ/tcdbnvJKRJ2T5J4gz5ywKcjw
	flTMJpaDUQZrBPrcGv49No5s0o8KEl02v7Qj9VPtvPSaNCvdbTGbzqlZhM5uePlS4dtkNvtd
	t1fLKLEUZyQaajEXFScCANZkeRSqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jQd1dZ5UCDd6sV7O4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGT/fr2AuWMBe0XkwsoGx
	h62LkZNDQsBE4vWplcwQtpjEhXvrweJCAtMZJdZP0u5i5AKyZzNJfFu+jx0kwSagJvHly2Ew
	W0RAS6L72Hk2kCJmgYWMEtP6T7CAJIQFHCV+LpjECmKzCKhKPL19EMzmFbCV+Ph8IiOELSjx
	Y/I9sHpmoEHrdx5ngrDlJTaveQt0EQfQReoSj/7qQuzSk5hy/AZUuYjEvhfvGCcwCsxCMmkW
	kkmzkEyahaRlASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgOHwmvYNxVYPFIUYBDkYl
	Ht4PjkqBQqyJZcWVuYcYJTiYlUR4O9qBQrwpiZVVqUX58UWlOanFhxiTgR6dyCwlmpwPTBF5
	JfGGxiZmRpZGZhZGJubmpAkrifMynnoSICSQnliSmp2aWpBaBLOFiYNTCpiWzsqsnfj1fsS7
	Q1zNz7mn/l0Wq6/rIx++/4XTk+7Ff0PEeJ8ozJkj0Vly+e39v7//r+oX31G25U9r03lWy29n
	6ppmPsrR9shpOsHaX3WDjfPOjE/3H5tduq7jue7M5OeruZa8+vYkqPHI33MnZBPLXv7wswyd
	v7BiUa6s0bI/J2/oSioGNVb9VmIpzkg01GIuKk4EAKlimlIHAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed build warning as below:

drivers/mfd/wm8994-core.c: In function 'wm8994_i2c_probe':
drivers/mfd/wm8994-core.c:595:7: warning: 'patch_regs' may be used uninitialized in this function [-Wuninitialized]
drivers/mfd/wm8994-core.c:408:14: note: 'patch_regs' was declared here

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/wm8994-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 803e93f..97e929e 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -405,7 +405,7 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 	struct regmap_config *regmap_config;
 	const struct reg_default *regmap_patch = NULL;
 	const char *devname;
-	int ret, i, patch_regs;
+	int ret, i, patch_regs = 0;
 	int pulls = 0;
 
 	if (dev_get_platdata(wm8994->dev)) {
-- 
1.7.2.5


