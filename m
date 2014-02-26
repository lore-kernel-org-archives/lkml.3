Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbaBZC2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 21:28:46 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:51784 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaBZC2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 21:28:44 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-17-530d515a5841
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: t.figa@samsung.com, mturquette@linaro.org
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH] clk: samsung: remove parentheses from return statements
Date: Wed, 26 Feb 2014 11:44:48 +0900
Message-id: <1393382688-5429-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t8zY92oQN5gg3nvLS02Pb7GanF51xw2
	ixnn9zFZPJ1wkc1i0dYv7BbrZ7xmcWDzuHNtD5vH5iX1Hn1bVjF6fN4kF8ASxWWTkpqTWZZa
	pG+XwJUx5+1S5oK5QhW37nxlbGCcy9/FyMkhIWAi8XfKXUYIW0ziwr31bF2MXBxCAssYJU7+
	ec/cxcgBVrT9FCtEfBGjxNmJj5kgnDYmiatffrGDdLMJ6Eo8eT+XGcQWAbLPL7sBVsQsMIVR
	4nvbRxaQhLCAh8T7A7uZQGwWAVWJJYdPsYHYvALuEqtvTWKC2KYgMWeSDUivhMB3Nol57beZ
	IeoFJL5NPsQCUSMrsekAM8TVkhIHV9xgmcAouICRYRWjaGpBckFxUnqRqV5xYm5xaV66XnJ+
	7iZGSIBO3MF4/4D1IcZkoHETmaVEk/OBAZ5XEm9obGZkYWpiamxkbmlGmrCSOG/6o6QgIYH0
	xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwV5w1j7sZHb1nCZCLh/HuVxd+3vIaxKzek7RLsq3g/
	1/TNqf0fefmnLyx4uaZq96uNJosORdo8UEtcf/m8z8TCR4w7r+dWP1WfXaVT9jB4bWad4oGf
	NZ0/dhVFN+Zc/rnXrvLeMwfNGduLbqeY3DLXrdP2cb4pc/+6tXZY42NFx1eRIhuyN1sqsRRn
	JBpqMRcVJwIAWAzJa2YCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t9jAd2oQN5gg683TC02Pb7GanF51xw2
	ixnn9zFZPJ1wkc1i0dYv7BbrZ7xmcWDzuHNtD5vH5iX1Hn1bVjF6fN4kF8AS1cBok5GamJJa
	pJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0XEmhLDGnFCgUkFhc
	rKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYMeftUuaCuUIVt+58ZWxgnMvfxcjBISFgIrH9
	FGsXIyeQKSZx4d56ti5GLg4hgUWMEmcnPmaCcNqYJK5++cUOUsUmoCvx5P1cZhBbBMg+v+wG
	WBGzwBRGie9tH1lAEsICHhLvD+xmArFZBFQllhw+xQZi8wq4S6y+NYkJYrOCxJxJNhMYuRcw
	MqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECA7/Z1I7GFc2WBxiFOBgVOLhDWDhDRZiTSwr
	rsw9xCjBwawkwmvxjSdYiDclsbIqtSg/vqg0J7X4EGMy0PKJzFKiyfnA2MwriTc0NjEzsjQy
	szAyMTcnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBkY32ROvUk20F7veCZsX+vzRW+bi
	jrcxmbz3Vc71c2+esDn+cHzb3h6OBxeYO//97PT99/XqiVd6kpOUDtXPmTGxPeXajprtWatK
	s1JMMzKfdk3boOu6wHNL39no/zs2Lg6SOf/EjOEhy7xFTXdeyrWLbWZ7+VikLfLEwu/zc39N
	iN2/wlKwoTtEiaU4I9FQi7moOBEAWIDl98MCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed following checkpatch warning message
"return is not a function, parentheses are not required"

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/clk/samsung/clk-pll.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/samsung/clk-pll.c b/drivers/clk/samsung/clk-pll.c
index 7fb0a28..32b483f 100644
--- a/drivers/clk/samsung/clk-pll.c
+++ b/drivers/clk/samsung/clk-pll.c
@@ -166,7 +166,7 @@ static inline bool samsung_pll35xx_mp_change(
 	old_mdiv = (pll_con >> PLL35XX_MDIV_SHIFT) & PLL35XX_MDIV_MASK;
 	old_pdiv = (pll_con >> PLL35XX_PDIV_SHIFT) & PLL35XX_PDIV_MASK;
 
-	return (rate->mdiv != old_mdiv || rate->pdiv != old_pdiv);
+	return rate->mdiv != old_mdiv || rate->pdiv != old_pdiv;
 }
 
 static int samsung_pll35xx_set_rate(struct clk_hw *hw, unsigned long drate,
@@ -274,8 +274,8 @@ static inline bool samsung_pll36xx_mpk_change(
 	old_pdiv = (pll_con0 >> PLL36XX_PDIV_SHIFT) & PLL36XX_PDIV_MASK;
 	old_kdiv = (pll_con1 >> PLL36XX_KDIV_SHIFT) & PLL36XX_KDIV_MASK;
 
-	return (rate->mdiv != old_mdiv || rate->pdiv != old_pdiv ||
-		rate->kdiv != old_kdiv);
+	return rate->mdiv != old_mdiv || rate->pdiv != old_pdiv ||
+		rate->kdiv != old_kdiv;
 }
 
 static int samsung_pll36xx_set_rate(struct clk_hw *hw, unsigned long drate,
@@ -387,8 +387,8 @@ static bool samsung_pll45xx_mp_change(u32 pll_con0, u32 pll_con1,
 	old_pdiv = (pll_con0 >> PLL45XX_PDIV_SHIFT) & PLL45XX_PDIV_MASK;
 	old_afc = (pll_con1 >> PLL45XX_AFC_SHIFT) & PLL45XX_AFC_MASK;
 
-	return (old_mdiv != rate->mdiv || old_pdiv != rate->pdiv
-		|| old_afc != rate->afc);
+	return old_mdiv != rate->mdiv || old_pdiv != rate->pdiv
+		|| old_afc != rate->afc;
 }
 
 static int samsung_pll45xx_set_rate(struct clk_hw *hw, unsigned long drate,
@@ -534,8 +534,8 @@ static bool samsung_pll46xx_mpk_change(u32 pll_con0, u32 pll_con1,
 	old_pdiv = (pll_con0 >> PLL46XX_PDIV_SHIFT) & PLL46XX_PDIV_MASK;
 	old_kdiv = (pll_con1 >> PLL46XX_KDIV_SHIFT) & PLL46XX_KDIV_MASK;
 
-	return (old_mdiv != rate->mdiv || old_pdiv != rate->pdiv
-		|| old_kdiv != rate->kdiv);
+	return old_mdiv != rate->mdiv || old_pdiv != rate->pdiv
+		|| old_kdiv != rate->kdiv;
 }
 
 static int samsung_pll46xx_set_rate(struct clk_hw *hw, unsigned long drate,
-- 
1.7.9.5

