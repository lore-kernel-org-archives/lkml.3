Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762527Ab3ECGUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:20:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:58144 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762119Ab3ECGUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:20:50 -0400
X-AuditID: cbfee691-b7fe56d000004b96-3d-518357404715
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 01/42] rtc: rtc-88pm80x: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:20:48 +0900
Message-id: <000f01ce47c6$5a452260$0ecf6720$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5Hxlbc84vAr6v8QkqFhtckplBvlQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zA12H8OZAg2uL5C2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKePeoha3gAVvF4RlzGRsYL7N2MXJySAiYSPw/cJwFwhaTuHBvPVsXIxeHkMAyRolf
	W/bCFV3afJsVIjGdUeL1xSksEM4vRomNl26BtbMJqEl8+XKYvYuRg0NEQF+irUUDpIZZoJdR
	4kzvbnaQGmGBEInPU3exgdgsAqoS53a+BYvzClhKNL3ayQRhC0r8mHwPbCazgJbE+p3HmSBs
	eYnNa94yQ1ykILHj7GtGEFtEQE/iSOcsqHoRiX0v3jGCLJYQOMYusef7bhaIZQIS3yYfYgE5
	TkJAVmLTAag5khIHV9xgmcAoNgvJ6llIVs9CsnoWkhULGFlWMYqmFiQXFCelF5nqFSfmFpfm
	pesl5+duYoRE38QdjPcPWB9iTAZaP5FZSjQ5Hxi9eSXxhsZmRhamJqbGRuaWZqQJK4nzqrdY
	BwoJpCeWpGanphakFsUXleakFh9iZOLglGpgLF82c8HFDCmNhMIkQc8GNp6DYaLnvJKbZmU+
	bdM0U/n430eCuWmT4uuGIzFs9ufLM2+oexj3Lsx2+Dg7OLK7JDm9zGRZxIwLr87O2NOm+I5N
	9YOS9JME/VMMqh9Z+aP3Hj/4YlJYwMKWP8F/2zmFwp4wRen/fSby6kZU8+Kf6+WO9xTf+NOp
	xFKckWioxVxUnAgAYUcnzdQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jQV2H8OZAgwuPpC2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzHj3qIWt4AFbxeEZcxkbGC+zdjFyckgImEhc
	2nwbyhaTuHBvPVsXIxeHkMB0RonXF6ewQDi/GCU2XrrFAlLFJqAm8eXLYfYuRg4OEQF9ibYW
	DZAaZoFeRokzvbvZQWqEBUIkPk/dxQZiswioSpzb+RYszitgKdH0aicThC0o8WPyPbCZzAJa
	Eut3HmeCsOUlNq95ywxxkYLEjrOvGUFsEQE9iSOds6DqRST2vXjHOIFRYBaSUbOQjJqFZNQs
	JC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgTH9jOpHYwrGywOMQpwMCrx8Cq0NAUK
	sSaWFVfmHmKU4GBWEuF1+wEU4k1JrKxKLcqPLyrNSS0+xJgM9OlEZinR5Hxg2skriTc0NjEz
	sjQyszAyMTcnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBsbeG1l/175/eF1ESEioy27p
	pKORU9iYNTpWWk5pP6qnUL3AQnWCVfj0npC/GWsu35taXtzEqNv669S2mGD19dFT3r3VZBWf
	IeXecCX9vNMjlp1n1p/Wk5npcUlYPPeu8U+j2vMFygeZPn43UbH3W/5ap7Hpxp+C5179YsWr
	TDf1GyXvuXP++mclluKMREMt5qLiRAAwnbBdMQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
(device-core: Ensure drvdata = NULL when no driver is bound).
Thus, it is not needed to manually clear the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-88pm80x.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-88pm80x.c b/drivers/rtc/rtc-88pm80x.c
index f3742f3..354c937 100644
--- a/drivers/rtc/rtc-88pm80x.c
+++ b/drivers/rtc/rtc-88pm80x.c
@@ -345,7 +345,6 @@ out:
 static int pm80x_rtc_remove(struct platform_device *pdev)
 {
 	struct pm80x_rtc_info *info = platform_get_drvdata(pdev);
-	platform_set_drvdata(pdev, NULL);
 	pm80x_free_irq(info->chip, info->irq, info);
 	return 0;
 }
-- 
1.7.2.5


