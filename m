Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbbA2Ipt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:45:49 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:11618 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbbA2Ipq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:45:46 -0500
X-AuditID: cbfee68d-f79296d000004278-4b-54c9f335258c
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: Inki Dae <inki.dae@samsung.com>, Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH 1/2] extcon: max77693: Fix cable name of MHL-TA
Date: Thu, 29 Jan 2015 17:45:23 +0900
Message-id: <1422521124-508-2-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1422521124-508-1-git-send-email-jaewon02.kim@samsung.com>
References: <1422521124-508-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsWyRsSkSNf088kQg2kftC2uf3nOajHp/gQW
	ix0NR1gtLu+aw+bA4tG3ZRWjx+dNcgFMUVw2Kak5mWWpRfp2CVwZV/+dZC54wV/xbdFEtgbG
	GzxdjJwcEgImEnf7PjJB2GISF+6tZ+ti5OIQEljKKPF14T6WLkYOsKKrWzkh4tMZJR61PWCE
	cNqYJGa0vmAB6WYT0Jb4vn4xK4gtIuAm8e3TH2YQm1nAS2LH5bWMILawgL3E1fkfwGwWAVWJ
	DYvmgNm8QPU3J3YyQSxTkJgzyQYkzCngLjHn3lyw8UJAJe82zmCBOPQ1m8Suc6IQYwQkvk0+
	BHWnrMSmA8wQJZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kaFecWJucWleul5yfu4mRmCYnv73
	rHcH4+0D1ocYBTgYlXh4ExpPhgixJpYVV+YeYjQF2jCRWUo0OR8YDXkl8YbGZkYWpiamxkbm
	lmZK4ryKUj+DhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTCWxxtH5VUrPesVqRVKfKm30sRB
	Nu/JgWPPvH5MmsvyZoGs81ddI7vTb5cwiAs6zTITrn1/5Fv9D46MrZZbpnlPYu0WYHN0Pi7M
	WBnkI/BQgElPL/JZUuyGs0fzq98yzq2LO7x6Y4X84xkhOivnXamemhdTf2CVwDTRj/Ln71xQ
	LPzfx6QjuEuJpTgj0VCLuag4EQBVDfy5TgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42I5/e+xoK7p55MhBk8/qFhc//Kc1WLS/Qks
	FjsajrBaXN41h82BxaNvyypGj8+b5AKYohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
	dQ0tLcyVFPISc1NtlVx8AnTdMnOANikplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0Jgusx
	MkADCWsYM67+O8lc8IK/4tuiiWwNjDd4uhg5OCQETCSubuXsYuQEMsUkLtxbz9bFyMUhJDCd
	UeJR2wNGCKeNSWJG6wsWkCo2AW2J7+sXs4LYIgJuEt8+/WEGsZkFvCR2XF7LCGILC9hLXJ3/
	AcxmEVCV2LBoDpjNC1R/c2InE8RiBYk5k2xAwpwC7hJz7s0FGy8EVPJu4wyWCYy8CxgZVjGK
	phYkFxQnpeca6RUn5haX5qXrJefnbmIEx8Ez6R2MqxosDjEKcDAq8fAmNJ4MEWJNLCuuzD3E
	KMHBrCTCK/4GKMSbklhZlVqUH19UmpNafIjRFOioicxSosn5wBjNK4k3NDYxM7I0Mje0MDI2
	VxLnVbJvCxESSE8sSc1OTS1ILYLpY+LglGpglMrK+b2Yt/D8mjMpFbd+dkntfzKP8/ZDgUr2
	XDkW99nsfU7/9q9U3XLvzMQH+mf3Lfd5avA3PeDEERX3q8/K48qV57madG+5utOvge9xVmTw
	BGu7inMGujwxwvrR2yqmvxRcU35PkO+w6RbPpDpV7S0H1hfPaZkgITrpxtu+vEa9ZzvntEUu
	V2Ipzkg01GIuKk4EALVpbNiZAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes extcon cable name of MHL-TA instead of MHL_TA
to unify cable name style.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
---
 drivers/extcon/extcon-max77693.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 740a14d..1c2af58 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -228,7 +228,7 @@ static const char *max77693_extcon_cable[] = {
 	[EXTCON_CABLE_SLOW_CHARGER]		= "Slow-charger",
 	[EXTCON_CABLE_CHARGE_DOWNSTREAM]	= "Charge-downstream",
 	[EXTCON_CABLE_MHL]			= "MHL",
-	[EXTCON_CABLE_MHL_TA]			= "MHL_TA",
+	[EXTCON_CABLE_MHL_TA]			= "MHL-TA",
 	[EXTCON_CABLE_JIG_USB_ON]		= "JIG-USB-ON",
 	[EXTCON_CABLE_JIG_USB_OFF]		= "JIG-USB-OFF",
 	[EXTCON_CABLE_JIG_UART_OFF]		= "JIG-UART-OFF",
@@ -823,19 +823,19 @@ static int max77693_muic_chg_handler(struct max77693_muic_info *info)
 		case MAX77693_MUIC_GND_MHL:
 		case MAX77693_MUIC_GND_MHL_VB:
 			/*
-			 * MHL cable with MHL_TA(USB/TA) cable
+			 * MHL cable with MHL-TA(USB/TA) cable
 			 * - MHL cable include two port(HDMI line and separate
 			 * micro-usb port. When the target connect MHL cable,
-			 * extcon driver check whether MHL_TA(USB/TA) cable is
-			 * connected. If MHL_TA cable is connected, extcon
+			 * extcon driver check whether MHL-TA(USB/TA) cable is
+			 * connected. If MHL-TA cable is connected, extcon
 			 * driver notify state to notifiee for charging battery.
 			 *
-			 * Features of 'MHL_TA(USB/TA) with MHL cable'
+			 * Features of 'MHL-TA(USB/TA) with MHL cable'
 			 * - Support MHL
 			 * - Support charging through micro-usb port without
 			 *   data connection
 			 */
-			extcon_set_cable_state(info->edev, "MHL_TA", attached);
+			extcon_set_cable_state(info->edev, "MHL-TA", attached);
 			if (!cable_attached)
 				extcon_set_cable_state(info->edev,
 						      "MHL", cable_attached);
-- 
1.7.9.5

