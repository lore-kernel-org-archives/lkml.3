Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbaAPNnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:43:32 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:27510 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbaAPNn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:43:26 -0500
X-AuditID: cbfee690-b7f266d00000287c-ae-52d7e1fc6cd6
Date: Thu, 16 Jan 2014 13:43:24 +0000 (GMT)
From: Saurabh Singh <saurabh1.s@samsung.com>
Subject: Re: [PATCH] Parse missing regulator constraints from device tree blob
To: Mark Rutland <mark.rutland@arm.com>
Cc: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
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
X-MTR: 20140116134145668@saurabh1.s
Msgkey: 20140116134145668@saurabh1.s
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140116134145668@saurabh1.s
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <27224826.584141389879802275.JavaMail.weblogic@epml20>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42JZI2JSo/v34fUgg451LBaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj95xOxoJ5ThUn3rQzNTAecOhi5OQQElCVmL1nCyOILSFgIvFz
	43ooW0ziwr31bF2MXEA1SxklWp/2sXYxcoAVHV6WDBGfzyjRtPgsC0gDC9Cgl/92sYLYbAK6
	Eg/X32UHsYUF/CT2tHxkArFFBDQlVl5bxwTSzCzwjFni2fPjbBBXKEice94JVsQrIChxcuYT
	FogrlCWeLG9lhYirSDxoOs0GEZeTWDL1MhOEzSsxo/0pC0x82tc1zBC2tMT5WRvgvln8/TFU
	nF/i2O0dTBDP8Eo8uR8MM2b35i9Q4wUkpp45CNWqIdG78x+UzSexZuFbFpgxu04tZ4bpvb9l
	Ltg5zAKKElO6H7JD2AYSRxbNYUX3Fq+Ak8Sco2uYJzAqz0KSmoWkfRaSdmQ1CxhZVjGKphYk
	FxQnpReZ6BUn5haX5qXrJefnbmIEJobT/55N2MF474D1IcZkYJxMZJYSTc4HJpa8knhDYzMj
	C1MTU2Mjc0sz0oSVxHnVHiUFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamCsOR32d5n9NM/C
	RxOVy70K9aUN2C3/ljz+HHc+Se/DwT9iL7YbzelmCOn/+XFVZN8L3uZa4buuvpKtNVLrXhzy
	uX6W7ZaK8oUzOoq6XBECskurPm/cXrLqk9KiR177D3jpM/BpWGvVMSxnsm7+8k7RmnPp35Nf
	J07kb93Vc2t7WIyF/jyetjNKLMUZiYZazEXFiQB0386mIgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e/2DN0/D68HGaxYaWFxedccNgdGj8+b
	5AIYo9JsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaINzY30jAz0TI30DE1jrQwNDIxMgWoS0jJ+
	z+lkLJjnVHHiTTtTA+MBhy5GTg4hAVWJ2Xu2MHYxcnBICJhIHF6WDBKWEBCTuHBvPVsXIxdQ
	yXxGiabFZ1lAEixA9S//7WIFsdkEdCUerr/LDmILC/hJ7Gn5yARiiwhoSqy8to4JpJlZ4Bmz
	xLPnx9kglilInHveCVbEKyAocXLmExaIbcoST5a3skLEVSQeNJ1mg4jLSSyZepkJwuaVmNH+
	lAUmPu3rGmYIW1ri/KwNjDBXL/7+GCrOL3Hs9g4miMd4JZ7cD4YZs3vzF6jxAhJTzxyEatWQ
	6N35D8rmk1iz8C0LzJhdp5Yzw/Te3zIX7BxmAUWJKd0P2SFsA4kji+awonuLV8BJYs7RNcwT
	GOVmIUnNQtI+C0k7spoFjCyrGEVTC5ILipPSKwz1ihNzi0vz0vWS83M3MYLT07OFOxi/nLc+
	xCjAwajEw7vj4bUgIdbEsuLK3EOMEhzMSiK8ZruvBwnxpiRWVqUW5ccXleakFh9iTAbG4ERm
	KdHkfGDqzCuJNzQ2MTc1NrUwMDQ3NyNNWEmc9+7NpCAhgfTEktTs1NSC1CKYLUwcnFINjOor
	V6lyeZ+TcS5JibCccW3h3bVvn+ppRlalXOxPXn4rdOLbxFT238GLdTXXZlfrze9j/8c5yy55
	63vZWRIS01Tfd239Z6Fb5ufNbrrg9fXmE6+Oqz3leJN0uel229pjTzUqvFgMtOftPO5iWhO1
	x/zdz8UuszWj/VgCcl7bHn9/6V/JSW7pDiWW4oxEQy3mouJEADkkdfGTAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0GDhdJG018061

Hi Mark,

New patch incorporating your suggestions is given below.

> * None of these properties are documented. Documentation is required so
>   that the contract is defined. That allows people to learn how to use
>   the properties, and makes clear what we can and cannot change
>   kernel-side.
Done.  The documentation is in the patch below.

> * It leaks Linux internal details (e.g. suspend_state_t values,
>   valid_mode_mask) without any attempt at abstraction, in violation of
>   dt principles.
Unlike valid_ops_mask, valid_mode_mask cannot be derived from the other settings.
It depends on the hardware (regulator) capability. So, it has to be specified in DT blob.

> * Accessors are used poorly. Endianness conversion is done manually
>   rather than being left to accessors, and property lengths aren't
>   checked.
Used the accessors for u32 and bool.

> 	u32 uv;
> 	of_property_read_u32(np, "regulator-state-uv", &uv);
> 
> However, as far as I can see this value should come from an input supply
> anyway.
This is not input supply. This is operating voltage to be set when device suspends.

diffstat for this patch is:
 Documentation/devicetree/bindings/regulator/regulator.txt |   19 ++++++
 drivers/regulator/of_regulator.c                          |   41 ++++++++++++++
 2 files changed, 60 insertions(+)

To apply the patch, in the root of a kernel tree use:
patch -p1 < of_regulator.patch

Please let me know any feedback you have on this patch or the approach used.

Regards,
=====================
Saurabh Singh Sengar
Lead Engineer
Samsung R&D Institute
India
Samsung
=====================
Signed-off-by: Saurabh Singh Sengar <saurabh1.s@samsung.com>

--------------------------------------------------------------------------------
diff -uprN -X linux-3.12.6-vanilla/Documentation/dontdiff linux-3.12.6-vanilla/Documentation/devicetree/bindings/regulator/regulator.txt linux-3.12.6/Documentation/devicetree/bindings/regulator/regulator.txt
--- linux-3.12.6-vanilla/Documentation/devicetree/bindings/regulator/regulator.txt	2013-12-20 21:21:33.000000000 +0530
+++ linux-3.12.6/Documentation/devicetree/bindings/regulator/regulator.txt	2014-01-16 18:47:17.708608811 +0530
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
diff -uprN -X linux-3.12.6-vanilla/Documentation/dontdiff linux-3.12.6-vanilla/drivers/regulator/of_regulator.c linux-3.12.6/drivers/regulator/of_regulator.c
--- linux-3.12.6-vanilla/drivers/regulator/of_regulator.c	2013-12-20 21:21:33.000000000 +0530
+++ linux-3.12.6/drivers/regulator/of_regulator.c	2014-01-16 18:45:44.135928414 +0530
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
 
@@ -73,6 +89,31 @@ static void of_get_regulation_constraint
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
 
 /**ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
