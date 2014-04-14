Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbaDNIJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:09:39 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:49818 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbaDNIJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:09:35 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-b9-534b97b61b26
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 4/4] regulator: s5m8767: Use same binding for external control
 as in s2mps11
Date: Mon, 14 Apr 2014 10:09:09 +0200
Message-id: <1397462949-22379-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <1397462949-22379-1-git-send-email-k.kozlowski@samsung.com>
References: <1397462949-22379-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t/xK7rbpnsHG7x8pWOxccZ6VoupD5+w
	Wcw/co7Vov/NQlaLc69WMlq8fmFocbbpDbvF/a9HGS2+Xelgsri8aw6bxYzz+5gs1h65y26x
	9PpFJosJ09eyWLTuPcJucbqb1eLiii9MFutnvGZxEPJYM28No8flvl4mj52z7rJ7rFz+hc1j
	06pONo871/awecw7GejRt2UVo8fnTXIBnFFcNimpOZllqUX6dglcGZOXzmEs+CJQsbp/MVsD
	Yy9fFyMnh4SAicTB75PZIWwxiQv31rN1MXJxCAksZZS4uHABI4TTxyTxeuU+NpAqNgFjic3L
	l4BViQjcYJaYuGwXE0iCWeA5o8TT7+EgtrBAnMSrWSfAGlgEVCU6J90Aq+EVcJd4s3kLC8Q6
	BYllX9YydzFycHAKeEi8uQlWLgRU8vX3LKYJjLwLGBlWMYqmliYXFCel5xrpFSfmFpfmpesl
	5+duYoSE+dcdjEuPWR1iFOBgVOLh5djqGSzEmlhWXJl7iFGCg1lJhHdbhlewEG9KYmVValF+
	fFFpTmrxIUYmDk6pBsazzg68z+VbnF/H3Y4NXSx5x3tnWWfn3A9GXfUak5QcDO/Pe7ygaD/D
	1PVlDadsfGY3z1g9cfXuOWEsJVPiLxgqqZ+4fatmx6O3L1nsuOZz79mtO+M5o3GZqfbX6hfP
	nWWevzhYyvjmW+acqDs8i5NsQgO613097r1vY5VO2Bk/m4msub73Xp9WYinOSDTUYi4qTgQA
	YnYEflECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the binding for regulators external control to the same used in
s2mps11 driver to be consistent.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: devicetree@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
---
 Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt | 4 ++--
 drivers/regulator/s5m8767.c                                       | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt b/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt
index d290988ed975..558c80345ef0 100644
--- a/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt
@@ -76,7 +76,7 @@ except these properties:
 		1 - on in normal mode
 		2 - low power mode
 		3 - suspend mode
-	- s5m8767,pmic-ext-control-gpios: (optional) GPIO specifier for one
+	- samsung,ext-control-gpios: (optional) GPIO specifier for one
 		GPIO controlling this regulator (enable/disable); This is
 		valid only for buck9.
 
@@ -157,7 +157,7 @@ Example:
 				regulator-min-microvolt = <2800000>;
 				regulator-max-microvolt = <2800000>;
 				op_mode = <3>; /* Standby Mode */
-				s5m8767,pmic-ext-control-gpios = <&gpk0 2 0>;
+				samsung,ext-control-gpios = <&gpk0 2 0>;
 			};
 		};
 	};
diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 92f19a005dc3..dbfd98b04a77 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -534,7 +534,7 @@ static void s5m8767_pmic_dt_parse_ext_control_gpio(struct sec_pmic_dev *iodev,
 		struct device_node *reg_np)
 {
 	rdata->ext_control_gpio = of_get_named_gpio(reg_np,
-			"s5m8767,pmic-ext-control-gpios", 0);
+			"samsung,ext-control-gpios", 0);
 	if (!gpio_is_valid(rdata->ext_control_gpio))
 		rdata->ext_control_gpio = 0;
 }
-- 
1.8.3.2

