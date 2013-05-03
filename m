Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247Ab3ECGiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:38:50 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:62154 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933166Ab3ECGir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:38:47 -0400
X-AuditID: cbfee690-b7f136d000000fea-15-51835b758dd0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 39/42] rtc: rtc-m48t86: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:38:45 +0900
Message-id: <003501ce47c8$dc68cc90$953a65b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HyNuV6TwPU/dRQa+6xEwqKDPDrA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zY93S6OZAg1dLDS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKaPw2k7VgNVvFlnWT2RoYF7B2MXJySAiYSHxbdJwRwhaTuHBvPVsXIxeHkMAyRomD
	h1YxwxQ9bj8GlVjEKPFj3TpGCOcXo8Tb4/vA2tkE1CS+fDnM3sXIwSEioC/R1qIBUsMs0M0o
	8ah5LtgkYYFgiddNv8FWswioSsxcex6sl1fAUmLv9KVMELagxI/J91hAbGYBLYn1O48zQdjy
	EpvXvIW6SEFix9nXYL0iAnoSbX33GCFqRCT2vXgHdpyEwDF2ie+vtjBDLBOQ+Db5EAvIcRIC
	shKbDkDNkZQ4uOIGywRGsVlIVs9CsnoWktWzkKxYwMiyilE0tSC5oDgpvchErzgxt7g0L10v
	OT93EyMk+ibsYLx3wPoQYzLQ+onMUqLJ+cDozSuJNzQ2M7IwNTE1NjK3NCNNWEmcV73FOlBI
	ID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY4TZ2vydwZF8i7ZeOPJUQ5m3b8XJhvqLrM6dbO8/
	eC95Inxy3jY/a6ftnNZ8X24UfZ68/ZZ30fJLrLG1ds1z7na9ydTr//pdc1cjw2u1B5+uaW0t
	ZKgxfOhuGjw55eDiv9fyZqRzs/qKXjz8wl7lZXhp9ta0xEMLK38ozCuTKticdFR8dXhFvxJL
	cUaioRZzUXEiABsB+0fUAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAd3S6OZAg/X3dS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzGj8NpO1YDVbxZZ1k9kaGBewdjFyckgImEg8
	bj/GBmGLSVy4tx7I5uIQEljEKPFj3TpGCOcXo8Tb4/sYQarYBNQkvnw5zN7FyMEhIqAv0dai
	AVLDLNDNKPGoeS4zSI2wQLDE66bfYBtYBFQlZq49D9bLK2ApsXf6UiYIW1Dix+R7LCA2s4CW
	xPqdx5kgbHmJzWveMkNcpCCx4+xrsF4RAT2Jtr57jBA1IhL7XrxjnMAoMAvJqFlIRs1CMmoW
	kpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYJj+5n0DsZVDRaHGAU4GJV4eBVamgKF
	WBPLiitzDzFKcDArifC6/QAK8aYkVlalFuXHF5XmpBYfYkwG+nQis5Rocj4w7eSVxBsam5gZ
	WRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2P30YZnRhWzZ8cG3f/Xc/5R
	2qYLu97vip8Qs+ksa9He4PZEhx8d0qd+3Tf7qvP+Zraz29HPn7oCf5/6c6r14aapew6rnzgn
	fafZrqj6hlq4zeP9/aerg6suNDMJpuyLLjgU8mjpUZu6iCm3zh4PSd0jsV7labb5Ru2SG9lr
	RB2+twjd/VM9az6/EktxRqKhFnNRcSIA7e5XODEDAAA=
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
 drivers/rtc/rtc-m48t86.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-m48t86.c b/drivers/rtc/rtc-m48t86.c
index 33a91c4..d1fe7f5 100644
--- a/drivers/rtc/rtc-m48t86.c
+++ b/drivers/rtc/rtc-m48t86.c
@@ -168,8 +168,6 @@ static int m48t86_rtc_probe(struct platform_device *dev)
 
 static int m48t86_rtc_remove(struct platform_device *dev)
 {
-	platform_set_drvdata(dev, NULL);
-
 	return 0;
 }
 
-- 
1.7.2.5


