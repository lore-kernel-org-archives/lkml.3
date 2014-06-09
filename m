Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525AbaFIK3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 06:29:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56201 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741AbaFIK3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 06:29:46 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-1b-53958c984d9c
From: Chanwoo Choi <cw00.choi@samsung.com>
To: broonie@kernel.org, lgirdwood@gmail.com, grant.likely@linaro.org,
        robh+dt@kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 0/2] regulator: of: Add support for pasing regulator suspend
 state
Date: Mon, 09 Jun 2014 19:29:38 +0900
Message-id: <1402309780-8118-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsWyRsSkQHdGz9Rgg6cNKhZTHz5hs7j+5Tmr
	xfwj51gtDvzZwWhxtukNu8W3Kx1MFpd3zWGzuN24gs2ide8RdgdOj52z7rJ7bFrVyeZx59oe
	No++LasYPT5vkgtgjeKySUnNySxLLdK3S+DK2DtpIVvBH86KFWsmMTYw/mLvYuTkkBAwkVg5
	7RkLhC0mceHeerYuRi4OIYGljBKz119jgSl6P6ONGcQWEpjOKHHwYRJEUROTxM+D38GK2AS0
	JPa/uAHUzcEhIhAlsbaDCaSGWWA2o0TL+T6wZmGBEIkni66D2SwCqhJL1twDs3kFXCTOdT2H
	ukhO4sOeR+wgzRIC/ewSk/paoRoEJL5NPsQCskBCQFZi0wFmiHpJiYMrbrBMYBRcwMiwilE0
	tSC5oDgpvchIrzgxt7g0L10vOT93EyMwlE//e9a3g/HmAetDjMlA4yYyS4km5wNjIa8k3tDY
	zMjC1MTU2Mjc0ow0YSVx3kUPk4KEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MIqtyZi+K6/C
	1E/zysfXbML8bgxzlr5O+bV/ZYnQhlVKabs0G70XPP1u0bm+9YPe3Eq322oewbtcNaUuhpzd
	8iVZ6Xxxr1WJ+YclhxeY/bmSsPxlbIP+G9NW5Wl3Nt3SfbvI+tBcZcblPrZWD0OKP158XP13
	tfKvvfnHlUvCn0htvHeNt6nhfIASS3FGoqEWc1FxIgDg3o3PewIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t9jQd0ZPVODDZbNkbGY+vAJm8X1L89Z
	LeYfOcdqceDPDkaLs01v2C2+Xelgsri8aw6bxe3GFWwWrXuPsDtweuycdZfdY9OqTjaPO9f2
	sHn0bVnF6PF5k1wAa1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6q
	rZKLT4CuW2YO0EVKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxoy9kxay
	FfzhrFixZhJjA+Mv9i5GTg4JAROJ9zPamCFsMYkL99azgdhCAtMZJQ4+TOpi5AKym5gkfh78
	zgKSYBPQktj/4gZQEQeHiECUxNoOJpAaZoHZjBIt5/vABgkLhEg8WXQdzGYRUJVYsuYemM0r
	4CJxrus51GI5iQ97HrFPYORewMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Up5J72Bc
	1WBxiFGAg1GJhzfi95RgIdbEsuLK3EOMEhzMSiK8PjlTg4V4UxIrq1KL8uOLSnNSiw8xJgNt
	n8gsJZqcD4zivJJ4Q2MTMyNLI3NDCyNjc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpg
	NJpV8+Bn4fxdvVd/ln3c8fq7zOeak07/F6TpKETNstjAJBN7VPf0maWXNZjdL790/W97ulKs
	b6f61v7TiXOmb026ZP1ISVpkscfxUI4qgYyXIcKLm5YL3vR0b7ml0TM1pkL9oMNBpXmz7Z6V
	f2aY/qn9vnKVK39/3E7mqm2Tyy9wmok6rlT9psRSnJFoqMVcVJwIAO4DFojYAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulators would set different state/mode according to the kind of suspend
state. So regulation_constraints structure has already regulator suspend state filed.
This patch parse regulator suspend state from devicetree file.

For example:

	ldoX_reg: LDOx {
		regulator-name = "VAP_XXX_1.2V";
		regulator-min-microvolt = <1200000>;
		regulator-max-microvolt = <1200000>;
		regulator-always-on;

		regulator-initial-state = <3>;	/* PM_SUSPEND_MEM */
		regulator-state-standby {
			regulator-volt = <1200000>;
			regulator-mode = <0x2>;	/* REGULATOR_MODE_NORMAL */
		};

		regulator-state-mem {
			regulator-volt = <1200000>;
			regulator-mode = <0x8>;	/* REGULATOR_MODE_STANDBY */
			regulator-off-in-suspend;
		};

		regulator-state-disk {
			regulator-volt = <1200000>;
			regulator-mode = <0x2>;	/* REGULATOR_MODE_NORMAL */
			regulator-on-in-suspend;
		};
	};

Chanwoo Choi (2):
  regulator: of: Add support for parsing regulator_state for suspend state
  dt-bindings: regulator: Add regulator suspend state for PM state

 .../devicetree/bindings/regulator/regulator.txt    | 12 +++++
 drivers/regulator/of_regulator.c                   | 61 +++++++++++++++++++++-
 2 files changed, 71 insertions(+), 2 deletions(-)

-- 
1.8.0

