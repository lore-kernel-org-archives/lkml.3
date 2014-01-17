Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbaAQPLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:11:23 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:27162 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbaAQPLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:11:21 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-33-52d9481771a4
Date: Fri, 17 Jan 2014 15:11:19 +0000 (GMT)
From: Saurabh Singh <saurabh1.s@samsung.com>
Subject: Re: [PATCH] Parse missing regulator constraints from device tree blob
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
X-MTR: 20140117150416157@saurabh1.s
Msgkey: 20140117150416157@saurabh1.s
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140117150416157@saurabh1.s
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <758915.615271389971476784.JavaMail.weblogic@epml20>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42JZI2JSqyvucTPIYO58RYvLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJWx/eYW5oIHPhVLb8s2MD7w6mLk5BASUJWYvWcLI4gtIWAicfnV
	SjYIW0ziwr31QDYXUM1SRomO1l4WmKKVC26yQCTmM0osOL2SHSTBAjSp++tWJhCbTUBX4uH6
	u2BxYQE/iT0tH8HiIkA1m5bvAYszCzxilvj3Mh7iCgWJc887wWp4BQQlTs58ArVMWWLCu3/M
	XYwcQHEViZVTzSHCchJLpl5mgrB5JWa0P2WBiU/7uoYZwpaWOD9rAyPMM4u/P4aK80scu72D
	CWQkSO+T+8EwY3Zv/gL1u4DE1DMHoVo1JM58/gFl80msWfiWBWbMrlPLmWF672+ZywTxlaLE
	lO6HUB8aSBxZNIcV3Ve8Ag4SO7Y3s0xgVJ6FJDULSfssJO3IahYwsqxiFE0tSC4oTkovMtUr
	TswtLs1L10vOz93ECEwKp/89m7iD8f4B60OMycAYmcgsJZqcD0wqeSXxhsZmRhamJqbGRuaW
	ZqQJK4nzpj9KChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAmPhzdY7znCkf2590V4p+LVdL
	/b9YyXlL/cb8LwIZexdICaWa/g0rFl7L+zznxdWH37xjJ0doOd+2/Zc4T47jYa6S6Afx39c0
	VbLv75oYedT+Zr3Nhhk1AScaT5iedn9a2SJfvPaS4W9RPuW0fZuXhc56Z5PU33yIZ9Od73OK
	+vUn+Ft0y6aIK7EUZyQaajEXFScCANmw7FQgAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsVy+t/tGbriHjeDDP6vkrC4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hqaxVoYGBkamQDUJaRnb
	b25hLnjgU7H0tmwD4wOvLkZODiEBVYnZe7YwgtgSAiYSKxfcZIGwxSQu3FvP1sXIBVQzn1Fi
	wemV7CAJFqCG7q9bmUBsNgFdiYfr74LFhQX8JPa0fASLiwDVbFq+ByzOLPCIWeLfy3iIZQoS
	5553gtXwCghKnJz5BGqZssSEd/+Yuxg5gOIqEiunmkOE5SSWTL3MBGHzSsxof8oCE5/2dQ0z
	hC0tcX7WBkaYmxd/fwwV55c4dnsHE8hIkN4n94Nhxuze/IUNwhaQmHrmIFSrhsSZzz+gbD6J
	NQvfssCM2XVqOTNM7/0tc5kgvlKUmNL9EOpDA4kji+awovuKV8BBYsf2ZpYJjHKzkKRmIWmf
	haQdWc0CRpZVjKKpBckFxUnpFSZ6xYm5xaV56XrJ+bmbGMGp6dmSHYwNF6wPMQpwMCrx8EqI
	3wgSYk0sK67MPcQowcGsJMI7x+BmkBBvSmJlVWpRfnxRaU5q8SHGZGD8TWSWEk3OB6bNvJJ4
	Q2MTc1NjUwsDQ3NzM9KElcR5F9xKChISSE8sSc1OTS1ILYLZwsTBKdXAqBgha/VNr/L6NkH2
	G4ar1hZfX6t3qVNR6Y1mgK9HYvjT11+TZl1mC/Jh7FvPbML9d3uQZd4fnYrcJTwPzvXKdvCr
	7/IXv2L9kP/R8r+Gco1fIpR0RRUff1jSlzL57lK3mMSXtlMnxv90n5ebuX7Tum1CvYeZjyRa
	3LSu/JZ0eef9PJOPPWE3lFiKMxINtZiLihMBc4Bm4pEDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0HFBRJj025432

This patch adds support for parsing following regulator contraints from
device tree blob.
1. valid modes mask (valid_modes_mask)
2. initial mode (initial_mode)
3. initial state (initial_state)
4. state mem (state_mem)
5. state disk (state_disk)
6. state standby (state_standby)

Signed-off-by: Saurabh Singh Sengar <saurabh1.s@samsung.com>
---
 .../devicetree/bindings/regulator/regulator.txt    |   45 ++++++++++++
 drivers/regulator/of_regulator.c                   |   77 ++++++++++++++++++++
 2 files changed, 122 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
index 2bd8f09..6dc935b 100644
--- a/Documentation/devicetree/bindings/regulator/regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -14,6 +14,36 @@ Optional properties:
 - regulator-ramp-delay: ramp delay for regulator(in uV/uS)
   For hardwares which support disabling ramp rate, it should be explicitly
   intialised to zero (regulator-ramp-delay = <0>) for disabling ramp delay.
+- regulator-valid-modes-mask: valid operations for regulator on particular machine
+  Supports following modes of operations:
+  Mode			Description
+  ----			-----------
+  fast			Regulator can handle fast changes in it's load
+  normal		Normal regulator power supply mode
+  idle			Regulator runs in a more efficient mode for light loads.
+  standby		Regulator runs in the most efficient mode for very light loads
+  See the example given below.
+
+- regulator-initial-mode: default mode to set on startup
+  Refer to regulator-initial-mode for modes supported
+
+- regulator-initial-state: suspend state to set at init
+  Any one of the following states can be set:
+  Mode			Description
+  ----			-----------
+  suspend-mem		suspend to memory
+  suspend-standby	standby mode
+  suspend-disk		suspend to disk
+  See the example given below.
+
+- regulator-state-mem, regulator-state-disk, regulator-state-standby:
+	defines regulator suspend to memory, suspend to disk (hibernate) and standby respectively.
+	have following sub-constarints:
+	- regulator-state-uv: voltage to set in suspend state
+	- regulator-state-mode: suspend regulator operating mode,
+	  refer to regulator-valid-modes-mask for modes supported
+	- regulator-state-enabled: is regulator enabled in this suspend state
+	- regulator-state-disabled: is the regulator disbled in this suspend state
 
 Deprecated properties:
 - regulator-compatible: If a regulator chip contains multiple
@@ -29,6 +59,21 @@ Example:
 		regulator-max-microvolt = <2500000>;
 		regulator-always-on;
 		vin-supply = <&vin>;
+		regulator-initial-mode = "normal";
+		regulator-initial-state = "suspend-mem";
+		regulator-valid-modes-mask {
+		/*can support multiple mode
+		 * in this example supporting fast and normal mode */
+			fast-mode;
+			normal-mode;
+		};
+		regulator-state-mem {
+			regulator-state-mode = "idle";
+			regulator-state-enabled;
+		};
+		regulator-state-disk {
+			regulator-state-disabled;
+		};
 	};
 
 Regulator Consumers:
diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 7827384..3030597 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -16,11 +16,36 @@
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
+	if (!of_property_match_string(np, "regulator-state-mode", "fast"))
+		state->mode = REGULATOR_MODE_FAST;
+	else if (!of_property_match_string(np, "regulator-state-mode",
+								"normal"))
+		state->mode = REGULATOR_MODE_NORMAL;
+	else if (!of_property_match_string(np, "regulator-state-mode", "idle"))
+		state->mode = REGULATOR_MODE_IDLE;
+	else if (!of_property_match_string(np, "regulator-state-mode",
+								"standby"))
+		state->mode = REGULATOR_MODE_STANDBY;
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
+	struct device_node *state, *valid_modes;
 	struct property *prop;
 	struct regulation_constraints *constraints = &(*init_data)->constraints;
 
@@ -73,6 +98,58 @@ static void of_get_regulation_constraints(struct device_node *np,
 		else
 			constraints->ramp_disable = true;
 	}
+
+	valid_modes = of_find_node_by_name(np, "regulator-valid-modes-mask");
+	if (valid_modes) {
+		if (of_property_read_bool(valid_modes, "fast"))
+			constraints->valid_modes_mask = REGULATOR_MODE_FAST;
+		if (of_property_read_bool(valid_modes, "normal"))
+			constraints->valid_modes_mask |= REGULATOR_MODE_NORMAL;
+		if (of_property_read_bool(valid_modes, "idle"))
+			constraints->valid_modes_mask |= REGULATOR_MODE_IDLE;
+		if (of_property_read_bool(valid_modes, "standby"))
+			constraints->valid_modes_mask |= REGULATOR_MODE_STANDBY;
+	}
+
+	/* flag assignment for initial mode*/
+	if (!of_property_match_string(np, "regulator-initial-mode", "fast"))
+		constraints->initial_mode = REGULATOR_MODE_FAST;
+	else if (!of_property_match_string(np, "regulator-initial-mode",
+								"normal"))
+		constraints->initial_mode = REGULATOR_MODE_NORMAL;
+	else if (!of_property_match_string(np, "regulator-initial-mode",
+								"idle"))
+		constraints->initial_mode = REGULATOR_MODE_IDLE;
+	else if (!of_property_match_string(np, "regulator-initial-mode",
+								"standby"))
+		constraints->initial_mode = REGULATOR_MODE_STANDBY;
+
+	/* flag assignment for initial state*/
+	if (!of_property_match_string(np,
+				"regulator-initial-state", "suspend-mem"))
+		constraints->initial_state = PM_SUSPEND_MEM;
+	else if (!of_property_match_string(np,
+				"regulator-initial-state", "suspend-standby"))
+		constraints->initial_state = PM_SUSPEND_STANDBY;
+	else if (!of_property_match_string(np,
+				"regulator-initial-state", "suspend-disk"))
+		constraints->initial_state = PM_SUSPEND_MAX;
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
