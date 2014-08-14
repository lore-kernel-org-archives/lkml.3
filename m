Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbaHNAkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 20:40:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:55000 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaHNAkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 20:40:17 -0400
X-AuditID: cbfee690-b7f526d000003627-5d-53ec056f9fb3
From: Chanwoo Choi <cw00.choi@samsung.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        kyungmin.park@samsung.com, k.kozlowski@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 0/2] regulator: of: Add support for pasing regulator suspend
 state
Date: Thu, 14 Aug 2014 09:40:12 +0900
Message-id: <1407976814-21882-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsWyRsSkRDef9U2wwYJ5JhZTHz5hs7j+5Tmr
	xfwj51gtDvzZwWjx+oWhxdmmN+wW3650MFlc3jWHzaJ17xF2B06PnbPusntsWtXJ5nHn2h42
	j74tqxg9Pm+SC2CN4rJJSc3JLEst0rdL4MqYO72buWAmT8X/efNZGxjfcnYxcnJICJhInPq3
	gRHCFpO4cG89WxcjF4eQwFJGifl/77F2MXKAFd0+agERX8QocXpBOyOE08QkMfXGJrBuNgEt
	if0vbrCB2CJAk27P6WQGKWIWuMco8WX1QxaQhLBAmET3j6VgNouAqsTrsxvYQWxeAVeJWdv/
	sEOcISfxYc8jKHsyu8Tr+cwQ9QIS3yYfYoG4SFZi0wFmiBJJiYMrbrBMYBRcwMiwilE0tSC5
	oDgpvchErzgxt7g0L10vOT93EyMwkE//ezZhB+O9A9aHGJOBxk1klhJNzgdGQl5JvKGxmZGF
	qYmpsZG5pRlpwkrivGqPkoKEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MAYr7087aWv5rWK6
	rmntBJ6tuYuzJfPYbvFKz86ZG/pHeoPbggLuy5Em5e+3xtzestjwgdWfSdkJujMExd51Xbmu
	v3NJegFLk9aSKfNbmJJYupO5Vku3B67/cGjio6LEVVxPfqT5vyvVsvUpj/YVqjvGp3F4mjPf
	6cLo140He9av+Mzbx80WpcRSnJFoqMVcVJwIABxJ1C56AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsVy+t9jAd181jfBBlcP6FhMffiEzeL6l+es
	FvOPnGO1OPBnB6PF6xeGFmeb3rBbfLvSwWRxedccNovWvUfYHTg9ds66y+6xaVUnm8eda3vY
	PPq2rGL0+LxJLoA1qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxtzp3cwF
	M3kq/s+bz9rA+Jazi5GDQ0LAROL2UYsuRk4gU0ziwr31bF2MXBxCAosYJU4vaGeEcJqYJKbe
	2MQIUsUmoCWx/8UNNhBbBKjj9pxOZpAiZoF7jBJfVj9kAUkIC4RJdP9YCmazCKhKvD67gR3E
	5hVwlZi1/Q87xDo5iQ97HrFPYORewMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4Up5J
	7WBc2WBxiFGAg1GJh9cj6nWwEGtiWXFl7iFGCQ5mJRFeZeY3wUK8KYmVValF+fFFpTmpxYcY
	TYG2T2SWEk3OB0ZxXkm8obGJmZGlkbmhhZGxuZI474FW60AhgfTEktTs1NSC1CKYPiYOTqkG
	xqo/HEKLghoelUzd4X9pqsdSKc1ry56bq17Y4Kfw6neBh/H+w4016ReulH0yOmy5RuXzxNwT
	349NfrbuYuYP6bx3HFbXlb1fGV2+Wxe34Jj9+977pttfyAU5z49O6nS7+uwOe/mqB/1Hbxn6
	bG8+wvWyVvLChnmXw5uj5qt4rm75v2PVo0WM/SZKLMUZiYZazEXFiQAMWzJ5qgIAAA==
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
		};

		regulator-state-mem {
			regulator-volt = <1200000>;
			regulator-off-in-suspend;
		};

		regulator-state-disk {
			regulator-volt = <1200000>;
			regulator-on-in-suspend;
		};
	};

Changes from v2:
- Fix over 80 lines by using checkpatch script
- Rebase this patchset on latest for-next branch of regulator.git

Changes from v1:
- Check whether regulator-initial-state and regulator-mode is correct or not
- Add more detailed description about regulator-initial-state, regulator-mode
  and regulator-state-[standby/mem/disk] for devicetree bindings
- Modify example of regulator suspend state in bindings documentation

Chanwoo Choi (2):
  regulator: of: Add support for parsing regulator_state for suspend state
  dt-bindings: regulator: Add regulator suspend state for PM state

 .../devicetree/bindings/regulator/regulator.txt    | 32 +++++++++
 drivers/regulator/of_regulator.c                   | 79 +++++++++++++++++++++-
 2 files changed, 109 insertions(+), 2 deletions(-)

-- 
1.8.0

