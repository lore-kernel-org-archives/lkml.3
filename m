Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbbAOBvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 20:51:17 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:29070 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbbAOBvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 20:51:11 -0500
X-AuditID: cbfee68e-f79b46d000002b74-02-54b71d093472
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v4 8/9] ARM: dts: Add the support for exynos busfreq on
 Exynos4412-based TRATS2 board
Date: Thu, 15 Jan 2015 10:50:56 +0900
Message-id: <1421286657-4720-9-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1421286657-4720-1-git-send-email-cw00.choi@samsung.com>
References: <1421286657-4720-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42JZI2JSoMspuz3EYMUCfovHaxYzWWycsZ7V
	4vqX56wWk+5PYLF4/cLQov/xa2aLs01v2C02Pb7GanF51xw2i8+9RxgtZpzfx2Sx9PpFJovb
	jSvYLB6veMtu0br3CLvFql1/GB0EPNbMW8PosXPWXXaPxXteMnlsWtXJ5rF5Sb1H35ZVjB6f
	N8kFsEdx2aSk5mSWpRbp2yVwZcze852xYAZnRc/uC2wNjA/Zuxg5OCQETCSOHK/pYuQEMsUk
	Ltxbz9bFyMUhJLCUUeL08m+MEAkTicXdZxghEtMZJb69bGUGSQgJNDFJPG3KBrHZBLQk9r+4
	wQZiiwjoSXQe28MOYjML/GGSaNrEAmILC6RLNDzYA2azCKhKvFrYzwRi8wq4SNzbdY8ZYpmC
	xLLlM1lBbE4BV4meX/vZIXa5SKy6OxnsCAmBl+wSK9bPYYQYJCDxbfIhFohvZCU2HYCaIylx
	cMUNlgmMwgsYGVYxiqYWJBcUJ6UXGekVJ+YWl+al6yXn525iBMbT6X/P+nYw3jxgfYhRgINR
	iYfX4cjWECHWxLLiytxDjKZAGyYyS4km5wOjNq8k3tDYzMjC1MTU2Mjc0kxJnDdB6mewkEB6
	YklqdmpqQWpRfFFpTmrxIUYmDk6pBsaW6pNr3x16v3vR3spAmblee8qWdHNIhk/Mn/0zKUHy
	Ur5xq272C95Z23Is4zwf2eZlr8p8pBzAtvKUnN7juT98/rcoySh/KT7LaMk1adWpnYkOJgV9
	Av89z8V59XFoHNbbcjRdkmf5IV519fUet6x5VnVtvFGmN1FdPuDlvVAf8bjoV+1qM5VYijMS
	DbWYi4oTAXtklfmiAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jQV1O2e0hBq8XcFg8XrOYyWLjjPWs
	Fte/PGe1mHR/AovF6xeGFv2PXzNbnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLpdcvMlnc
	blzBZvF4xVt2i9a9R9gtVu36w+gg4LFm3hpGj52z7rJ7LN7zkslj06pONo/NS+o9+rasYvT4
	vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0z
	B+h4JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPG7D3fGQtmcFb07L7A
	1sD4kL2LkZNDQsBEYnH3GUYIW0ziwr31bF2MXBxCAtMZJb69bGUGSQgJNDFJPG3KBrHZBLQk
	9r+4wQZiiwjoSXQe2wM2iFngD5NE0yYWEFtYIF2i4cEeMJtFQFXi1cJ+JhCbV8BF4t6ue8wQ
	yxQkli2fyQpicwq4SvT82s8OsctFYtXdyYwTGHkXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dL
	zs/dxAiO12fSOxhXNVgcYhTgYFTi4XU4sjVEiDWxrLgy9xCjBAezkgjv20/bQoR4UxIrq1KL
	8uOLSnNSiw8xmgJdNZFZSjQ5H5hK8kriDY1NzIwsjcwNLYyMzZXEeZXs20KEBNITS1KzU1ML
	Uotg+pg4OKUaGFeaRWkIulf/3/qo+ZuNQMzF5i+rJMPXne3JXHN4QZ/G/5NLlyR3RMvvLt9y
	t6jeX+hlocqxN7rXIjgW8z22+C1r4cYsEhbWvLAr+tbRLY0Gxll/CpdZyWkl32Wq4A589rbu
	rivPuuaX7NOmGWRbHmM0XNy+4HCvVz0X0/dN7W7RQv86tkXMVmIpzkg01GIuKk4EAE+Rh6jt	AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Exynos4412 memory-bus node which includes the regulator
and devfreq-event phandle. The devfreq-event phandle is used for the
governor of devfreq device and provide the current usage state of
MIF (Memory Interface) / INT (Internal) memory bus group.

Cc: Kukjin Kim <kgene@kernel.org>
Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index bee0eed..21ba25e 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -917,6 +917,18 @@
 	};
 };
 
+&memory_bus_mif {
+	devfreq-events = <&ppmu_dmc0_3>, <&ppmu_dmc1_3>;
+	vdd-mem-supply = <&buck1_reg>;
+	status = "okay";
+};
+
+&memory_bus_int {
+	devfreq-events = <&ppmu_leftbus_3>, <&ppmu_rightbus_3>;
+	vdd-mem-supply = <&buck3_reg>;
+	status = "okay";
+};
+
 &pinctrl_0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&sleep0>;
-- 
1.8.5.5

