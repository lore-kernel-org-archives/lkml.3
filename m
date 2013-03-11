Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab3CKGbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 02:31:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18774 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3CKGbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 02:31:42 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-59-513d7a4bbb26
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
In-reply-to: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
Subject: [PATCH 02/14] power: max8925_power: use devm_kzalloc()
Date: Mon, 11 Mar 2013 15:31:39 +0900
Message-id: <007201ce1e22$163b7600$42b26200$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4eIfOI6J7YtEddQ/Gjh19YaZUzVAAAA1VQ
Content-language: ko
x-cr-hashedpuzzle: ZPg= BBbL DlvU Ei6m G7CI H7NP JVKC KxxS PsaE Sise gDYM iSEV
 momi ofra rA2Y
 tdiK;4;YQBuAHQAbwBuAEAAZQBuAG8AbQBzAGcALgBvAHIAZwA7AGQAdwBtAHcAMgBAAGkAbgBmAHIAYQBkAGUAYQBkAC4AbwByAGcAOwBqAGcAMQAuAGgAYQBuAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{C5DE7C8C-5A28-4C7A-96B3-8D7750890E20};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Mon,
 11 Mar 2013 06:31:32
 GMT;WwBQAEEAVABDAEgAIAAwADIALwAxADQAXQAgAHAAbwB3AGUAcgA6ACAAbQBhAHgAOAA5ADIANQBfAHAAbwB3AGUAcgA6ACAAdQBzAGUAIABkAGUAdgBtAF8AawB6AGEAbABsAG8AYwAoACkA
x-cr-puzzleid: {C5DE7C8C-5A28-4C7A-96B3-8D7750890E20}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t8zA13vKttAg//3BSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGhVv/2QvOcFRM+PqAsYGxm72LkZNDQsBE4s6sF4wQtpjEhXvr
	2boYuTiEBJYxSnw6uJgRpujd+UWsEIlFjBIrF61kgXBmM0m0buhnBaliE1CT+PLlMNhYEQEN
	ibbVU1hAbGaBfInDhy6D2UICthK7f0Ks4xSwk7ix7BIbiC0sYC/R+XwamM0ioCrxZNdRsDm8
	QPWPHv5lhbAFJX5Mvgc1U0ti87YmVghbXmLzmrfMXYwcQJeqSzz6qwtiiggYSTxfXApRISKx
	78U7RpCTJQResEhM2XIX6ntTiZ97HjFB2LvYJf4+4YY4QUDi2+RDLBAjZSU2HWCGKJGUOLji
	BssERqlZSA6aheSgWUgOmoVk9QJGllWMoqkFyQXFSelFpnrFibnFpXnpesn5uZsYIZE4cQfj
	/QPWhxiTgdZPZJYSTc4HRnJeSbyhsZmRhamJqbGRuaUZacJK4rzqLdaBQgLpiSWp2ampBalF
	8UWlOanFhxiZODilGhgl+Gcs8G3fGOk0Q37ds3vfpJ8aBDInNvCLODOLSy79O6N8T9bZvI0P
	7NYuz+6Zf0XDY6bmC2ZxpsOP60+0RDxk/X782s197vnC4vM8EvKMH+RvTDgaoB/+Z811g/SO
	Q7n3Lq95Pv/e60xxfbWbNXe3Ft7JnH/28zaxSEe9aparzCpfZ3W4dYcqsRRnJBpqMRcVJwIA
	ryJgXtoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t9jAV3vKttAg23zeSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxoVb/9kLznBUTPj6gLGB
	sZu9i5GTQ0LAROLd+UWsELaYxIV769m6GLk4hAQWMUqsXLSSBcKZzSTRuqEfrIpNQE3iy5fD
	YN0iAhoSbaunsIDYzAL5EocPXQazhQRsJXb/fMEIYnMK2EncWHaJDcQWFrCX6Hw+DcxmEVCV
	eLLrKNgcXqD6Rw//skLYghI/Jt+DmqklsXlbEyuELS+xec1b5i5GDqBL1SUe/dUFMUUEjCSe
	Ly6FqBCR2PfiHSPIyRICL1gkpmy5C/WkqcTPPY+YJjCKzEKyYRaSDbOQbJiFZNYCRpZVjKKp
	BckFxUnpuYZ6xYm5xaV56XrJ+bmbGMGR/kxqB+PKBotDjAIcjEo8vBN0bAOFWBPLiitzDzFK
	cDArifCu3GQTKMSbklhZlVqUH19UmpNafIgxGRgAE5mlRJPzgUkoryTe0NjEzMjSyMzCyMTc
	nDRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoY40ssKtendf/6ezltbfCzTKefi1fsrN89
	1eX3330s3/sE7r8u/Vk3Lys/qHzDQodgnk+MmkIJtezeF7/enJP5dll94o+cjV/urGmbMXPF
	AZW1muvNbvgEcp5aKJO/vMP8yBQxI+0/U02+Fqipc65wN7ze/rsnIbswKdX9ZIZIhYfB4YM6
	r64fVmIpzkg01GIuKk4EAGQoIlw4AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/power/max8925_power.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
index 665cdc7..0ee1e14 100644
--- a/drivers/power/max8925_power.c
+++ b/drivers/power/max8925_power.c
@@ -489,7 +489,8 @@ static int max8925_power_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	info = kzalloc(sizeof(struct max8925_power_info), GFP_KERNEL);
+	info = devm_kzalloc(&pdev->dev, sizeof(struct max8925_power_info),
+				GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 	info->chip = chip;
@@ -546,7 +547,6 @@ out_battery:
 out_usb:
 	power_supply_unregister(&info->ac);
 out:
-	kfree(info);
 	return ret;
 }
 
@@ -559,7 +559,6 @@ static int max8925_power_remove(struct platform_device *pdev)
 		power_supply_unregister(&info->usb);
 		power_supply_unregister(&info->battery);
 		max8925_deinit_charger(info);
-		kfree(info);
 	}
 	return 0;
 }
-- 
1.7.2.5


