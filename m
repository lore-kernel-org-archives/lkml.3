Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbaAPPSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 10:18:10 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:30755 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaAPPSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 10:18:07 -0500
X-AuditID: cbfee690-b7f266d00000287c-9b-52d7f82d7e34
Date: Thu, 16 Jan 2014 15:18:05 +0000 (GMT)
From: Saurabh Singh <saurabh1.s@samsung.com>
Subject: Re: Re: [PATCH] Parse missing regulator constraints from device tree
 blob
To: Mark Brown <broonie@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "celinux-dev@tree.celinuxforum.org" 
	<celinux-dev@tree.celinuxforum.org>,
        SREEVATSA D B <srevatsa@samsung.com>,
        Praveen BP <bp.praveen@samsung.com>
Reply-to: saurabh1.s@samsung.com
MIME-version: 1.0
X-MTR: 20140116151526605@saurabh1.s
Msgkey: 20140116151526605@saurabh1.s
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140116151526605@saurabh1.s
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <8217085.584601389885483146.JavaMail.weblogic@epml20>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42JZI2JSrav743qQwaxnVhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj+M1/rAXrLCu6fhc2ML4x72Lk5BASUJWYvWcLI4gtIWAiseZj
	FzOELSZx4d56NoiapYwSTyazwtR8mf4XqIYLKD6fUWLq1IdgRSxAg3ZsWQlWxCagK/Fw/V32
	LkYODmGBIIn75wtBwiJAJZuW72EHsZkFHjFL/HsZDzFfQeLc804mEJtXQFDi5MwnLBC7lCUu
	t28EG8MroCLR+b8IIiwnsWTqZSYIm1diRvtTFpj4tK9roM6Xljg/awMjzCuLvz+GivNLHLu9
	gwlkJEjvk/vBMGN2b/7CBmELSEw9cxCqVUPi5ZerUK18EmsWvmWBGbPr1HJmmN77W+YyQXyl
	KDGl+yHUhwYSRxbNYUX3Fa+Ao8SxK48ZJzAqz0KSmoWkfRaSdmQ1CxhZVjGKphYkFxQnpReZ
	6BUn5haX5qXrJefnbmIEJoTT/55N2MF474D1IcZkYIRMZJYSTc4HJpS8knhDYzMjC1MTU2Mj
	c0sz0oSVxHnVHiUFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamCMuSz4f6/Qh1dic+J/WMrq
	HJKo+NN1LufRtQava9PmvZHPqv0d4hVfybDjcU72pa0r7zC+qr6foDw19mvfvaw3Szf3v1BZ
	lZQScfGl9qsX9be+uF2dJ5Y0fdWNePWPF/90aTZmshmyaS0P3P7we3b59N0yWw9UrzpXFO+c
	LCLgteL617tT9x7xUmIpzkg01GIuKk4EALsmF7ceAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLKsWRmVeSWpSXmKPExsVy+t/t6bq6P64HGSxt1be4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hqaxVoYGBkamQDUJaRnH
	b/5jLVhnWdH1u7CB8Y15FyMnh5CAqsTsPVsYQWwJAROJL9P/MkPYYhIX7q1n62LkAqqZzygx
	depDNpAEC1DDji0rWUFsNgFdiYfr77J3MXJwCAsESdw/XwgSFgEq2bR8DzuIzSzwiFni38t4
	iF0KEueedzKB2LwCghInZz5hgdilLHG5fSPYGF4BFYnO/0UQYTmJJVMvM0HYvBIz2p+ywMSn
	fV0Ddaa0xPlZGxhhTl78/TFUnF/i2O0dTCAjQXqf3A+GGbN78xc2CFtAYuqZg1CtGhIvv1yF
	auWTWLPwLQvMmF2nljPD9N7fMpcJ4itFiSndD6E+NJA4smgOK7qveAUcJY5decw4gVFuFpLU
	LCTts5C0I6tZwMiyilE0tSC5oDgpvcJIrzgxt7g0L10vOT93EyM4MT1btIPx33nrQ4wCHIxK
	PLwn3l8LEmJNLCuuzD3EKMHBrCTC+/rl9SAh3pTEyqrUovz4otKc1OJDjMnA6JvILCWanA9M
	mnkl8YbGJuamxqYWBobm5makCSuJ88rfSgoSEkhPLEnNTk0tSC2C2cLEwSnVwFj9/ck1hrv6
	F58q6B/fqvGnrV052tJxhrXkjFXmigcKEhmWvX+9Xin04bWsObp3Piw4PpGrWkm2f5dO0fWp
	zmZndz6atFNeJtH8uezFpScs7LLkik4/YFhcd0f+xxkVIcEfQa5fZ3uF/lm+24Oj+deKOfmu
	6hu3WEz41vC2rPnHB7E+tjlKklOUWIozEg21mIuKEwEemaCDkAMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0GFIF2G018504

Hi Mark,

> Please send patches using the process in SubmittingPatches, the formatting
> of the submission is very important for tools like git am which people use to
> work with patches.

As per your request sending the patch and description in git format.
Please find below the patch.

Regards,
Saurabh Singh Sengar
Lead Engineer
Samsung R&D Institute
India

=================================================================================
>From Saurabh Singh <saurabh1.s@samsung.com> Mon Sep 17 00:00:00 2001
Date: Thu, 16 Jan 2014 20:36:15 +0530
Subject: [PATCH] From: Saurabh Singh Sengar <saurabh1.s@samsung.com>

This patch adds support for parsing following regulator contraints from
device tree blob.
1. valid modes mask (valid_modes_mask)
2. input microvolt(input_uV)
3. initial mode (initial_mode)
4. initial state (initial_state)
5. state mem (state_mem)
6. state disk (state_disk)
7. state standby (state_standby)

Signed-off-by: Saurabh Singh Sengar <saurabh1.s@samsung.com>
---
 .../devicetree/bindings/regulator/regulator.txt    |   19 +++++++++
 drivers/regulator/of_regulator.c                   |   41 ++++++++++++++++++++
 2 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
index 2bd8f09..7793445 100644
--- a/Documentation/devicetree/bindings/regulator/regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -14,6 +14,17 @@ Optional properties:
 - regulator-ramp-delay: ramp delay for regulator(in uV/uS)
   For hardwares which support disabling ramp rate, it should be explicitly
   intialised to zero (regulator-ramp-delay = <0>) for disabling ramp delay.
+- regulator-valid-modes-mask: valid operations for regulator on particular machine
+- regulator-input-uv: regulator input voltage, only if supply is another regulator
+- regulator-initial-mode: default mode to set on startup
+- regulator-initial-state: suspend state to set at init
+- regulator-state-mem, regulator-state-disk, regulator-state-standby:
+	defines regulator suspend to memory, suspend to disk (hibernate) and standby respectively.
+	have following sub-constarints:
+	- regulator-state-uv: suspend voltage
+	- regulator-state-mode: suspend regulator operating mode
+	- regulator-state-enabled: is regulator enabled in this suspend state
+	- regulator-state-disabled: is the regulator disbled in this suspend state
 
 Deprecated properties:
 - regulator-compatible: If a regulator chip contains multiple
@@ -29,6 +40,14 @@ Example:
 		regulator-max-microvolt = <2500000>;
 		regulator-always-on;
 		vin-supply = <&vin>;
+		regulator-valid-modes-mask = <REGULATOR_MODE_FAST>;
+		regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
+		regulator-initial-state = <PM_SUSPEND_MEM>;
+		regulator-state-mem {
+			regulator-state-mode = <REGULATOR_MODE_IDLE>;
+			regulator-state-enabled;
+		};
+
 	};
 
 Regulator Consumers:
diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 7827384..328d76f 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -16,11 +16,27 @@
 #include <linux/regulator/machine.h>
 #include <linux/regulator/of_regulator.h>
 
+/**
+ * set_regulator_state_constraints - set regulator state for low power system states
+ * @np: device node for the low power regulator state
+ * @regulator_state: regulator_state structure need to be filled
+ */
+static void set_regulator_state_constraints(struct device_node *np,
+		struct regulator_state *state)
+{
+	of_property_read_u32(np, "regulator-state-uv", &state->uV);
+	of_property_read_u32(np, "regulator-state-mode", &state->mode);
+	state->enabled = of_property_read_bool(np, "regulator-state-enabled");
+	state->disabled = of_property_read_bool(np, "regulator-state-disabled");
+}
+
+
 static void of_get_regulation_constraints(struct device_node *np,
 					struct regulator_init_data **init_data)
 {
 	const __be32 *min_uV, *max_uV, *uV_offset;
 	const __be32 *min_uA, *max_uA, *ramp_delay;
+	struct device_node *state;
 	struct property *prop;
 	struct regulation_constraints *constraints = &(*init_data)->constraints;
 
@@ -73,6 +89,31 @@ static void of_get_regulation_constraints(struct device_node *np,
 		else
 			constraints->ramp_disable = true;
 	}
+
+	of_property_read_u32(np, "regulator-valid-modes-mask",
+					&constraints->valid_modes_mask);
+	of_property_read_u32(np, "regulator-input-uv",
+					&constraints->input_uV);
+	of_property_read_u32(np, "regulator-initial-mode",
+					&constraints->initial_mode);
+	of_property_read_u32(np, "regulator-initial-state",
+					&constraints->initial_state);
+
+	/* regulator state during low power system states */
+	state = of_find_node_by_name(np, "regulator-state-mem");
+	if (state)
+		set_regulator_state_constraints(state,
+				&constraints->state_mem);
+
+	state = of_find_node_by_name(np, "regulator-state-disk");
+	if (state)
+		set_regulator_state_constraints(state,
+				&constraints->state_disk);
+
+	state = of_find_node_by_name(np, "regulator-state-standby");
+	if (state)
+		set_regulator_state_constraints(state,
+				&constraints->state_standby);
 }
 
 /**
-- 
1.7.0.4ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
