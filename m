Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab3BSBIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 20:08:22 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:13919 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab3BSBIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 20:08:20 -0500
X-AuditID: cbfee68f-b7f656d000000d78-f1-5122d083608a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] mfd: twl4030-madc: add __exit macro to remove
Date: Tue, 19 Feb 2013 10:08:18 +0900
Message-id: <000101ce0e3d$9a9e42a0$cfdac7e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4OPZqJHNio5XJvR8u8Q36MxoUVqw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t8zfd3mC0qBBt8eCVlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MLzNfsRbcY63o/HyWsYHxDUsXIyeHhICJxJvVn9khbDGJC/fW
	s3UxcnEICSxjlJj/4gRrFyMHWFFTNzdEfBGjxMvzL5khnNlMEte+TgDrZhNQk/jy5TCYLSKg
	JdF97DwbSDOzgIvE0WkiIKawgJ3E++tuIBUsAqoSK3ZfYwOxeQVsJR5fO8wKYQtK/Jh8D+w2
	ZqAp63ceZ4Kw5SU2r3nLDHGOusSjv7oQi/QkZk/4BFUuIrHvxTtGkMskBJrZJXZ8hpjPIiAg
	8W3yIRaIXlmJTQeYId6VlDi44gbLBEaxWUg2z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCm9yFiv
	ODG3uDQvXS85P3cTIyRK+ncw3j1gfYgxGWj9RGYp0eR8YJTllcQbGhubmJmYmphbmpqbkias
	JM4rf0kmUEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOj6mXHvc8aIgxnOvx4mezdvnT21e82
	jyabhvccUvr58cJtRYGEwyXN+4WuByv7a/lcTK/dPuMS86EFSqF+d5YHzfvRIfh77tlbW938
	X3UscIhL/BF2dWHY3ML8txO95Hn3ZL07s8EjOPKEk3qGxur3dR/73RboXvfKnRalcFVuzvJH
	gilv2J2XKLEUZyQaajEXFScCABysItWoAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t9jAd3mC0qBBl3r+Swu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxpeZr1gL7rFWdH4+y9jA
	+Iali5GDQ0LARKKpm7uLkRPIFJO4cG89WxcjF4eQwCJGiZfnXzJDOLOZJK59ncAOUsUmoCbx
	5cthMFtEQEui+9h5NpBBzAIuEkeniYCYwgJ2Eu+vu4FUsAioSqzYfY0NxOYVsJV4fO0wK4Qt
	KPFj8j0WEJsZaMr6nceZIGx5ic1r3jJDnKYu8eivLsQiPYnZEz5BlYtI7HvxjnECo8AsJJNm
	IZk0C8mkWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjsFn0jsYVzVYHGIU4GBU
	4uH94KgUKMSaWFZcmXuIUYKDWUmEt6MdKMSbklhZlVqUH19UmpNafIgxGejRicxSosn5wPSQ
	VxJvaGxiZmRpZGZhZGJuTpqwkjgv46knAUIC6YklqdmpqQWpRTBbmDg4pRoYWe199N9GXHNI
	/Gnx1efzldQJnEovubdlzJh8e/2FnXsTE87q229M01qUKdugbcvwJl+94ujhw+cyOoME76nL
	aSk+euBmp1U/kWvJx6yVh3XPM1y+/cwobtPrzUX1GXxxjILXJQ6uaJGbfYRT5eAJqZlL07ir
	/7h78v84ej3kiVhqjoHcus7HSizFGYmGWsxFxYkAzyEw9gUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed build warning as below:

drivers/mfd/twl4030-madc.c:788:12: warning: 'twl4030_madc_remove' defined but not used [-Wunused-function]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/twl4030-madc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
index 88ff9dc..86ba920 100644
--- a/drivers/mfd/twl4030-madc.c
+++ b/drivers/mfd/twl4030-madc.c
@@ -785,7 +785,7 @@ err_power:
 	return ret;
 }
 
-static int twl4030_madc_remove(struct platform_device *pdev)
+static int __exit twl4030_madc_remove(struct platform_device *pdev)
 {
 	struct twl4030_madc_data *madc = platform_get_drvdata(pdev);
 
-- 
1.7.2.5


