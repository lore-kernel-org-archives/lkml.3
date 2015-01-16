Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbbAPLUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 06:20:20 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:35605 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbbAPLUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 06:20:10 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-95-54b8f3e96451
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: rtc-linux@googlegroups.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH] MAINTAINERS: Add entry for Maxim PMIC-s on Samsung boards
Date: Fri, 16 Jan 2015 12:19:50 +0100
Message-id: <1421407190-6771-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPLMWRmVeSWpSXmKPExsVy+t/xa7ovP+8IMeg7KmGx5OJVdoupD5+w
	WVz/8pzVYtKT98wWE1dOZrZ4/cLQ4v7Xo4wW3650MFlc3jWHzeJz7xFGi6cTLrJZ3G5cwWax
	v7OD0eJ0N6vFjzPdLBand5c4CHhc7utl8tg56y67x56JJ9k8Nq/Q8ti0qpPN4861PWwe804G
	evRtWcXoMX3eTyaPz5vkAriiuGxSUnMyy1KL9O0SuDK2vz3HXrBEoOLD+R0sDYzdfF2MnBwS
	AiYSE9dsYYWwxSQu3FvP1sXIxSEksJRRYvsxGKePSaJ7Sxc7SBWbgLHE5uVL2EBsEYEIiaYt
	a8C6mQV6WSTW7XUDsYUFvCRWnL0GVsMioCox5dAHRhCbV8BN4u6t/WwQ2+QkTh6bzDqBkXsB
	I8MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJBA/bqDcekxq0OMAhyMSjy8Dpt2hAixJpYV
	V+YeYpTgYFYS4d24DSjEm5JYWZValB9fVJqTWnyIkYmDU6qBUdvmttCjwF+LpEQjsg6krnG6
	usreIubJ7v2Vy2u5ZzCtSp69rGutUQx/1t1pmWJhz5jZUgpyr1lIG6sz6qWoGM7r+8v8+2vX
	meJHlzz03N83iZ6Le9jPGRk0i+1EuUvLJe/rYYLi6/llFj8qv8mW9ujxpTy9uadlf1qZmkk5
	N3gv6Tuzb95MJZbijERDLeai4kQAH+IAAjICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add myself as supporter for Maxim 77686 PMIC and Maxim 14577/77693 MUIC
drivers:
 - mfd (all of them),
 - extcon (extcon-max14577, extcon-max77693)
 - power (max14577_charger.c, 77693 on LKML [1]),
 - regulator (all of them),
 - clock (clk-max77686.c)
 - RTC (rtc-max77686.c).

Lately I am the author of major contributors to them. These
drivers are used on Exynos-based boards (Trats 2, Gear 1 and Gear 2).

[1] https://lkml.org/lkml/2015/1/5/139

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
---
 MAINTAINERS | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f017a30eb280..b033fb499186 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6143,6 +6143,21 @@ F:	Documentation/devicetree/bindings/i2c/max6697.txt
 F:	drivers/hwmon/max6697.c
 F:	include/linux/platform_data/max6697.h
 
+MAXIM PMIC AND MUIC DRIVERS FOR EXYNOS BASED BOARDS
+M:	Krzysztof Kozlowski <k.kozlowski@samsung.com>
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+F:	drivers/*/*max14577*.c
+F:	drivers/*/*max77686*.c
+F:	drivers/*/*max77693*.c
+F:	Documentation/devicetree/bindings/mfd/max14577.txt
+F:	Documentation/devicetree/bindings/mfd/max77686.txt
+F:	Documentation/devicetree/bindings/mfd/max77693.txt
+F:	Documentation/devicetree/bindings/clock/maxim,max77686.txt
+F:	include/linux/mfd/max14577*.h
+F:	include/linux/mfd/max77686*.h
+F:	include/linux/mfd/max77693*.h
+
 MAXIRADIO FM RADIO RECEIVER DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
-- 
1.9.1

