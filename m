Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161121Ab3DEBtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 21:49:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:18210 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161029Ab3DEBtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 21:49:33 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-3b-515e2dabc53c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000101ce319f$87f2a3f0$97d7ebd0$%han@samsung.com>
In-reply-to: <000101ce319f$87f2a3f0$97d7ebd0$%han@samsung.com>
Subject: [PATCH 7/7] rtc: rtc-max6902: use spi_set_drvdata()
Date: Fri, 05 Apr 2013 10:49:31 +0900
Message-id: <000701ce319f$d0fa51b0$72eef510$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4xn4fH39zvwb7bR32L9HOXANRbigAAD7oQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zQ901unGBBtO2MlosuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVsX/NWvaCC6wVr3/3MDcwXmLpYuTkkBAwkdja0ssMYYtJXLi3nq2LkYtDSGAZo8Tb
	nnlMMEU7rnWzQiSmM0ps7z7IDOH8YpTomjePDaSKTUBN4suXw+xdjBwcIgL6Em0tGiA1zAK9
	jBJnenezg9QICdhKrP7TA7aaU8BO4uu8DYwgtrCAjcT87YfBzmARUJWYuP4R2ExeoPptXSdY
	IWxBiR+T74H1MgtoSazfeZwJwpaX2LzmLTPIXgkBdYlHf3VBwiICRhJLFt2CKheR2PfiHSPI
	PRICj9gldk9ZxwaxS0Di2+RDLBC9shKbDkBDQlLi4IobLBMYJWYh2TwLyeZZSDbPQrJiASPL
	KkbR1ILkguKk9CJTveLE3OLSvHS95PzcTYyQWJ24g/H+AetDjMlA6ycyS4km5wNjPa8k3tDY
	zMjC1MTU2Mjc0ow0YSVxXvUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjDzadc/MBX/1
	GV8zbnh+8YrPNK+n3p7FTssNQ999UV87XTJWv/lbSlVw455N/YeY8mQdpho/mdViMMvsjOTF
	x2qM77+YrXi+S1741YepQeE9P849E1rn8LZL8YHsnGkSMi5eXCeyKp2utv4O/5F0UHXBkR++
	L+0mdB1T6/hYMft5z64nlqorZiixFGckGmoxFxUnAgBewot46wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQd3VunGBBvPbrCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzNi/Zi17wQXWite/e5gbGC+xdDFyckgImEjs
	uNbNCmGLSVy4t56ti5GLQ0hgOqPE9u6DzBDOL0aJrnnz2ECq2ATUJL58OczexcjBISKgL9HW
	ogFSwyzQyyhxpnc3O0iNkICtxOo/PWAbOAXsJL7O28AIYgsL2EjM336YGcRmEVCVmLj+EdhM
	XqD6bV0nWCFsQYkfk++B9TILaEms33mcCcKWl9i85i0zyF4JAXWJR391QcIiAkYSSxbdgioX
	kdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJEZwI
	nknvYFzVYHGIUYCDUYmHN6MvNlCINbGsuDL3EKMEB7OSCO9OvrhAId6UxMqq1KL8+KLSnNTi
	Q4zJQI9OZJYSTc4HJqm8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh
	4uCUamBcISlgtunSsb6H7/Yz8bx4M+XXVKUXtRl9DRqMwnMk17ZtXRTss6HERufuh+Dq63N3
	q7/KbGqW67KfvWDSR9PGPRELTQ4bOKsZBiZfXecStfVVWm6OccTxtQkJT1240jov8qeU63q+
	X5980V78vtQKiax5G1/N36ITKG402zx8J5vhBHPfTTOVWIozEg21mIuKEwEbzm+vSAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data using
spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-max6902.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-max6902.c b/drivers/rtc/rtc-max6902.c
index 7e4491b..7730a65 100644
--- a/drivers/rtc/rtc-max6902.c
+++ b/drivers/rtc/rtc-max6902.c
@@ -139,7 +139,7 @@ static int max6902_probe(struct spi_device *spi)
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
-	dev_set_drvdata(&spi->dev, rtc);
+	spi_set_drvdata(spi, rtc);
 	return 0;
 }
 
-- 
1.7.2.5


