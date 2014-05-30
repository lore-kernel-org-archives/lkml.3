Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbaE3CMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 22:12:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14844 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbaE3CML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 22:12:11 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-2e-5387e8f9bc3e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Inki Dae'" <inki.dae@samsung.com>, dri-devel@lists.freedesktop.org
Cc: "'Seung-Woo Kim'" <sw0312.kim@samsung.com>,
        "'Dave Airlie'" <airlied@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kernel@stlinux.com,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] drm/exynos: remove unnecessary exynos_hdmi.h file
Date: Fri, 30 May 2014 11:12:08 +0900
Message-id: <000a01cf7bac$8f805f60$ae811e20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac97rI9cJVgyXR9gRCaMD23ADLppmg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t8zY92fL9qDDdr+CVtcvbWAyeLK1/ds
	FpPuT2CxuLzwEqvFhxvHWC3ufz3KaLHp8TVWi8u75rBZzDi/j8lixuSXbBardv1hdOD22Dnr
	LrvHnWt72Dzudx9n8ti8pN7j/b6rbB59W1Yxeux+9ovR4/MmuQCOKC6blNSczLLUIn27BK6M
	639/sBYs4Kr48nITawPjYY4uRk4OCQETifb9c5ghbDGJC/fWs3UxcnEICSxjlDjcP4sRpujD
	jitQiemMEs2XjzJDOL8ZJe59Pc0CUsUmoCbx5cthdhBbRMBN4vXj/ywgRcwCh5gkXq/pBEsI
	CzhJbDgPsY9FQFVi5tIvYM28ArYSUycvYIawBSV+TL4HFmcW0JLYvK2JFcKWl9i85i1QDQfQ
	SeoSj/7qQuzSkzh3ZR8zRImIxL4X7xhB9koItHJIfGmYwg6xS0Di2+RDLBC9shKbDkC9LClx
	cMUNlgmMYrOQbJ6FZPMsJJtnIVmxgJFlFaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZIVPfu
	YLx9wPoQYzLQ+onMUqLJ+cCkkFcSb2hsZmRhamJqbGRuaUaasJI4b9LDpCAhgfTEktTs1NSC
	1KL4otKc1OJDjEwcnFINjE3i4V8ENh1wvBhzZNrCM9s+2V8u1hI3O25vGph8peLhhZeTEw7N
	4pGVZp7pJvrB4Z9ZNVtig4nNcc50jgcTioO3/dnkpmlzwOtA91aLrEr9mVYTr7qKv97qlCLC
	G+z8ZP9j5vdNIVtey9TJ29TmNclHcP5J2SypuSii6sTfuOyVXzbNMb36SYmlOCPRUIu5qDgR
	AICNg8EAAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsVy+t9jQd2fL9qDDZZs5Le4emsBk8WVr+/Z
	LCbdn8BicXnhJVaLDzeOsVrc/3qU0WLT42usFpd3zWGzmHF+H5PFjMkv2SxW7frD6MDtsXPW
	XXaPO9f2sHnc7z7O5LF5Sb3H+31X2Tz6tqxi9Nj97Bejx+dNcgEcUQ2MNhmpiSmpRQqpecn5
	KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAlyoplCXmlAKFAhKLi5X07TBN
	CA1x07WAaYzQ9Q0JgusxMkADCesYM67//cFasICr4svLTawNjIc5uhg5OSQETCQ+7LjCBmGL
	SVy4tx7I5uIQEpjOKNF8+SgzhPObUeLe19MsIFVsAmoSX74cZgexRQTcJF4//s8CUsQscIhJ
	4vWaTrCEsICTxIbzc5hBbBYBVYmZS7+ANfMK2EpMnbyAGcIWlPgx+R5YnFlAS2LztiZWCFte
	YvOat0A1HEAnqUs8+qsLsUtP4tyVfcwQJSIS+168Y5zAKDALyaRZSCbNQjJpFpKWBYwsqxhF
	UwuSC4qT0nON9IoTc4tL89L1kvNzNzGCU8Yz6R2MqxosDjEKcDAq8fBOSG8PFmJNLCuuzD3E
	KMHBrCTCm/UAKMSbklhZlVqUH19UmpNafIgxGejRicxSosn5wHSWVxJvaGxiZmRpZGZhZGJu
	TpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MFl4PDmXJ893hvN7HeWHOkZSnyq7XJD/F
	3bqw5WCnvpbAHsFdvbfi11WnHV+2Oe1CYNgGZs6Jbo0N3D+0d35RE/q7LUxGK+/X1DJ288eZ
	FlaKD8w3Jx1Uu7+E44h0e/3tVZ7y/q9rygqOvLS21BX7Xxrtt3FHnr7jj8S+5wFKq4VerEja
	ExahxFKckWioxVxUnAgARVqCAV0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The exynos_hdmi.h has been used for the dedicated i2c drivers
that were already removed. Thus, the unnecessary exynos_hdmi.h
should be removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_hdmi.h |   23 -----------------------
 1 file changed, 23 deletions(-)
 delete mode 100644 drivers/gpu/drm/exynos/exynos_hdmi.h

diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.h b/drivers/gpu/drm/exynos/exynos_hdmi.h
deleted file mode 100644
index 0ddf395..0000000
--- a/drivers/gpu/drm/exynos/exynos_hdmi.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/*
- *
- * Copyright (c) 2011 Samsung Electronics Co., Ltd.
- * Authors:
- *	Inki Dae <inki.dae@samsung.com>
- *	Seung-Woo Kim <sw0312.kim@samsung.com>
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-
-#ifndef _EXYNOS_HDMI_H_
-#define _EXYNOS_HDMI_H_
-
-void hdmi_attach_ddc_client(struct i2c_client *ddc);
-void hdmi_attach_hdmiphy_client(struct i2c_client *hdmiphy);
-
-extern struct i2c_driver hdmiphy_driver;
-extern struct i2c_driver ddc_driver;
-
-#endif
-- 
1.7.10.4


