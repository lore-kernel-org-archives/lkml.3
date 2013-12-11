Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab3LKLQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:16:39 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:46092 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab3LKLQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:16:20 -0500
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 1/5] dt/bindings: Remove all references to device_type "ethernet-phy"
Date: Wed, 11 Dec 2013 11:15:51 +0000
Message-Id: <1386760555-22732-2-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386760555-22732-1-git-send-email-grant.likely@linaro.org>
References: <1386760555-22732-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device_type property is deprecated for the flattened device tree and
the value "ethernet-phy" has never been defined as having a useful
meaning. Neither the kernel nor u-boot depend on it. It should never
have appeared in PHY bindings. This patch removes all references to
"ethernet-phy" as a device_type value from the documentation and the
.dts files.

This patch was generated mechanically with the following command and
then verified by looking at the diff.

sed -i '/"ethernet-phy"/d' `git grep -l '"ethernet-phy"'`

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 Documentation/devicetree/bindings/marvell.txt               | 2 --
 Documentation/devicetree/bindings/net/marvell-orion-net.txt | 1 -
 Documentation/devicetree/bindings/net/phy.txt               | 2 --
 Documentation/devicetree/booting-without-of.txt             | 3 ---
 arch/arm/boot/dts/dove.dtsi                                 | 1 -
 arch/arm/boot/dts/kirkwood-cloudbox.dts                     | 1 -
 arch/arm/boot/dts/kirkwood-db.dtsi                          | 1 -
 arch/arm/boot/dts/kirkwood-dnskw.dtsi                       | 1 -
 arch/arm/boot/dts/kirkwood-dockstar.dts                     | 1 -
 arch/arm/boot/dts/kirkwood-dreamplug.dts                    | 2 --
 arch/arm/boot/dts/kirkwood-goflexnet.dts                    | 1 -
 arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts         | 2 --
 arch/arm/boot/dts/kirkwood-ib62x0.dts                       | 1 -
 arch/arm/boot/dts/kirkwood-iconnect.dts                     | 1 -
 arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts               | 1 -
 arch/arm/boot/dts/kirkwood-km_kirkwood.dts                  | 1 -
 arch/arm/boot/dts/kirkwood-lsxl.dtsi                        | 2 --
 arch/arm/boot/dts/kirkwood-mplcec4.dts                      | 2 --
 arch/arm/boot/dts/kirkwood-netgear_readynas_duo_v2.dts      | 1 -
 arch/arm/boot/dts/kirkwood-ns2-common.dtsi                  | 1 -
 arch/arm/boot/dts/kirkwood-openblocks_a6.dts                | 1 -
 arch/arm/boot/dts/kirkwood-openblocks_a7.dts                | 2 --
 arch/arm/boot/dts/kirkwood-sheevaplug-common.dtsi           | 1 -
 arch/arm/boot/dts/kirkwood-topkick.dts                      | 1 -
 arch/arm/boot/dts/kirkwood-ts219.dtsi                       | 1 -
 arch/arm/boot/dts/orion5x-lacie-ethernet-disk-mini-v2.dts   | 1 -
 arch/powerpc/boot/dts/adder875-redboot.dts                  | 2 --
 arch/powerpc/boot/dts/adder875-uboot.dts                    | 2 --
 arch/powerpc/boot/dts/asp834x-redboot.dts                   | 2 --
 arch/powerpc/boot/dts/c2k.dts                               | 3 ---
 arch/powerpc/boot/dts/ep8248e.dts                           | 2 --
 arch/powerpc/boot/dts/ep88xc.dts                            | 2 --
 arch/powerpc/boot/dts/gef_ppc9a.dts                         | 2 --
 arch/powerpc/boot/dts/gef_sbc310.dts                        | 2 --
 arch/powerpc/boot/dts/gef_sbc610.dts                        | 2 --
 arch/powerpc/boot/dts/ksi8560.dts                           | 3 ---
 arch/powerpc/boot/dts/mpc8272ads.dts                        | 2 --
 arch/powerpc/boot/dts/mpc8308_p1m.dts                       | 2 --
 arch/powerpc/boot/dts/mpc8308rdb.dts                        | 1 -
 arch/powerpc/boot/dts/mpc8313erdb.dts                       | 1 -
 arch/powerpc/boot/dts/mpc8315erdb.dts                       | 2 --
 arch/powerpc/boot/dts/mpc832x_mds.dts                       | 2 --
 arch/powerpc/boot/dts/mpc832x_rdb.dts                       | 2 --
 arch/powerpc/boot/dts/mpc8349emitx.dts                      | 1 -
 arch/powerpc/boot/dts/mpc8349emitxgp.dts                    | 1 -
 arch/powerpc/boot/dts/mpc834x_mds.dts                       | 2 --
 arch/powerpc/boot/dts/mpc836x_mds.dts                       | 2 --
 arch/powerpc/boot/dts/mpc836x_rdk.dts                       | 4 ----
 arch/powerpc/boot/dts/mpc8377_mds.dts                       | 2 --
 arch/powerpc/boot/dts/mpc8377_rdb.dts                       | 1 -
 arch/powerpc/boot/dts/mpc8377_wlan.dts                      | 2 --
 arch/powerpc/boot/dts/mpc8378_mds.dts                       | 2 --
 arch/powerpc/boot/dts/mpc8378_rdb.dts                       | 1 -
 arch/powerpc/boot/dts/mpc8379_mds.dts                       | 2 --
 arch/powerpc/boot/dts/mpc8379_rdb.dts                       | 1 -
 arch/powerpc/boot/dts/mpc8536ds.dtsi                        | 2 --
 arch/powerpc/boot/dts/mpc8540ads.dts                        | 3 ---
 arch/powerpc/boot/dts/mpc8541cds.dts                        | 2 --
 arch/powerpc/boot/dts/mpc8544ds.dtsi                        | 2 --
 arch/powerpc/boot/dts/mpc8548cds.dtsi                       | 4 ----
 arch/powerpc/boot/dts/mpc8555cds.dts                        | 2 --
 arch/powerpc/boot/dts/mpc8560ads.dts                        | 4 ----
 arch/powerpc/boot/dts/mpc8568mds.dts                        | 8 --------
 arch/powerpc/boot/dts/mpc8569mds.dts                        | 6 ------
 arch/powerpc/boot/dts/mpc8641_hpcn.dts                      | 4 ----
 arch/powerpc/boot/dts/mpc8641_hpcn_36b.dts                  | 4 ----
 arch/powerpc/boot/dts/mpc866ads.dts                         | 1 -
 arch/powerpc/boot/dts/mpc885ads.dts                         | 3 ---
 arch/powerpc/boot/dts/p1021mds.dts                          | 2 --
 arch/powerpc/boot/dts/p1025rdb_32b.dts                      | 2 --
 arch/powerpc/boot/dts/ppa8548.dts                           | 2 --
 arch/powerpc/boot/dts/pq2fads.dts                           | 2 --
 arch/powerpc/boot/dts/prpmc2800.dts                         | 2 --
 arch/powerpc/boot/dts/sbc8349.dts                           | 2 --
 arch/powerpc/boot/dts/sbc8548-post.dtsi                     | 2 --
 arch/powerpc/boot/dts/sbc8641d.dts                          | 4 ----
 arch/powerpc/boot/dts/stx_gp3_8560.dts                      | 2 --
 arch/powerpc/boot/dts/stxssa8555.dts                        | 2 --
 arch/powerpc/boot/dts/tqm8540.dts                           | 3 ---
 arch/powerpc/boot/dts/tqm8541.dts                           | 3 ---
 arch/powerpc/boot/dts/tqm8548-bigflash.dts                  | 5 -----
 arch/powerpc/boot/dts/tqm8548.dts                           | 5 -----
 arch/powerpc/boot/dts/tqm8555.dts                           | 3 ---
 arch/powerpc/boot/dts/tqm8560.dts                           | 3 ---
 arch/powerpc/boot/dts/tqm8xx.dts                            | 1 -
 85 files changed, 180 deletions(-)

diff --git a/Documentation/devicetree/bindings/marvell.txt b/Documentation/devicetree/bindings/marvell.txt
index f7a0da6b4022..73a3d251acb1 100644
--- a/Documentation/devicetree/bindings/marvell.txt
+++ b/Documentation/devicetree/bindings/marvell.txt
@@ -159,7 +159,6 @@ prefixed with the string "marvell,", for Marvell Technology Group Ltd.
    c) Marvell Discovery PHY nodes
 
    Required properties:
-     - device_type : Should be "ethernet-phy"
      - interrupts : <a> where a is the interrupt number for this phy.
      - interrupt-parent : the phandle for the interrupt controller that
        services interrupts for this device.
@@ -167,7 +166,6 @@ prefixed with the string "marvell,", for Marvell Technology Group Ltd.
 
    Example Discovery PHY node:
      ethernet-phy@1 {
-	     device_type = "ethernet-phy";
 	     compatible = "broadcom,bcm5421";
 	     interrupts = <76>;      /* GPP 12 */
 	     interrupt-parent = <&PIC>;
diff --git a/Documentation/devicetree/bindings/net/marvell-orion-net.txt b/Documentation/devicetree/bindings/net/marvell-orion-net.txt
index a73b79f227e1..4a10716ff59d 100644
--- a/Documentation/devicetree/bindings/net/marvell-orion-net.txt
+++ b/Documentation/devicetree/bindings/net/marvell-orion-net.txt
@@ -61,7 +61,6 @@ or
 mdio-bus {
 	...
 	ethphy: ethernet-phy@8 {
-		device_type = "ethernet-phy";
 		...
 	};
 };
diff --git a/Documentation/devicetree/bindings/net/phy.txt b/Documentation/devicetree/bindings/net/phy.txt
index 7cd18fbfcf71..506db4ba3e8a 100644
--- a/Documentation/devicetree/bindings/net/phy.txt
+++ b/Documentation/devicetree/bindings/net/phy.txt
@@ -2,7 +2,6 @@ PHY nodes
 
 Required properties:
 
- - device_type : Should be "ethernet-phy"
  - interrupts : <a b> where a is the interrupt number and b is a
    field that represents an encoding of the sense and level
    information for the interrupt.  This should be encoded based on
@@ -31,5 +30,4 @@ ethernet-phy@0 {
 	interrupt-parent = <40000>;
 	interrupts = <35 1>;
 	reg = <0>;
-	device_type = "ethernet-phy";
 };
diff --git a/Documentation/devicetree/booting-without-of.txt b/Documentation/devicetree/booting-without-of.txt
index b2fb2f5e1922..1f013bd0d320 100644
--- a/Documentation/devicetree/booting-without-of.txt
+++ b/Documentation/devicetree/booting-without-of.txt
@@ -1364,19 +1364,16 @@ Appendix A - Sample SOC node for MPC8540
 				phy0: ethernet-phy@0 {
 					interrupts = <5 1>;
 					reg = <0>;
-					device_type = "ethernet-phy";
 				};
 
 				phy1: ethernet-phy@1 {
 					interrupts = <5 1>;
 					reg = <1>;
-					device_type = "ethernet-phy";
 				};
 
 				phy3: ethernet-phy@3 {
 					interrupts = <7 1>;
 					reg = <3>;
-					device_type = "ethernet-phy";
 				};
 			};
 		};
diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index 113a8bc7bee7..9311edf441c6 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -559,7 +559,6 @@
 				status = "disabled";
 
 				ethphy: ethernet-phy {
-					device-type = "ethernet-phy";
 					/* set phy address in board file */
 				};
 			};
diff --git a/arch/arm/boot/dts/kirkwood-cloudbox.dts b/arch/arm/boot/dts/kirkwood-cloudbox.dts
index 142b9cd3b454..14fd53d1bf8a 100644
--- a/arch/arm/boot/dts/kirkwood-cloudbox.dts
+++ b/arch/arm/boot/dts/kirkwood-cloudbox.dts
@@ -94,7 +94,6 @@
 	status = "okay";
 
 	ethphy0: ethernet-phy@0 {
-		device_type = "ethernet-phy";
 		reg = <0>;
 	};
 };
diff --git a/arch/arm/boot/dts/kirkwood-db.dtsi b/arch/arm/boot/dts/kirkwood-db.dtsi
index 053aa20fb30f..0de6d7110c35 100644
--- a/arch/arm/boot/dts/kirkwood-db.dtsi
+++ b/arch/arm/boot/dts/kirkwood-db.dtsi
@@ -84,7 +84,6 @@
 	status = "okay";
 
 	ethphy0: ethernet-phy@8 {
-		device_type = "ethernet-phy";
 		reg = <8>;
 	};
 };
diff --git a/arch/arm/boot/dts/kirkwood-dnskw.dtsi b/arch/arm/boot/dts/kirkwood-dnskw.dtsi
index aefa375a550d..e5ede2fe05ba 100644
--- a/arch/arm/boot/dts/kirkwood-dnskw.dtsi
+++ b/arch/arm/boot/dts/kirkwood-dnskw.dtsi
@@ -224,7 +224,6 @@
 	status = "okay";
 
 	ethphy0: ethernet-phy@8 {
-		device_type = "ethernet-phy";
 		reg = <8>;
 	};
 };
diff --git a/arch/arm/boot/dts/kirkwood-dockstar.dts b/arch/arm/boot/dts/kirkwood-dockstar.dts
index 33ff368fbfa5..aa6725577fc6 100644
--- a/arch/arm/boot/dts/kirkwood-dockstar.dts
+++ b/arch/arm/boot/dts/kirkwood-dockstar.dts
@@ -95,7 +95,6 @@
 	status = "okay";
 
 	ethphy0: ethernet-phy@0 {
-		device_type = "ethernet-phy";
 		compatible = "marvell,88e1116";
 		reg = <0>;
 	};
diff --git a/arch/arm/boot/dts/kirkwood-dreamplug.dts b/arch/arm/boot/dts/kirkwood-dreamplug.dts
index 6f62af99c9cb..12dc7d6b3231 100644
--- a/arch/arm/boot/dts/kirkwood-dreamplug.dts
+++ b/arch/arm/boot/dts/kirkwood-dreamplug.dts
@@ -104,12 +104,10 @@
 	status = "okay";
 
 	ethphy0: ethernet-phy@0 {
-		device_type = "ethernet-phy";
 		reg = <0>;
 	};
 
 	ethphy1: ethernet-phy@1 {
-		device_type = "ethernet-phy";
 		reg = <1>;
 	};
 };
diff --git a/arch/arm/boot/dts/kirkwood-goflexnet.dts b/arch/arm/boot/dts/kirkwood-goflexnet.dts
index a43bebb25110..df1f5a8b05bb 100644
--- a/arch/arm/boot/dts/kirkwood-goflexnet.dts
+++ b/arch/arm/boot/dts/kirkwood-goflexnet.dts
@@ -176,7 +176,6 @@
 	status = "okay";
 
 	ethphy0: ethernet-phy@0 {
-		device_type = "ethernet-phy";
 		reg = <0>;
 	};
 };
diff --git a/arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts b/arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts
index d30a91a5047d..b68bd22b0d77 100644
--- a/arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts
+++ b/arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts
@@ -101,13 +101,11 @@
 	status = "okay";
 
 	ethphy0: ethernet-phy@0 {
-		device_type = "ethernet-phy";
 		compatible = "marvell,88e1121";
 		reg = <0>;
 	};
 
 	ethphy1: ethernet-phy@1 {
-		device_type = "ethernet-phy";
 		compatible = "marvell,88e1121";
 		reg = <1>;
 	};
diff --git a/arch/arm/boot/dts/kirkwood-ib62x0.dts b/arch/arm/boot/dts/kirkwood-ib62x0.dts
index c5fb02f7ebc3..5c0d7250efd5 100644
--- a/arch/arm/boot/dts/kirkwood-ib62x0.dts
+++ b/arch/arm/boot/dts/kirkwood-ib62x0.dts
@@ -133,7 +133,6 @@
 	status = "okay";
 
 	ethphy0: ethernet-phy@8 {
-		device_type = "ethernet-phy";
 		reg = <8>;
 	};
 };
diff --git a/arch/arm/boot/dts/kirkwood-iconnect.dts b/arch/arm/boot/dts/kirkwood-iconnect.dts
index 4a62b206f680..42f2bd774d71 100644
--- a/arch/arm/boot/dts/kirkwood-iconnect.dts
+++ b/arch/arm/boot/dts/kirkwood-iconnect.dts
@@ -183,7 +183,6 @@
 	status = "okay";
 
 	ethphy0: ethernet-phy@11 {
-		device_type = "ethernet-phy";
 		reg = <11>;
 	};
 };
diff --git a/arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts b/arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts
index d15395d671ed..4ff9f65de2a0 100644
--- a/arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts
+++ b/arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts
@@ -200,7 +200,6 @@
 	status = "okay";
 
 	ethphy1: ethernet-phy@11 {
-		device_type = "ethernet-phy";
 		reg = <11>;
 	};
 };
diff --git a/arch/arm/boot/dts/kirkwood-km_kirkwood.dts b/arch/arm/boot/dts/kirkwood-km_kirkwood.dts
index cd44f37e54b5..0dc3cfeca4c8 100644
--- a/arch/arm/boot/dts/kirkwood-km_kirkwood.dts
+++ b/arch/arm/boot/dts/kirkwood-km_kirkwood.dts
@@ -55,7 +55,6 @@
 	status = "okay";
 
 	ethphy0: ethernet-phy@0 {
-		device_type = "ethernet-phy";
 		reg = <0>;
 	};
 };
diff --git a/arch/arm/boot/dts/kirkwood-lsxl.dtsi b/arch/arm/boot/dts/kirkwood-lsxl.dtsi
index 4e8f9e42c592..addcc89916eb 100644
--- a/arch/arm/boot/dts/kirkwood-lsxl.dtsi
+++ b/arch/arm/boot/dts/kirkwood-lsxl.dtsi
@@ -212,12 +212,10 @@
 	status = "okay";
 
 	ethphy0: ethernet-phy@0 {
-		device_type = "ethernet-phy";
 		reg = <0>;
 	};
 
 	ethphy1: ethernet-phy@8 {
-		device_type = "ethernet-phy";
 		reg = <8>;
 	};
 };
diff --git a/arch/arm/boot/dts/kirkwood-mplcec4.dts b/arch/arm/boot/dts/kirkwood-mplcec4.dts
index 6c1ec2786e6e..8b78241dfe6d 100644
--- a/arch/arm/boot/dts/kirkwood-mplcec4.dts
+++ b/arch/arm/boot/dts/kirkwood-mplcec4.dts
@@ -197,12 +197,10 @@
 	status = "okay";
 
 	ethphy0: ethernet-phy@1 {
-		device_type = "ethernet-phy";
 		reg = <1>;
 	};
 
 	ethphy1: ethernet-phy@2 {
-		device_type = "ethernet-phy";
 		reg = <2>;
 	};
 };
diff --git a/arch/arm/boot/dts/kirkwood-netgear_readynas_duo_v2.dts b/arch/arm/boot/dts/kirkwood-netgear_readynas_duo_v2.dts
index e6a102cf424c..00c0669b1b8c 100644
--- a/arch/arm/boot/dts/kirkwood-netgear_readynas_duo_v2.dts
+++ b/arch/arm/boot/dts/kirkwood-netgear_readynas_duo_v2.dts
@@ -211,7 +211,6 @@
 	status = "okay";
 
 	ethphy0: ethernet-phy@0 {
-		device_type = "ethernet-phy";
 		reg = <0>;
 	};
 };
diff --git a/arch/arm/boot/dts/kirkwood-ns2-common.dtsi b/arch/arm/boot/dts/kirkwood-ns2-common.dtsi
index 2fcb82e20828..53ca709c8e29 100644
--- a/arch/arm/boot/dts/kirkwood-ns2-common.dtsi
+++ b/arch/arm/boot/dts/kirkwood-ns2-common.dtsi
@@ -89,7 +89,6 @@
 	status = "okay";
 
 	ethphy0: ethernet-phy {
-		device_type = "ethernet-phy";
                 /* overwrite reg property in board file */
 	};
 };
diff --git a/arch/arm/boot/dts/kirkwood-openblocks_a6.dts b/arch/arm/boot/dts/kirkwood-openblocks_a6.dts
index f0e3d213604c..3d2f2b18bde0 100644
--- a/arch/arm/boot/dts/kirkwood-openblocks_a6.dts
+++ b/arch/arm/boot/dts/kirkwood-openblocks_a6.dts
@@ -171,7 +171,6 @@
 	status = "okay";
 
 	ethphy0: ethernet-phy@0 {
-		device_type = "ethernet-phy";
 		reg = <0>;
 	};
 };
diff --git a/arch/arm/boot/dts/kirkwood-openblocks_a7.dts b/arch/arm/boot/dts/kirkwood-openblocks_a7.dts
index 851fb2a60f20..24b063f1b698 100644
--- a/arch/arm/boot/dts/kirkwood-openblocks_a7.dts
+++ b/arch/arm/boot/dts/kirkwood-openblocks_a7.dts
@@ -196,12 +196,10 @@
 	status = "okay";
 
 	ethphy0: ethernet-phy@0 {
-		device_type = "ethernet-phy";
 		reg = <0>;
 	};
 
 	ethphy1: ethernet-phy@1 {
-		device_type = "ethernet-phy";
 		reg = <1>;
 	};
 };
diff --git a/arch/arm/boot/dts/kirkwood-sheevaplug-common.dtsi b/arch/arm/boot/dts/kirkwood-sheevaplug-common.dtsi
index 1173d7fb31b2..428aeff275ea 100644
--- a/arch/arm/boot/dts/kirkwood-sheevaplug-common.dtsi
+++ b/arch/arm/boot/dts/kirkwood-sheevaplug-common.dtsi
@@ -96,7 +96,6 @@
 	status = "okay";
 
 	ethphy0: ethernet-phy@0 {
-		device_type = "ethernet-phy";
 		reg = <0>;
 	};
 };
diff --git a/arch/arm/boot/dts/kirkwood-topkick.dts b/arch/arm/boot/dts/kirkwood-topkick.dts
index 320da677b984..67b8c91bca4d 100644
--- a/arch/arm/boot/dts/kirkwood-topkick.dts
+++ b/arch/arm/boot/dts/kirkwood-topkick.dts
@@ -208,7 +208,6 @@
 	status = "okay";
 
 	ethphy0: ethernet-phy@0 {
-		device_type = "ethernet-phy";
 		reg = <0>;
 	};
 };
diff --git a/arch/arm/boot/dts/kirkwood-ts219.dtsi b/arch/arm/boot/dts/kirkwood-ts219.dtsi
index 39158cf16258..911f3a8cee23 100644
--- a/arch/arm/boot/dts/kirkwood-ts219.dtsi
+++ b/arch/arm/boot/dts/kirkwood-ts219.dtsi
@@ -104,7 +104,6 @@
 	status = "okay";
 
 	ethphy0: ethernet-phy {
-		device_type = "ethernet-phy";
                 /* overwrite reg property in board file */
 	};
 };
diff --git a/arch/arm/boot/dts/orion5x-lacie-ethernet-disk-mini-v2.dts b/arch/arm/boot/dts/orion5x-lacie-ethernet-disk-mini-v2.dts
index aed83deaa991..5ed6c1376901 100644
--- a/arch/arm/boot/dts/orion5x-lacie-ethernet-disk-mini-v2.dts
+++ b/arch/arm/boot/dts/orion5x-lacie-ethernet-disk-mini-v2.dts
@@ -58,7 +58,6 @@
 	status = "okay";
 
 	ethphy: ethernet-phy {
-		device-type = "ethernet-phy";
 		reg = <8>;
 	};
 };
diff --git a/arch/powerpc/boot/dts/adder875-redboot.dts b/arch/powerpc/boot/dts/adder875-redboot.dts
index 28e9cd3d7a21..083984720b2f 100644
--- a/arch/powerpc/boot/dts/adder875-redboot.dts
+++ b/arch/powerpc/boot/dts/adder875-redboot.dts
@@ -87,12 +87,10 @@
 
 			PHY0: ethernet-phy@0 {
 				reg = <0>;
-				device_type = "ethernet-phy";
 			};
 
 			PHY1: ethernet-phy@1 {
 				reg = <1>;
-				device_type = "ethernet-phy";
 			};
 		};
 
diff --git a/arch/powerpc/boot/dts/adder875-uboot.dts b/arch/powerpc/boot/dts/adder875-uboot.dts
index 54fb60ec03e5..e4554caf8f8d 100644
--- a/arch/powerpc/boot/dts/adder875-uboot.dts
+++ b/arch/powerpc/boot/dts/adder875-uboot.dts
@@ -86,12 +86,10 @@
 
 			PHY0: ethernet-phy@0 {
 				reg = <0>;
-				device_type = "ethernet-phy";
 			};
 
 			PHY1: ethernet-phy@1 {
 				reg = <1>;
-				device_type = "ethernet-phy";
 			};
 		};
 
diff --git a/arch/powerpc/boot/dts/asp834x-redboot.dts b/arch/powerpc/boot/dts/asp834x-redboot.dts
index 227290db866d..9198745f45fb 100644
--- a/arch/powerpc/boot/dts/asp834x-redboot.dts
+++ b/arch/powerpc/boot/dts/asp834x-redboot.dts
@@ -207,14 +207,12 @@
 					interrupt-parent = <&ipic>;
 					interrupts = <17 0x8>;
 					reg = <0x1>;
-					device_type = "ethernet-phy";
 				};
 
 				phy1: ethernet-phy@1 {
 					interrupt-parent = <&ipic>;
 					interrupts = <18 0x8>;
 					reg = <0x2>;
-					device_type = "ethernet-phy";
 				};
 
 				tbi0: tbi-phy@11 {
diff --git a/arch/powerpc/boot/dts/c2k.dts b/arch/powerpc/boot/dts/c2k.dts
index f5d625fa3e52..de2044b33336 100644
--- a/arch/powerpc/boot/dts/c2k.dts
+++ b/arch/powerpc/boot/dts/c2k.dts
@@ -73,19 +73,16 @@
 			compatible = "marvell,mv64360-mdio";
 			reg = <0x2000 4>;
 			PHY0: ethernet-phy@0 {
-				device_type = "ethernet-phy";
 				interrupts = <76>;	/* GPP 12 */
 				interrupt-parent = <&PIC>;
 				reg = <0>;
 			};
 			PHY1: ethernet-phy@1 {
-				device_type = "ethernet-phy";
 				interrupts = <76>;	/* GPP 12 */
 				interrupt-parent = <&PIC>;
 				reg = <1>;
 			};
 			PHY2: ethernet-phy@2 {
-				device_type = "ethernet-phy";
 				interrupts = <76>;	/* GPP 12 */
 				interrupt-parent = <&PIC>;
 				reg = <2>;
diff --git a/arch/powerpc/boot/dts/ep8248e.dts b/arch/powerpc/boot/dts/ep8248e.dts
index 756758fb5b7b..244934fa2419 100644
--- a/arch/powerpc/boot/dts/ep8248e.dts
+++ b/arch/powerpc/boot/dts/ep8248e.dts
@@ -76,13 +76,11 @@
 				PHY0: ethernet-phy@0 {
 					interrupt-parent = <&PIC>;
 					reg = <0>;
-					device_type = "ethernet-phy";
 				};
 
 				PHY1: ethernet-phy@1 {
 					interrupt-parent = <&PIC>;
 					reg = <1>;
-					device_type = "ethernet-phy";
 				};
 			};
 		};
diff --git a/arch/powerpc/boot/dts/ep88xc.dts b/arch/powerpc/boot/dts/ep88xc.dts
index ae57d6240120..2aa5bf559645 100644
--- a/arch/powerpc/boot/dts/ep88xc.dts
+++ b/arch/powerpc/boot/dts/ep88xc.dts
@@ -85,12 +85,10 @@
 
 			PHY0: ethernet-phy@0 {
 				reg = <0x0>;
-				device_type = "ethernet-phy";
 			};
 
 			PHY1: ethernet-phy@1 {
 				reg = <0x1>;
-				device_type = "ethernet-phy";
 			};
 		};
 
diff --git a/arch/powerpc/boot/dts/gef_ppc9a.dts b/arch/powerpc/boot/dts/gef_ppc9a.dts
index 38dcb96c8e26..83eb0fda2666 100644
--- a/arch/powerpc/boot/dts/gef_ppc9a.dts
+++ b/arch/powerpc/boot/dts/gef_ppc9a.dts
@@ -292,13 +292,11 @@
 					interrupt-parent = <&gef_pic>;
 					interrupts = <0x9 0x4>;
 					reg = <1>;
-					device_type = "ethernet-phy";
 				};
 				phy2: ethernet-phy@2 {
 					interrupt-parent = <&gef_pic>;
 					interrupts = <0x8 0x4>;
 					reg = <3>;
-					device_type = "ethernet-phy";
 				};
 				tbi0: tbi-phy@11 {
 					reg = <0x11>;
diff --git a/arch/powerpc/boot/dts/gef_sbc310.dts b/arch/powerpc/boot/dts/gef_sbc310.dts
index 5ab8932d09b7..d426dd3de9ef 100644
--- a/arch/powerpc/boot/dts/gef_sbc310.dts
+++ b/arch/powerpc/boot/dts/gef_sbc310.dts
@@ -290,13 +290,11 @@
 					interrupt-parent = <&gef_pic>;
 					interrupts = <0x9 0x4>;
 					reg = <1>;
-					device_type = "ethernet-phy";
 				};
 				phy2: ethernet-phy@2 {
 					interrupt-parent = <&gef_pic>;
 					interrupts = <0x8 0x4>;
 					reg = <3>;
-					device_type = "ethernet-phy";
 				};
 				tbi0: tbi-phy@11 {
 					reg = <0x11>;
diff --git a/arch/powerpc/boot/dts/gef_sbc610.dts b/arch/powerpc/boot/dts/gef_sbc610.dts
index d5341f5741aa..5db3399b76b7 100644
--- a/arch/powerpc/boot/dts/gef_sbc610.dts
+++ b/arch/powerpc/boot/dts/gef_sbc610.dts
@@ -290,13 +290,11 @@
 					interrupt-parent = <&gef_pic>;
 					interrupts = <0x9 0x4>;
 					reg = <1>;
-					device_type = "ethernet-phy";
 				};
 				phy2: ethernet-phy@2 {
 					interrupt-parent = <&gef_pic>;
 					interrupts = <0x8 0x4>;
 					reg = <3>;
-					device_type = "ethernet-phy";
 				};
 				tbi0: tbi-phy@11 {
 					reg = <0x11>;
diff --git a/arch/powerpc/boot/dts/ksi8560.dts b/arch/powerpc/boot/dts/ksi8560.dts
index 296c572ea605..5d68236e7c3c 100644
--- a/arch/powerpc/boot/dts/ksi8560.dts
+++ b/arch/powerpc/boot/dts/ksi8560.dts
@@ -161,13 +161,11 @@
 				PHY1: ethernet-phy@1 {
 					interrupt-parent = <&mpic>;
 					reg = <0x1>;
-					device_type = "ethernet-phy";
 				};
 
 				PHY2: ethernet-phy@2 {
 					interrupt-parent = <&mpic>;
 					reg = <0x2>;
-					device_type = "ethernet-phy";
 				};
 
 				tbi0: tbi-phy@11 {
@@ -284,7 +282,6 @@
 				PHY0: ethernet-phy@0 {
 					interrupt-parent = <&mpic>;
 					reg = <0x0>;
-					device_type = "ethernet-phy";
 				};
 			};
 
diff --git a/arch/powerpc/boot/dts/mpc8272ads.dts b/arch/powerpc/boot/dts/mpc8272ads.dts
index e802ebd88cb1..0c92de74d065 100644
--- a/arch/powerpc/boot/dts/mpc8272ads.dts
+++ b/arch/powerpc/boot/dts/mpc8272ads.dts
@@ -196,14 +196,12 @@
 					interrupt-parent = <&PIC>;
 					interrupts = <23 8>;
 					reg = <0x0>;
-					device_type = "ethernet-phy";
 				};
 
 				PHY1: ethernet-phy@1 {
 					interrupt-parent = <&PIC>;
 					interrupts = <23 8>;
 					reg = <0x3>;
-					device_type = "ethernet-phy";
 				};
 			};
 
diff --git a/arch/powerpc/boot/dts/mpc8308_p1m.dts b/arch/powerpc/boot/dts/mpc8308_p1m.dts
index 22b0832b6c31..651e4f55acdb 100644
--- a/arch/powerpc/boot/dts/mpc8308_p1m.dts
+++ b/arch/powerpc/boot/dts/mpc8308_p1m.dts
@@ -189,13 +189,11 @@
 					interrupt-parent = <&ipic>;
 					interrupts = <17 0x8>;
 					reg = <0x1>;
-					device_type = "ethernet-phy";
 				};
 				phy2: ethernet-phy@2 {
 					interrupt-parent = <&ipic>;
 					interrupts = <19 0x8>;
 					reg = <0x2>;
-					device_type = "ethernet-phy";
 				};
 				tbi0: tbi-phy@11 {
 					reg = <0x11>;
diff --git a/arch/powerpc/boot/dts/mpc8308rdb.dts b/arch/powerpc/boot/dts/mpc8308rdb.dts
index f66d10d95a8d..9ce45f2efd34 100644
--- a/arch/powerpc/boot/dts/mpc8308rdb.dts
+++ b/arch/powerpc/boot/dts/mpc8308rdb.dts
@@ -166,7 +166,6 @@
 					interrupt-parent = <&ipic>;
 					interrupts = <17 0x8>;
 					reg = <0x2>;
-					device_type = "ethernet-phy";
 				};
 				tbi0: tbi-phy@11 {
 					reg = <0x11>;
diff --git a/arch/powerpc/boot/dts/mpc8313erdb.dts b/arch/powerpc/boot/dts/mpc8313erdb.dts
index 1c836c6c5be6..4b635dc4ecde 100644
--- a/arch/powerpc/boot/dts/mpc8313erdb.dts
+++ b/arch/powerpc/boot/dts/mpc8313erdb.dts
@@ -217,7 +217,6 @@
 					interrupt-parent = <&ipic>;
 					interrupts = <20 0x8>;
 					reg = <0x4>;
-					device_type = "ethernet-phy";
 				};
 				tbi0: tbi-phy@11 {
 					reg = <0x11>;
diff --git a/arch/powerpc/boot/dts/mpc8315erdb.dts b/arch/powerpc/boot/dts/mpc8315erdb.dts
index 811848e93aef..43546844ea5a 100644
--- a/arch/powerpc/boot/dts/mpc8315erdb.dts
+++ b/arch/powerpc/boot/dts/mpc8315erdb.dts
@@ -216,14 +216,12 @@
 					interrupt-parent = <&ipic>;
 					interrupts = <20 0x8>;
 					reg = <0x0>;
-					device_type = "ethernet-phy";
 				};
 
 				phy1: ethernet-phy@1 {
 					interrupt-parent = <&ipic>;
 					interrupts = <19 0x8>;
 					reg = <0x1>;
-					device_type = "ethernet-phy";
 				};
 
 				tbi0: tbi-phy@11 {
diff --git a/arch/powerpc/boot/dts/mpc832x_mds.dts b/arch/powerpc/boot/dts/mpc832x_mds.dts
index da9c72ddc343..0793cdf0d46e 100644
--- a/arch/powerpc/boot/dts/mpc832x_mds.dts
+++ b/arch/powerpc/boot/dts/mpc832x_mds.dts
@@ -356,13 +356,11 @@
 				interrupt-parent = <&ipic>;
 				interrupts = <17 0x8>;
 				reg = <0x3>;
-				device_type = "ethernet-phy";
 			};
 			phy4: ethernet-phy@04 {
 				interrupt-parent = <&ipic>;
 				interrupts = <18 0x8>;
 				reg = <0x4>;
-				device_type = "ethernet-phy";
 			};
 		};
 
diff --git a/arch/powerpc/boot/dts/mpc832x_rdb.dts b/arch/powerpc/boot/dts/mpc832x_rdb.dts
index ff7b15b340a3..91df1eb16667 100644
--- a/arch/powerpc/boot/dts/mpc832x_rdb.dts
+++ b/arch/powerpc/boot/dts/mpc832x_rdb.dts
@@ -314,13 +314,11 @@
 				interrupt-parent = <&ipic>;
 				interrupts = <0>;
 				reg = <0x0>;
-				device_type = "ethernet-phy";
 			};
 			phy04:ethernet-phy@04 {
 				interrupt-parent = <&ipic>;
 				interrupts = <0>;
 				reg = <0x4>;
-				device_type = "ethernet-phy";
 			};
 		};
 
diff --git a/arch/powerpc/boot/dts/mpc8349emitx.dts b/arch/powerpc/boot/dts/mpc8349emitx.dts
index 2608679d0d4a..cf8542401a3c 100644
--- a/arch/powerpc/boot/dts/mpc8349emitx.dts
+++ b/arch/powerpc/boot/dts/mpc8349emitx.dts
@@ -240,7 +240,6 @@
 					interrupt-parent = <&ipic>;
 					interrupts = <18 0x8>;
 					reg = <0x1c>;
-					device_type = "ethernet-phy";
 				};
 
 				tbi0: tbi-phy@11 {
diff --git a/arch/powerpc/boot/dts/mpc8349emitxgp.dts b/arch/powerpc/boot/dts/mpc8349emitxgp.dts
index 6cd044d8fb89..f00066dcc8de 100644
--- a/arch/powerpc/boot/dts/mpc8349emitxgp.dts
+++ b/arch/powerpc/boot/dts/mpc8349emitxgp.dts
@@ -176,7 +176,6 @@
 					interrupt-parent = <&ipic>;
 					interrupts = <18 0x8>;
 					reg = <0x1c>;
-					device_type = "ethernet-phy";
 				};
 
 				tbi0: tbi-phy@11 {
diff --git a/arch/powerpc/boot/dts/mpc834x_mds.dts b/arch/powerpc/boot/dts/mpc834x_mds.dts
index 4552864082c2..4843c3ff7166 100644
--- a/arch/powerpc/boot/dts/mpc834x_mds.dts
+++ b/arch/powerpc/boot/dts/mpc834x_mds.dts
@@ -193,14 +193,12 @@
 					interrupt-parent = <&ipic>;
 					interrupts = <17 0x8>;
 					reg = <0x0>;
-					device_type = "ethernet-phy";
 				};
 
 				phy1: ethernet-phy@1 {
 					interrupt-parent = <&ipic>;
 					interrupts = <18 0x8>;
 					reg = <0x1>;
-					device_type = "ethernet-phy";
 				};
 
 				tbi0: tbi-phy@11 {
diff --git a/arch/powerpc/boot/dts/mpc836x_mds.dts b/arch/powerpc/boot/dts/mpc836x_mds.dts
index 81dd513d6308..ecb6ccd3a6aa 100644
--- a/arch/powerpc/boot/dts/mpc836x_mds.dts
+++ b/arch/powerpc/boot/dts/mpc836x_mds.dts
@@ -397,13 +397,11 @@
 				interrupt-parent = <&ipic>;
 				interrupts = <17 0x8>;
 				reg = <0x0>;
-				device_type = "ethernet-phy";
 			};
 			phy1: ethernet-phy@01 {
 				interrupt-parent = <&ipic>;
 				interrupts = <18 0x8>;
 				reg = <0x1>;
-				device_type = "ethernet-phy";
 			};
 			tbi-phy@2 {
 				device_type = "tbi-phy";
diff --git a/arch/powerpc/boot/dts/mpc836x_rdk.dts b/arch/powerpc/boot/dts/mpc836x_rdk.dts
index b6e9aec1d860..daeacbdcf8b4 100644
--- a/arch/powerpc/boot/dts/mpc836x_rdk.dts
+++ b/arch/powerpc/boot/dts/mpc836x_rdk.dts
@@ -332,25 +332,21 @@
 				reg = <0x2120 0x18>;
 
 				phy1: ethernet-phy@1 {
-					device_type = "ethernet-phy";
 					compatible = "national,DP83848VV";
 					reg = <1>;
 				};
 
 				phy2: ethernet-phy@2 {
-					device_type = "ethernet-phy";
 					compatible = "broadcom,BCM5481UA2KMLG";
 					reg = <2>;
 				};
 
 				phy3: ethernet-phy@3 {
-					device_type = "ethernet-phy";
 					compatible = "national,DP83848VV";
 					reg = <3>;
 				};
 
 				phy4: ethernet-phy@4 {
-					device_type = "ethernet-phy";
 					compatible = "broadcom,BCM5481UA2KMLG";
 					reg = <4>;
 				};
diff --git a/arch/powerpc/boot/dts/mpc8377_mds.dts b/arch/powerpc/boot/dts/mpc8377_mds.dts
index cfccef57cd1d..c2c062e8175d 100644
--- a/arch/powerpc/boot/dts/mpc8377_mds.dts
+++ b/arch/powerpc/boot/dts/mpc8377_mds.dts
@@ -225,14 +225,12 @@
 					interrupt-parent = <&ipic>;
 					interrupts = <17 0x8>;
 					reg = <0x2>;
-					device_type = "ethernet-phy";
 				};
 
 				phy3: ethernet-phy@3 {
 					interrupt-parent = <&ipic>;
 					interrupts = <18 0x8>;
 					reg = <0x3>;
-					device_type = "ethernet-phy";
 				};
 
 				tbi0: tbi-phy@11 {
diff --git a/arch/powerpc/boot/dts/mpc8377_rdb.dts b/arch/powerpc/boot/dts/mpc8377_rdb.dts
index 353deff1b7f6..2b4b6532d69c 100644
--- a/arch/powerpc/boot/dts/mpc8377_rdb.dts
+++ b/arch/powerpc/boot/dts/mpc8377_rdb.dts
@@ -277,7 +277,6 @@
 					interrupt-parent = <&ipic>;
 					interrupts = <17 0x8>;
 					reg = <0x2>;
-					device_type = "ethernet-phy";
 				};
 
 				tbi0: tbi-phy@11 {
diff --git a/arch/powerpc/boot/dts/mpc8377_wlan.dts b/arch/powerpc/boot/dts/mpc8377_wlan.dts
index ef4a305a0d0c..c0c790168b96 100644
--- a/arch/powerpc/boot/dts/mpc8377_wlan.dts
+++ b/arch/powerpc/boot/dts/mpc8377_wlan.dts
@@ -253,14 +253,12 @@
 					interrupt-parent = <&ipic>;
 					interrupts = <17 0x8>;
 					reg = <0x2>;
-					device_type = "ethernet-phy";
 				};
 
 				phy3: ethernet-phy@3 {
 					interrupt-parent = <&ipic>;
 					interrupts = <18 0x8>;
 					reg = <0x3>;
-					device_type = "ethernet-phy";
 				};
 
 				tbi0: tbi-phy@11 {
diff --git a/arch/powerpc/boot/dts/mpc8378_mds.dts b/arch/powerpc/boot/dts/mpc8378_mds.dts
index 538fcb927337..1b82b77f9415 100644
--- a/arch/powerpc/boot/dts/mpc8378_mds.dts
+++ b/arch/powerpc/boot/dts/mpc8378_mds.dts
@@ -264,14 +264,12 @@
 					interrupt-parent = <&ipic>;
 					interrupts = <17 0x8>;
 					reg = <0x2>;
-					device_type = "ethernet-phy";
 				};
 
 				phy3: ethernet-phy@3 {
 					interrupt-parent = <&ipic>;
 					interrupts = <18 0x8>;
 					reg = <0x3>;
-					device_type = "ethernet-phy";
 				};
 
 				tbi0: tbi-phy@11 {
diff --git a/arch/powerpc/boot/dts/mpc8378_rdb.dts b/arch/powerpc/boot/dts/mpc8378_rdb.dts
index 32333a908f3d..74b6a535a413 100644
--- a/arch/powerpc/boot/dts/mpc8378_rdb.dts
+++ b/arch/powerpc/boot/dts/mpc8378_rdb.dts
@@ -277,7 +277,6 @@
 					interrupt-parent = <&ipic>;
 					interrupts = <17 0x8>;
 					reg = <0x2>;
-					device_type = "ethernet-phy";
 				};
 
 				tbi0: tbi-phy@11 {
diff --git a/arch/powerpc/boot/dts/mpc8379_mds.dts b/arch/powerpc/boot/dts/mpc8379_mds.dts
index 5387092fdfb4..38e5048d65d2 100644
--- a/arch/powerpc/boot/dts/mpc8379_mds.dts
+++ b/arch/powerpc/boot/dts/mpc8379_mds.dts
@@ -262,14 +262,12 @@
 					interrupt-parent = <&ipic>;
 					interrupts = <17 0x8>;
 					reg = <0x2>;
-					device_type = "ethernet-phy";
 				};
 
 				phy3: ethernet-phy@3 {
 					interrupt-parent = <&ipic>;
 					interrupts = <18 0x8>;
 					reg = <0x3>;
-					device_type = "ethernet-phy";
 				};
 
 				tbi0: tbi-phy@11 {
diff --git a/arch/powerpc/boot/dts/mpc8379_rdb.dts b/arch/powerpc/boot/dts/mpc8379_rdb.dts
index 46224c2430ff..3b5cbac85368 100644
--- a/arch/powerpc/boot/dts/mpc8379_rdb.dts
+++ b/arch/powerpc/boot/dts/mpc8379_rdb.dts
@@ -275,7 +275,6 @@
 					interrupt-parent = <&ipic>;
 					interrupts = <17 0x8>;
 					reg = <0x2>;
-					device_type = "ethernet-phy";
 				};
 
 				tbi0: tbi-phy@11 {
diff --git a/arch/powerpc/boot/dts/mpc8536ds.dtsi b/arch/powerpc/boot/dts/mpc8536ds.dtsi
index 7c3dde84d193..937ad7e46119 100644
--- a/arch/powerpc/boot/dts/mpc8536ds.dtsi
+++ b/arch/powerpc/boot/dts/mpc8536ds.dtsi
@@ -200,12 +200,10 @@
 		phy0: ethernet-phy@0 {
 			interrupts = <10 0x1 0 0>;
 			reg = <0>;
-			device_type = "ethernet-phy";
 		};
 		phy1: ethernet-phy@1 {
 			interrupts = <10 0x1 0 0>;
 			reg = <1>;
-			device_type = "ethernet-phy";
 		};
 		sgmii_phy0: sgmii-phy@0 {
 			interrupts = <6 1 0 0>;
diff --git a/arch/powerpc/boot/dts/mpc8540ads.dts b/arch/powerpc/boot/dts/mpc8540ads.dts
index 2d31863accf5..7ce274c9a2d5 100644
--- a/arch/powerpc/boot/dts/mpc8540ads.dts
+++ b/arch/powerpc/boot/dts/mpc8540ads.dts
@@ -165,19 +165,16 @@
 					interrupt-parent = <&mpic>;
 					interrupts = <5 1>;
 					reg = <0x0>;
-					device_type = "ethernet-phy";
 				};
 				phy1: ethernet-phy@1 {
 					interrupt-parent = <&mpic>;
 					interrupts = <5 1>;
 					reg = <0x1>;
-					device_type = "ethernet-phy";
 				};
 				phy3: ethernet-phy@3 {
 					interrupt-parent = <&mpic>;
 					interrupts = <7 1>;
 					reg = <0x3>;
-					device_type = "ethernet-phy";
 				};
 				tbi0: tbi-phy@11 {
 					reg = <0x11>;
diff --git a/arch/powerpc/boot/dts/mpc8541cds.dts b/arch/powerpc/boot/dts/mpc8541cds.dts
index 1c03c2667373..4d35a3e0fb02 100644
--- a/arch/powerpc/boot/dts/mpc8541cds.dts
+++ b/arch/powerpc/boot/dts/mpc8541cds.dts
@@ -165,13 +165,11 @@
 					interrupt-parent = <&mpic>;
 					interrupts = <5 1>;
 					reg = <0x0>;
-					device_type = "ethernet-phy";
 				};
 				phy1: ethernet-phy@1 {
 					interrupt-parent = <&mpic>;
 					interrupts = <5 1>;
 					reg = <0x1>;
-					device_type = "ethernet-phy";
 				};
 				tbi0: tbi-phy@11 {
 					reg = <0x11>;
diff --git a/arch/powerpc/boot/dts/mpc8544ds.dtsi b/arch/powerpc/boot/dts/mpc8544ds.dtsi
index b219d035d794..47d986b041f6 100644
--- a/arch/powerpc/boot/dts/mpc8544ds.dtsi
+++ b/arch/powerpc/boot/dts/mpc8544ds.dtsi
@@ -82,12 +82,10 @@
 		phy0: ethernet-phy@0 {
 			interrupts = <10 1 0 0>;
 			reg = <0x0>;
-			device_type = "ethernet-phy";
 		};
 		phy1: ethernet-phy@1 {
 			interrupts = <10 1 0 0>;
 			reg = <0x1>;
-			device_type = "ethernet-phy";
 		};
 
 		sgmii_phy0: sgmii-phy@0 {
diff --git a/arch/powerpc/boot/dts/mpc8548cds.dtsi b/arch/powerpc/boot/dts/mpc8548cds.dtsi
index c61f525e4740..3bc7d4711220 100644
--- a/arch/powerpc/boot/dts/mpc8548cds.dtsi
+++ b/arch/powerpc/boot/dts/mpc8548cds.dtsi
@@ -109,22 +109,18 @@
 		phy0: ethernet-phy@0 {
 			interrupts = <5 1 0 0>;
 			reg = <0x0>;
-			device_type = "ethernet-phy";
 		};
 		phy1: ethernet-phy@1 {
 			interrupts = <5 1 0 0>;
 			reg = <0x1>;
-			device_type = "ethernet-phy";
 		};
 		phy2: ethernet-phy@2 {
 			interrupts = <5 1 0 0>;
 			reg = <0x2>;
-			device_type = "ethernet-phy";
 		};
 		phy3: ethernet-phy@3 {
 			interrupts = <5 1 0 0>;
 			reg = <0x3>;
-			device_type = "ethernet-phy";
 		};
 		tbi0: tbi-phy@11 {
 			reg = <0x11>;
diff --git a/arch/powerpc/boot/dts/mpc8555cds.dts b/arch/powerpc/boot/dts/mpc8555cds.dts
index 36a7ea138c2f..f115f21cb0ae 100644
--- a/arch/powerpc/boot/dts/mpc8555cds.dts
+++ b/arch/powerpc/boot/dts/mpc8555cds.dts
@@ -165,13 +165,11 @@
 					interrupt-parent = <&mpic>;
 					interrupts = <5 1>;
 					reg = <0x0>;
-					device_type = "ethernet-phy";
 				};
 				phy1: ethernet-phy@1 {
 					interrupt-parent = <&mpic>;
 					interrupts = <5 1>;
 					reg = <0x1>;
-					device_type = "ethernet-phy";
 				};
 				tbi0: tbi-phy@11 {
 					reg = <0x11>;
diff --git a/arch/powerpc/boot/dts/mpc8560ads.dts b/arch/powerpc/boot/dts/mpc8560ads.dts
index 1a43f5a968f5..0d70921d6125 100644
--- a/arch/powerpc/boot/dts/mpc8560ads.dts
+++ b/arch/powerpc/boot/dts/mpc8560ads.dts
@@ -154,25 +154,21 @@
 					interrupt-parent = <&mpic>;
 					interrupts = <5 1>;
 					reg = <0x0>;
-					device_type = "ethernet-phy";
 				};
 				phy1: ethernet-phy@1 {
 					interrupt-parent = <&mpic>;
 					interrupts = <5 1>;
 					reg = <0x1>;
-					device_type = "ethernet-phy";
 				};
 				phy2: ethernet-phy@2 {
 					interrupt-parent = <&mpic>;
 					interrupts = <7 1>;
 					reg = <0x2>;
-					device_type = "ethernet-phy";
 				};
 				phy3: ethernet-phy@3 {
 					interrupt-parent = <&mpic>;
 					interrupts = <7 1>;
 					reg = <0x3>;
-					device_type = "ethernet-phy";
 				};
 				tbi0: tbi-phy@11 {
 					reg = <0x11>;
diff --git a/arch/powerpc/boot/dts/mpc8568mds.dts b/arch/powerpc/boot/dts/mpc8568mds.dts
index 09598bb5d443..bead2b655b9f 100644
--- a/arch/powerpc/boot/dts/mpc8568mds.dts
+++ b/arch/powerpc/boot/dts/mpc8568mds.dts
@@ -91,22 +91,18 @@
 			phy0: ethernet-phy@7 {
 				interrupts = <1 1 0 0>;
 				reg = <0x7>;
-				device_type = "ethernet-phy";
 			};
 			phy1: ethernet-phy@1 {
 				interrupts = <2 1 0 0>;
 				reg = <0x1>;
-				device_type = "ethernet-phy";
 			};
 			phy2: ethernet-phy@2 {
 				interrupts = <1 1 0 0>;
 				reg = <0x2>;
-				device_type = "ethernet-phy";
 			};
 			phy3: ethernet-phy@3 {
 				interrupts = <2 1 0 0>;
 				reg = <0x3>;
-				device_type = "ethernet-phy";
 			};
 			tbi0: tbi-phy@11 {
 				reg = <0x11>;
@@ -236,25 +232,21 @@
 				interrupt-parent = <&mpic>;
 				interrupts = <1 1 0 0>;
 				reg = <0x7>;
-				device_type = "ethernet-phy";
 			};
 			qe_phy1: ethernet-phy@01 {
 				interrupt-parent = <&mpic>;
 				interrupts = <2 1 0 0>;
 				reg = <0x1>;
-				device_type = "ethernet-phy";
 			};
 			qe_phy2: ethernet-phy@02 {
 				interrupt-parent = <&mpic>;
 				interrupts = <1 1 0 0>;
 				reg = <0x2>;
-				device_type = "ethernet-phy";
 			};
 			qe_phy3: ethernet-phy@03 {
 				interrupt-parent = <&mpic>;
 				interrupts = <2 1 0 0>;
 				reg = <0x3>;
-				device_type = "ethernet-phy";
 			};
 		};
 	};
diff --git a/arch/powerpc/boot/dts/mpc8569mds.dts b/arch/powerpc/boot/dts/mpc8569mds.dts
index fe0d60935e9b..d0dcdafa5eb2 100644
--- a/arch/powerpc/boot/dts/mpc8569mds.dts
+++ b/arch/powerpc/boot/dts/mpc8569mds.dts
@@ -276,33 +276,27 @@
 				interrupt-parent = <&mpic>;
 				interrupts = <1 1 0 0>;
 				reg = <0x7>;
-				device_type = "ethernet-phy";
 			};
 			qe_phy1: ethernet-phy@01 {
 				interrupt-parent = <&mpic>;
 				interrupts = <2 1 0 0>;
 				reg = <0x1>;
-				device_type = "ethernet-phy";
 			};
 			qe_phy2: ethernet-phy@02 {
 				interrupt-parent = <&mpic>;
 				interrupts = <3 1 0 0>;
 				reg = <0x2>;
-				device_type = "ethernet-phy";
 			};
 			qe_phy3: ethernet-phy@03 {
 				interrupt-parent = <&mpic>;
 				interrupts = <4 1 0 0>;
 				reg = <0x3>;
-				device_type = "ethernet-phy";
 			};
 			qe_phy5: ethernet-phy@04 {
 				reg = <0x04>;
-				device_type = "ethernet-phy";
 			};
 			qe_phy7: ethernet-phy@06 {
 				reg = <0x6>;
-				device_type = "ethernet-phy";
 			};
 			tbi1: tbi-phy@11 {
 				reg = <0x11>;
diff --git a/arch/powerpc/boot/dts/mpc8641_hpcn.dts b/arch/powerpc/boot/dts/mpc8641_hpcn.dts
index 1e8666ccbed8..1c03060dd0b8 100644
--- a/arch/powerpc/boot/dts/mpc8641_hpcn.dts
+++ b/arch/powerpc/boot/dts/mpc8641_hpcn.dts
@@ -211,25 +211,21 @@
 					interrupt-parent = <&mpic>;
 					interrupts = <10 1>;
 					reg = <0>;
-					device_type = "ethernet-phy";
 				};
 				phy1: ethernet-phy@1 {
 					interrupt-parent = <&mpic>;
 					interrupts = <10 1>;
 					reg = <1>;
-					device_type = "ethernet-phy";
 				};
 				phy2: ethernet-phy@2 {
 					interrupt-parent = <&mpic>;
 					interrupts = <10 1>;
 					reg = <2>;
-					device_type = "ethernet-phy";
 				};
 				phy3: ethernet-phy@3 {
 					interrupt-parent = <&mpic>;
 					interrupts = <10 1>;
 					reg = <3>;
-					device_type = "ethernet-phy";
 				};
 				tbi0: tbi-phy@11 {
 					reg = <0x11>;
diff --git a/arch/powerpc/boot/dts/mpc8641_hpcn_36b.dts b/arch/powerpc/boot/dts/mpc8641_hpcn_36b.dts
index fd4cd4da60b5..bb575e28042a 100644
--- a/arch/powerpc/boot/dts/mpc8641_hpcn_36b.dts
+++ b/arch/powerpc/boot/dts/mpc8641_hpcn_36b.dts
@@ -211,25 +211,21 @@
 					interrupt-parent = <&mpic>;
 					interrupts = <10 1>;
 					reg = <0>;
-					device_type = "ethernet-phy";
 				};
 				phy1: ethernet-phy@1 {
 					interrupt-parent = <&mpic>;
 					interrupts = <10 1>;
 					reg = <1>;
-					device_type = "ethernet-phy";
 				};
 				phy2: ethernet-phy@2 {
 					interrupt-parent = <&mpic>;
 					interrupts = <10 1>;
 					reg = <2>;
-					device_type = "ethernet-phy";
 				};
 				phy3: ethernet-phy@3 {
 					interrupt-parent = <&mpic>;
 					interrupts = <10 1>;
 					reg = <3>;
-					device_type = "ethernet-phy";
 				};
 				tbi0: tbi-phy@11 {
 					reg = <0x11>;
diff --git a/arch/powerpc/boot/dts/mpc866ads.dts b/arch/powerpc/boot/dts/mpc866ads.dts
index bd700651f360..34c1f48b1a09 100644
--- a/arch/powerpc/boot/dts/mpc866ads.dts
+++ b/arch/powerpc/boot/dts/mpc866ads.dts
@@ -74,7 +74,6 @@
 			#size-cells = <0>;
 			PHY: ethernet-phy@f {
 				reg = <0xf>;
-				device_type = "ethernet-phy";
 			};
 		};
 
diff --git a/arch/powerpc/boot/dts/mpc885ads.dts b/arch/powerpc/boot/dts/mpc885ads.dts
index b123e9f7a5a8..4e93bd961e0f 100644
--- a/arch/powerpc/boot/dts/mpc885ads.dts
+++ b/arch/powerpc/boot/dts/mpc885ads.dts
@@ -86,17 +86,14 @@
 
 			PHY0: ethernet-phy@0 {
 				reg = <0x0>;
-				device_type = "ethernet-phy";
 			};
 
 			PHY1: ethernet-phy@1 {
 				reg = <0x1>;
-				device_type = "ethernet-phy";
 			};
 
 			PHY2: ethernet-phy@2 {
 				reg = <0x2>;
-				device_type = "ethernet-phy";
 			};
 		};
 
diff --git a/arch/powerpc/boot/dts/p1021mds.dts b/arch/powerpc/boot/dts/p1021mds.dts
index 97116f198a37..76559044df41 100644
--- a/arch/powerpc/boot/dts/p1021mds.dts
+++ b/arch/powerpc/boot/dts/p1021mds.dts
@@ -295,13 +295,11 @@
 				interrupt-parent = <&mpic>;
 				interrupts = <4 1 0 0>;
 				reg = <0x0>;
-				device_type = "ethernet-phy";
 			};
 			qe_phy1: ethernet-phy@03 {
 				interrupt-parent = <&mpic>;
 				interrupts = <5 1 0 0>;
 				reg = <0x3>;
-				device_type = "ethernet-phy";
 			};
 			tbi-phy@11 {
 				reg = <0x11>;
diff --git a/arch/powerpc/boot/dts/p1025rdb_32b.dts b/arch/powerpc/boot/dts/p1025rdb_32b.dts
index ac5729c14eda..a2ed6280ba7a 100644
--- a/arch/powerpc/boot/dts/p1025rdb_32b.dts
+++ b/arch/powerpc/boot/dts/p1025rdb_32b.dts
@@ -105,13 +105,11 @@
 				interrupt-parent = <&mpic>;
 				interrupts = <4 1 0 0>;
 				reg = <0x6>;
-				device_type = "ethernet-phy";
 			};
 			qe_phy1: ethernet-phy@03 {
 				interrupt-parent = <&mpic>;
 				interrupts = <5 1 0 0>;
 				reg = <0x3>;
-				device_type = "ethernet-phy";
 			};
 			tbi-phy@11 {
 				reg = <0x11>;
diff --git a/arch/powerpc/boot/dts/ppa8548.dts b/arch/powerpc/boot/dts/ppa8548.dts
index f97eceed610a..27b0699ee923 100644
--- a/arch/powerpc/boot/dts/ppa8548.dts
+++ b/arch/powerpc/boot/dts/ppa8548.dts
@@ -110,12 +110,10 @@
 		phy0: ethernet-phy@0 {
 			interrupts = <7 1 0 0>;
 			reg = <0x0>;
-			device_type = "ethernet-phy";
 		};
 		phy1: ethernet-phy@1 {
 			interrupts = <8 1 0 0>;
 			reg = <0x1>;
-			device_type = "ethernet-phy";
 		};
 		tbi0: tbi-phy@11 {
 			reg = <0x11>;
diff --git a/arch/powerpc/boot/dts/pq2fads.dts b/arch/powerpc/boot/dts/pq2fads.dts
index 0bb669376743..9d065cdeb5eb 100644
--- a/arch/powerpc/boot/dts/pq2fads.dts
+++ b/arch/powerpc/boot/dts/pq2fads.dts
@@ -212,14 +212,12 @@
 					interrupt-parent = <&PIC>;
 					interrupts = <25 2>;
 					reg = <0x0>;
-					device_type = "ethernet-phy";
 				};
 
 				PHY1: ethernet-phy@1 {
 					interrupt-parent = <&PIC>;
 					interrupts = <25 2>;
 					reg = <0x3>;
-					device_type = "ethernet-phy";
 				};
 			};
 
diff --git a/arch/powerpc/boot/dts/prpmc2800.dts b/arch/powerpc/boot/dts/prpmc2800.dts
index 1ee6ff43dd57..909e8b0ead26 100644
--- a/arch/powerpc/boot/dts/prpmc2800.dts
+++ b/arch/powerpc/boot/dts/prpmc2800.dts
@@ -76,14 +76,12 @@
 			device_type = "mdio";
 			compatible = "marvell,mv64360-mdio";
 			PHY0: ethernet-phy@1 {
-				device_type = "ethernet-phy";
 				compatible = "broadcom,bcm5421";
 				interrupts = <76>;	/* GPP 12 */
 				interrupt-parent = <&PIC>;
 				reg = <1>;
 			};
 			PHY1: ethernet-phy@3 {
-				device_type = "ethernet-phy";
 				compatible = "broadcom,bcm5421";
 				interrupts = <76>;	/* GPP 12 */
 				interrupt-parent = <&PIC>;
diff --git a/arch/powerpc/boot/dts/sbc8349.dts b/arch/powerpc/boot/dts/sbc8349.dts
index b1e45a8537a5..fc89e00b765c 100644
--- a/arch/powerpc/boot/dts/sbc8349.dts
+++ b/arch/powerpc/boot/dts/sbc8349.dts
@@ -173,14 +173,12 @@
 					interrupt-parent = <&ipic>;
 					interrupts = <20 0x8>;
 					reg = <0x19>;
-					device_type = "ethernet-phy";
 				};
 
 				phy1: ethernet-phy@1a {
 					interrupt-parent = <&ipic>;
 					interrupts = <21 0x8>;
 					reg = <0x1a>;
-					device_type = "ethernet-phy";
 				};
 
 				tbi0: tbi-phy@11 {
diff --git a/arch/powerpc/boot/dts/sbc8548-post.dtsi b/arch/powerpc/boot/dts/sbc8548-post.dtsi
index 33a47e27a11e..9b505c8e5350 100644
--- a/arch/powerpc/boot/dts/sbc8548-post.dtsi
+++ b/arch/powerpc/boot/dts/sbc8548-post.dtsi
@@ -137,13 +137,11 @@
 					interrupt-parent = <&mpic>;
 					interrupts = <0x6 0x1>;
 					reg = <0x19>;
-					device_type = "ethernet-phy";
 				};
 				phy1: ethernet-phy@1a {
 					interrupt-parent = <&mpic>;
 					interrupts = <0x7 0x1>;
 					reg = <0x1a>;
-					device_type = "ethernet-phy";
 				};
 				tbi0: tbi-phy@11 {
 					reg = <0x11>;
diff --git a/arch/powerpc/boot/dts/sbc8641d.dts b/arch/powerpc/boot/dts/sbc8641d.dts
index 56bebce87842..631ede72e226 100644
--- a/arch/powerpc/boot/dts/sbc8641d.dts
+++ b/arch/powerpc/boot/dts/sbc8641d.dts
@@ -230,25 +230,21 @@
 					interrupt-parent = <&mpic>;
 					interrupts = <10 1>;
 					reg = <0x1f>;
-					device_type = "ethernet-phy";
 				};
 				phy1: ethernet-phy@0 {
 					interrupt-parent = <&mpic>;
 					interrupts = <10 1>;
 					reg = <0>;
-					device_type = "ethernet-phy";
 				};
 				phy2: ethernet-phy@1 {
 					interrupt-parent = <&mpic>;
 					interrupts = <10 1>;
 					reg = <1>;
-					device_type = "ethernet-phy";
 				};
 				phy3: ethernet-phy@2 {
 					interrupt-parent = <&mpic>;
 					interrupts = <10 1>;
 					reg = <2>;
-					device_type = "ethernet-phy";
 				};
 				tbi0: tbi-phy@11 {
 					reg = <0x11>;
diff --git a/arch/powerpc/boot/dts/stx_gp3_8560.dts b/arch/powerpc/boot/dts/stx_gp3_8560.dts
index b670d03fbcd9..78a72ee48205 100644
--- a/arch/powerpc/boot/dts/stx_gp3_8560.dts
+++ b/arch/powerpc/boot/dts/stx_gp3_8560.dts
@@ -161,13 +161,11 @@
 					interrupt-parent = <&mpic>;
 					interrupts = <5 4>;
 					reg = <2>;
-					device_type = "ethernet-phy";
 				};
 				phy4: ethernet-phy@4 {
 					interrupt-parent = <&mpic>;
 					interrupts = <5 4>;
 					reg = <4>;
-					device_type = "ethernet-phy";
 				};
 				tbi0: tbi-phy@11 {
 					reg = <0x11>;
diff --git a/arch/powerpc/boot/dts/stxssa8555.dts b/arch/powerpc/boot/dts/stxssa8555.dts
index 4f166b01c1b6..859f854ba538 100644
--- a/arch/powerpc/boot/dts/stxssa8555.dts
+++ b/arch/powerpc/boot/dts/stxssa8555.dts
@@ -164,13 +164,11 @@
 					interrupt-parent = <&mpic>;
 					interrupts = <5 1>;
 					reg = <0x2>;
-					device_type = "ethernet-phy";
 				};
 				phy1: ethernet-phy@4 {
 					interrupt-parent = <&mpic>;
 					interrupts = <5 1>;
 					reg = <0x4>;
-					device_type = "ethernet-phy";
 				};
 				tbi0: tbi-phy@11 {
 					reg = <0x11>;
diff --git a/arch/powerpc/boot/dts/tqm8540.dts b/arch/powerpc/boot/dts/tqm8540.dts
index ed264d9ae356..91cbd7acd276 100644
--- a/arch/powerpc/boot/dts/tqm8540.dts
+++ b/arch/powerpc/boot/dts/tqm8540.dts
@@ -172,19 +172,16 @@
 					interrupt-parent = <&mpic>;
 					interrupts = <8 1>;
 					reg = <1>;
-					device_type = "ethernet-phy";
 				};
 				phy2: ethernet-phy@2 {
 					interrupt-parent = <&mpic>;
 					interrupts = <8 1>;
 					reg = <2>;
-					device_type = "ethernet-phy";
 				};
 				phy3: ethernet-phy@3 {
 					interrupt-parent = <&mpic>;
 					interrupts = <8 1>;
 					reg = <3>;
-					device_type = "ethernet-phy";
 				};
 				tbi0: tbi-phy@11 {
 					reg = <0x11>;
diff --git a/arch/powerpc/boot/dts/tqm8541.dts b/arch/powerpc/boot/dts/tqm8541.dts
index 925242115814..84dce2d5fc48 100644
--- a/arch/powerpc/boot/dts/tqm8541.dts
+++ b/arch/powerpc/boot/dts/tqm8541.dts
@@ -172,19 +172,16 @@
 					interrupt-parent = <&mpic>;
 					interrupts = <8 1>;
 					reg = <1>;
-					device_type = "ethernet-phy";
 				};
 				phy2: ethernet-phy@2 {
 					interrupt-parent = <&mpic>;
 					interrupts = <8 1>;
 					reg = <2>;
-					device_type = "ethernet-phy";
 				};
 				phy3: ethernet-phy@3 {
 					interrupt-parent = <&mpic>;
 					interrupts = <8 1>;
 					reg = <3>;
-					device_type = "ethernet-phy";
 				};
 				tbi0: tbi-phy@11 {
 					reg = <0x11>;
diff --git a/arch/powerpc/boot/dts/tqm8548-bigflash.dts b/arch/powerpc/boot/dts/tqm8548-bigflash.dts
index 6e1ac50852a4..7a333dd02d9c 100644
--- a/arch/powerpc/boot/dts/tqm8548-bigflash.dts
+++ b/arch/powerpc/boot/dts/tqm8548-bigflash.dts
@@ -185,31 +185,26 @@
 					interrupt-parent = <&mpic>;
 					interrupts = <8 1>;
 					reg = <1>;
-					device_type = "ethernet-phy";
 				};
 				phy2: ethernet-phy@1 {
 					interrupt-parent = <&mpic>;
 					interrupts = <8 1>;
 					reg = <2>;
-					device_type = "ethernet-phy";
 				};
 				phy3: ethernet-phy@3 {
 					interrupt-parent = <&mpic>;
 					interrupts = <8 1>;
 					reg = <3>;
-					device_type = "ethernet-phy";
 				};
 				phy4: ethernet-phy@4 {
 					interrupt-parent = <&mpic>;
 					interrupts = <8 1>;
 					reg = <4>;
-					device_type = "ethernet-phy";
 				};
 				phy5: ethernet-phy@5 {
 					interrupt-parent = <&mpic>;
 					interrupts = <8 1>;
 					reg = <5>;
-					device_type = "ethernet-phy";
 				};
 				tbi0: tbi-phy@11 {
 					reg = <0x11>;
diff --git a/arch/powerpc/boot/dts/tqm8548.dts b/arch/powerpc/boot/dts/tqm8548.dts
index 161e75eac7f7..c737caff10c7 100644
--- a/arch/powerpc/boot/dts/tqm8548.dts
+++ b/arch/powerpc/boot/dts/tqm8548.dts
@@ -185,31 +185,26 @@
 					interrupt-parent = <&mpic>;
 					interrupts = <8 1>;
 					reg = <1>;
-					device_type = "ethernet-phy";
 				};
 				phy2: ethernet-phy@1 {
 					interrupt-parent = <&mpic>;
 					interrupts = <8 1>;
 					reg = <2>;
-					device_type = "ethernet-phy";
 				};
 				phy3: ethernet-phy@3 {
 					interrupt-parent = <&mpic>;
 					interrupts = <8 1>;
 					reg = <3>;
-					device_type = "ethernet-phy";
 				};
 				phy4: ethernet-phy@4 {
 					interrupt-parent = <&mpic>;
 					interrupts = <8 1>;
 					reg = <4>;
-					device_type = "ethernet-phy";
 				};
 				phy5: ethernet-phy@5 {
 					interrupt-parent = <&mpic>;
 					interrupts = <8 1>;
 					reg = <5>;
-					device_type = "ethernet-phy";
 				};
 				tbi0: tbi-phy@11 {
 					reg = <0x11>;
diff --git a/arch/powerpc/boot/dts/tqm8555.dts b/arch/powerpc/boot/dts/tqm8555.dts
index aa6ff0d3dd9a..d0416a5cdddf 100644
--- a/arch/powerpc/boot/dts/tqm8555.dts
+++ b/arch/powerpc/boot/dts/tqm8555.dts
@@ -172,19 +172,16 @@
 					interrupt-parent = <&mpic>;
 					interrupts = <8 1>;
 					reg = <1>;
-					device_type = "ethernet-phy";
 				};
 				phy2: ethernet-phy@2 {
 					interrupt-parent = <&mpic>;
 					interrupts = <8 1>;
 					reg = <2>;
-					device_type = "ethernet-phy";
 				};
 				phy3: ethernet-phy@3 {
 					interrupt-parent = <&mpic>;
 					interrupts = <8 1>;
 					reg = <3>;
-					device_type = "ethernet-phy";
 				};
 				tbi0: tbi-phy@11 {
 					reg = <0x11>;
diff --git a/arch/powerpc/boot/dts/tqm8560.dts b/arch/powerpc/boot/dts/tqm8560.dts
index 7665a16a8b9a..f9a11ebf736c 100644
--- a/arch/powerpc/boot/dts/tqm8560.dts
+++ b/arch/powerpc/boot/dts/tqm8560.dts
@@ -174,19 +174,16 @@
 					interrupt-parent = <&mpic>;
 					interrupts = <8 1>;
 					reg = <1>;
-					device_type = "ethernet-phy";
 				};
 				phy2: ethernet-phy@2 {
 					interrupt-parent = <&mpic>;
 					interrupts = <8 1>;
 					reg = <2>;
-					device_type = "ethernet-phy";
 				};
 				phy3: ethernet-phy@3 {
 					interrupt-parent = <&mpic>;
 					interrupts = <8 1>;
 					reg = <3>;
-					device_type = "ethernet-phy";
 				};
 				tbi0: tbi-phy@11 {
 					reg = <0x11>;
diff --git a/arch/powerpc/boot/dts/tqm8xx.dts b/arch/powerpc/boot/dts/tqm8xx.dts
index c3dba2518d8c..3d1446b99c7e 100644
--- a/arch/powerpc/boot/dts/tqm8xx.dts
+++ b/arch/powerpc/boot/dts/tqm8xx.dts
@@ -107,7 +107,6 @@
 			#size-cells = <0>;
 			PHY: ethernet-phy@f {
 				reg = <0xf>;
-				device_type = "ethernet-phy";
 			};
 		};
 
-- 
1.8.3.2

