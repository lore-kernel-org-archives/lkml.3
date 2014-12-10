Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbaLJIqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 03:46:53 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:9400 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbaLJIqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 03:46:48 -0500
X-AuditID: cbfee68e-f79b46d000002b74-98-548808757293
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: robh+dt@kernel.org, kgene@kernel.org, alim.akhtar@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/2] Documentation: dt-bindings: Add aliases information for
 Exynos7 pin controllers
Date: Wed, 10 Dec 2014 14:09:39 +0530
Message-id: <1418200780-22363-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 2.2.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsWyRsSkWreUoyPEYO8Ea4sH87axWcw/co7V
	ou3KQXaL/sevmS2m/FnOZHF51xw2ixnn9zFZLFrWymzRuvcIu8WqXX8YHbg8ds66y+6xaVUn
	m8eda3vYPPq2rGL0+LxJLoA1issmJTUnsyy1SN8ugSvjwFuZgstcFduuPWJuYGzm7GLk5JAQ
	MJHY/uEoE4QtJnHh3nq2LkYuDiGBpYwSB27MZYUpmtPbzAyRWMQo8f/uZkYIZwKTxOa+J4wg
	VWwCuhJNb3eB2SICNRJTbl1hByliFtjLKHFv1yGwUcICaRI9HR/B9rEIqEpMWNLHDmLzCnhI
	nGqeCXWHnMSWW4/AmiUEprNLHLv9iRGiQUDi2+RDLF2MHEAJWYlNB5gh6iUlDq64wTKBUXAB
	I8MqRtHUguSC4qT0IiO94sTc4tK8dL3k/NxNjMCwPv3vWd8OxpsHrA8xCnAwKvHwBlxuDxFi
	TSwrrsw9xGgKtGEis5Rocj4wevJK4g2NzYwsTE1MjY3MLc2UxHkTpH4GCwmkJ5akZqemFqQW
	xReV5qQWH2Jk4uCUamAsrtxUpDlvUlpxFdPJv/fjMlruN1jPlc8Va69W1y7q7n4uVs4lX71A
	KzJAbkLy5vuTvC6cmRLZ/GziX+7tuw/3yna0KwdNqvd+zx/zRD9+HadlqJr01BP5n5sLgp6d
	MT2dPHfqnrAJWYyzilIeT7dcGpYpNf9by4uHzxa84O/TWpyS1+cvoafEUpyRaKjFXFScCABw
	Q7SqZgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLIsWRmVeSWpSXmKPExsVy+t9jAd1Sjo4Qg203DS0ezNvGZjH/yDlW
	i7YrB9kt+h+/ZraY8mc5k8XlXXPYLGac38dksWhZK7NF694j7Bardv1hdODy2DnrLrvHplWd
	bB53ru1h8+jbsorR4/MmuQDWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3Ml
	hbzE3FRbJRefAF23zBygs5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWM
	GQfeyhRc5qrYdu0RcwNjM2cXIyeHhICJxJzeZmYIW0ziwr31bF2MXBxCAosYJf7f3cwI4Uxg
	ktjc94QRpIpNQFei6e0uMFtEoEZiyq0r7CBFzAJ7GSXu7TrECpIQFkiT6On4yARiswioSkxY
	0scOYvMKeEicap7JBLFOTmLLrUfsExi5FzAyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQI
	jppn0jsYVzVYHGIU4GBU4uENuNweIsSaWFZcmXuIUYKDWUmEdztrR4gQb0piZVVqUX58UWlO
	avEhRlOg7ROZpUST84ERnVcSb2hsYm5qbGppYmFiZqkkzqtk3xYiJJCeWJKanZpakFoE08fE
	wSnVwNi4QsL/bITcFb3Pq15dWyZZ7feyTigispZRRPEd95s1Vx/arNFv+SEzVfShoNiGz9OW
	2J6dPHsPT05lMI+S6oUpS+KCvv+UmX1ln8erP+cDVl2qSRe7/DTtLFO9s/HuiZ5/CoNkX0n6
	fzwftO59nIvK12p1eZ19AYdED081FzktaNhY4hn3L1iJpTgj0VCLuag4EQCWTMagsAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding list of aliases for supported Exynos7 pin controller blocks.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 .../devicetree/bindings/pinctrl/samsung-pinctrl.txt          |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
index 8425838..742e472 100644
--- a/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
@@ -171,6 +171,16 @@ Aliases:
 All the pin controller nodes should be represented in the aliases node using
 the following format 'pinctrl{n}' where n is a unique number for the alias.
 
+Aliases for controllers compatible with "samsung,exynos7-pinctrl":
+- pinctrl0: pin controller of ALIVE block,
+- pinctrl1: pin controller of BUS0 block,
+- pinctrl2: pin controller of NFC block,
+- pinctrl3: pin controller of TOUCH block,
+- pinctrl4: pin controller of FF block,
+- pinctrl5: pin controller of ESE block,
+- pinctrl6: pin controller of FSYS0 block,
+- pinctrl7: pin controller of FSYS1 block,
+
 Example: A pin-controller node with pin banks:
 
 	pinctrl_0: pinctrl@11400000 {
-- 
1.7.10.4

