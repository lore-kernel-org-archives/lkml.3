Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbaIQQlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:41:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36239 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515AbaIQQkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:40:46 -0400
X-AuditID: cbfee68f-f797f6d000001173-ed-5419b989bd3d
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v5 2/3] mfd: max77693: add haptic of_compatible in mfd_cell
Date: Thu, 18 Sep 2014 01:40:25 +0900
Message-id: <1410972026-25189-3-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1410972026-25189-1-git-send-email-jaewon02.kim@samsung.com>
References: <1410972026-25189-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsWyRsSkWLdzp2SIwe9jxhbXvzxntdjRcITV
	4v7Xo4wWl3fNYXNg8bhzbQ+bR9+WVYwenzfJBTBHcdmkpOZklqUW6dslcGVcvHSDseAVW8Wa
	toNsDYwXWLsYOTkkBEwkGqf/YoawxSQu3FvP1sXIxSEksJRRoutsMyNMUc/p6cwQiUWMEt/u
	z2KEcNqYJGbe3wY2ik1AW+L7+sVANgeHiICKxLk35iAms0C+xP9NZiAVwgLeEnuubwGbySKg
	KrG5ayITSAmvgIfEpzNg1RICChJzJtmAVHAKeEo0rL0CVi0EVHFw2ncmkKUSAp/ZJJZNhbiZ
	RUBA4tvkQywQvbISmw5AvSIpcXDFDZYJjMILGBlWMYqmFiQXFCelFxnrFSfmFpfmpesl5+du
	YgSG6+l/z/p3MN49YH2IUYCDUYmHd8NliRAh1sSy4srcQ4ymQBsmMkuJJucDoyKvJN7Q2MzI
	wtTE1NjI3NJMSZx3odTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M82y1WFnFZu+XiHTs
	Px+9+6vKBI4WpvtMc9dPmN7aN8UuzCG8/M/FSubUhn99PSv57gRdjd2XF7H6I/vkf/9+zdn0
	OejT6/XLZEPMJJ7dvSa74pv2rSiDtIeWty+6lc+ff/2bmO8neWOXDVPNPrF8XlOVI+399CP3
	5RfXkyedURHoChX3DEqepsRSnJFoqMVcVJwIADd1tUVSAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+xgG7nTskQg/WtuhbXvzxntdjRcITV
	4v7Xo4wWl3fNYXNg8bhzbQ+bR9+WVYwenzfJBTBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7
	x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gCtU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHr
	GxIE12NkgAYS1jBmXLx0g7HgFVvFmraDbA2MF1i7GDk5JARMJHpOT2eGsMUkLtxbz9bFyMUh
	JLCIUeLb/VmMEE4bk8TM+9vAOtgEtCW+r18MZHNwiAioSJx7Yw5iMgvkS/zfZAZSISzgLbHn
	+hZGEJtFQFVic9dEJpASXgEPiU9nwKolBBQk5kyyAangFPCUaFh7BaxaCKji4LTvTBMYeRcw
	MqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI6GZ1I7GFc2WBxiFOBgVOLh3XBZIkSINbGs
	uDL3EKMEB7OSCK/1RskQId6UxMqq1KL8+KLSnNTiQ4ymQDdNZJYSTc4HRmpeSbyhsYmZkaWR
	uaGFkbG5kjjvgVbrQCGB9MSS1OzU1ILUIpg+Jg5OqQbGRdcCU4rmdwjpPLum9XJR3daJ9Sei
	hA+ziixb7zDpg/r/5SwN/XLN0swCJuU7xPhX3mRY0V93y1nxynqFuVF9V6axaDfuv/d9k9yd
	mjMmaxpX+27hb+pbEfiaufXAp/Xng2vSQsxubBVkrLv2VL8s7YR31i/hnVzX280XyEqW7RNn
	mn5e6HCCEktxRqKhFnNRcSIAr3sXXpwCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add haptic of_compatible in order to use the haptic
device driver using Devicetree.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/max77693.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index fbfed56..5b516fe 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -46,7 +46,10 @@ static const struct mfd_cell max77693_devs[] = {
 	{ .name = "max77693-charger", },
 	{ .name = "max77693-flash", },
 	{ .name = "max77693-muic", },
-	{ .name = "max77693-haptic", },
+	{
+		.name = "max77693-haptic",
+		.of_compatible = "maxim,max77693-haptic",
+	},
 };
 
 static const struct regmap_config max77693_regmap_config = {
-- 
1.7.9.5

