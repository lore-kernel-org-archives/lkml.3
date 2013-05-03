Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762649Ab3ECGZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:25:13 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20566 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762637Ab3ECGZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:25:11 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-56-518358469100
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 06/42] rtc: rtc-at91rm9200: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:25:10 +0900
Message-id: <001401ce47c6$f6787830$e3696890$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HxvXIL1sc/mT1T/i0JajOvsdEDw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zQ123iOZAg/3X5C2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKeD31G3PBXraKVbt3szYwbmXtYuTkkBAwkXjbtZQJwhaTuHBvPVsXIxeHkMAyRome
	vvmMXYwcYEXfD4lDxBcxSjzechmsQUjgF6PEk8NlIDabgJrEly+H2UHqRQT0JdpaNEDqmQW6
	GSUeNc9lBokLC4RL7G9jASlnEVCVmLz2J9gYXgFLiW+zLkLZghI/Jt8Dq2EW0JJYv/M4E4Qt
	L7F5zVtmiDsVJHacfc0IYosI6EmsfLydGaJGRGLfi3eMIHslBI6xS1zruM4IsUxA4tvkQywQ
	v8hKbDoANUdS4uCKGywTGMVmIVk9C8nqWUhWz0KyYgEjyypG0dSC5ILipPQiI73ixNzi0rx0
	veT83E2MkLjr28F484D1IcZkoPUTmaVEk/OBcZtXEm9obGZkYWpiamxkbmlGmrCSOK9ai3Wg
	kEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkbrCc+N5tjMZpp+p+xcc7SC7aqsxOI8/d5D1nN1
	aw0WslUoTmAznJXbs+xQvhdjtdm5dhv1ZatKvPe79erfPVPyfLr2i/uB4Qf6bi950Hlldzaf
	Ss+a2xwPZi62SBbY6KF1LoVx3QtRs4VLL5YJM/BWHw/q5z7NNHXP3n/qIVzHpx9fkPs6+ZsS
	S3FGoqEWc1FxIgAV0OVA0QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jAV23iOZAg5snZSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzHg99RtzwV62ilW7d7M2MG5l7WLk4JAQMJH4
	fki8i5ETyBSTuHBvPVsXIxeHkMAiRonHWy4zgSSEBH4xSjw5XAZiswmoSXz5cpgdpFdEQF+i
	rUUDpJ5ZoJtR4lHzXGaQuLBAuMT+NhaQchYBVYnJa3+CjeEVsJT4NusilC0o8WPyPbAaZgEt
	ifU7jzNB2PISm9e8ZYa4R0Fix9nXjCC2iICexMrH25khakQk9r14xziBUWAWklGzkIyahWTU
	LCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIER/Uz6R2MqxosDjEKcDAq8fAqtDQF
	CrEmlhVX5h5ilOBgVhLhdfsBFOJNSaysSi3Kjy8qzUktPsSYDPTpRGYp0eR8YMLJK4k3NDYx
	M7I0MrMwMjE3J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQbGLTd/Tve5bCB02/FN4aGm
	E2ujxPk8q36zn+fPOHXfnrP1/KyPd7ZNXXjgpMwu95dHnjy5FrdS6FY7m4jY9hdzNmQErZRP
	Nz/2XbGEcb9jRvK2vq+r25qbjmtptcm2zKm8v/FpTXeq0pwJ6n9PNjxW8hL9oehbpl51WPN1
	75bQOd3Zdle/5ggsUmIpzkg01GIuKk4EALCOzTEuAwAA
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
 drivers/rtc/rtc-at91rm9200.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index 0eab77b..5a04b16 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -342,7 +342,6 @@ static int __exit at91_rtc_remove(struct platform_device *pdev)
 
 	rtc_device_unregister(rtc);
 	iounmap(at91_rtc_regs);
-	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
-- 
1.7.2.5


