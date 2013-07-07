Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab3GPIXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 04:23:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32422 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab3GPIXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 04:23:35 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-11-51e50300e70d
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: sbkim73@samsung.com, broonie@kernel.org, lgirdwood@gmail.com,
        yadi.brar01@gmail.com, Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH] regulator: s2mps11: Add linux/of.h header
Date: Sun, 07 Jul 2013 13:44:49 +0530
Message-id: <1373184889-16929-1-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsWyRsSkSpeB+WmgwfenlhZTHz5hs/h2pYPJ
	4vKuOWwWF1d8YbKY+7uR1WLO9HdMDmweO2fdZffYtKqTzaNvyypGj8+b5AJYorhsUlJzMstS
	i/TtErgyHm9sZCo4xlqxcP8v5gbG2yxdjJwcEgImEmuvPYCyxSQu3FvP1sXIxSEksJRRYs6V
	Z8wwRSd+TYZKLGKUeL/sHzOE08YksX7OUqYuRg4ONgEjiVfH7EAaRAQUJDb3PmMFsZkF2hkl
	Ws9xg9jCAlYSh29uYASxWQRUJe53PAVbwCvgKvF80zWoZQoSrcsOsYPMlxD4ziaxfeslZogG
	AYlvkw+xgOySEJCV2HQAql5S4uCKGywTGAUXMDKsYhRNLUguKE5KLzLRK07MLS7NS9dLzs/d
	xAgM0dP/nk3YwXjvgPUhxmSgcROZpUST84EhnlcSb2hsZmRhamJqbGRuaUaasJI4r3qLdaCQ
	QHpiSWp2ampBalF8UWlOavEhRiYOTqkGxhl1H0PFD1Tf3yf5TzSN82v+4naRuli1a6LFiWmN
	fBMlDHnknO9zRipwev943Gj6pLW4c5VEWLxV2yOL2kNimw2r2n7cXRJvWpzm3pH5ddUFI/NP
	9c1yMrqNNotW98zaF/vMz7FZJUSU9Xe5u2HO45UiPhtiHblV2V7UL96YVWfGZRg4X0+JpTgj
	0VCLuag4EQAQfTIEZwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t9jAV0G5qeBBgvWGVhMffiEzeLblQ4m
	i8u75rBZXFzxhcli7u9GVos5098xObB57Jx1l91j06pONo++LasYPT5vkgtgiWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzHi8sZGp4BhrxcL9v5gbGG+zdDFyckgImEic
	+DWZDcIWk7hwbz2QzcUhJLCIUeL9sn/MEE4bk8T6OUuZuhg5ONgEjCReHbMDaRARUJDY3PuM
	FcRmFmhnlGg9xw1iCwtYSRy+uYERxGYRUJW43/GUGcTmFXCVeL7pGjPEMgWJ1mWH2Ccwci9g
	ZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERwBz6R2MK5ssDjEKMDBqMTDK8HzJFCINbGs
	uDL3EKMEB7OSCG/iJqAQb0piZVVqUX58UWlOavEhxmSg7ROZpUST84HRmVcSb2hsYm5qbGpp
	YmFiZkmasJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjAks++TnmLheyj5w99cd3d03OO5F
	RxUumSmhGScQeffamvVCDx6sWtfE7KzKvXL6v2rOTrFTAXc/+oW+V+x99+mmjLrufym7Z9zr
	5T1/P+k+8OeaO6+ZXN7ZTT/5K7NmLLxy5d/Pe7MF2yT/fphzzPmUor+u9KMnos7MWzf2vmM8
	x7aBM04xYooSS3FGoqEWc1FxIgDz4oAKxAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds linux/of.h required to fix an error and warning reported by
kbuild test robot for some x86 config file.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/regulator/s2mps11.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index e1aadbd..350e04f 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/regmap.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
-- 
1.7.0.4

