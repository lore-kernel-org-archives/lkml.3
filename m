Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbaIPJDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 05:03:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32615 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbaIPJDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 05:03:42 -0400
X-AuditID: cbfee691-f79546d0000011a1-c5-5417fceac590
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cw00.choi@samsung.com,
        gregkh@linuxfoundation.org, naveenkrishna.ch@gmail.com,
        lars@metafoo.de, cpgs@samsung.com, grundler@chromium.org,
        jic23@kernel.org
Subject: [PATCH v2 2/3] Documentation: dt-bindings: update exynos-adc.txt with
 syscon handle
Date: Tue, 16 Sep 2014 14:28:50 +0530
Message-id: <1410857931-4980-3-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1410857931-4980-1-git-send-email-ch.naveen@samsung.com>
References: <1410857931-4980-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWyRsSkSvfVH/EQgw2XRCxeHtK0uP7lOavF
	/CPnWC2aF69ns3h15AeTxYOmVUwWSybPZ7WYd+Qdi8XlXXPYLGac38dksWjbf2YHbo/ZDRdZ
	PHbOusvusWlVJ5vH/rlr2D2WvDnE6tG3ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZh6a1MRc0
	81f8XhLbwLiRp4uRk0NCwERi/c65TBC2mMSFe+vZuhi5OIQEljJKLPp4hhmm6OLHNewQiemM
	Emcvz2OBcPqZJO41vAJrZxMwkzi4aDU7iC0iECfx4XI/WAezwH5Gidev94MlhIESXY0dLCA2
	i4CqxPozt8FW8Aq4SFx/PI21i5EDaJ2CxJxJNiBhTgFXifk7PrOB2EJAJbc6XzGCzJQQOMYu
	sW/yLag5AhLfJh9igeiVldh0AOpqSYmDK26wTGAUXsDIsIpRNLUguaA4Kb3IVK84Mbe4NC9d
	Lzk/dxMjMEJO/3s2cQfj/QPWhxgFOBiVeHg9HomHCLEmlhVX5h5iNAXaMJFZSjQ5HxiHeSXx
	hsZmRhamJqbGRuaWZkrivDrSP4OFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MOos8wz/WX02
	//Fige/+6wpdvgScOBiYxJ10PmRvgKaJxZEV/zVvLJ6mwcnf51f/yMfn7v+FF39MC2n2TWGb
	bxpt2rHIWK2oOMTtl8Xk2Ft7s3h57Lnzm9MCmTPfrpqf9PbUEkYL9T9+b6oZerYESi0+oHXv
	Vq/kV+bG7Fn1l7WfKlw5uEBSQ4mlOCPRUIu5qDgRAM90rsOLAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t9jQd1Xf8RDDC684LF4eUjT4vqX56wW
	84+cY7VoXryezeLVkR9MFg+aVjFZLJk8n9Vi3pF3LBaXd81hs5hxfh+TxaJt/5kduD1mN1xk
	8dg56y67x6ZVnWwe++euYfdY8uYQq0ffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2Tmpdsq
	eQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHamkUJaYUwoUCkgsLlbSt8M0ITTETdcC
	pjFC1zckCK7HyAANJKxhzDg0rY25oJm/4veS2AbGjTxdjJwcEgImEhc/rmGHsMUkLtxbz9bF
	yMUhJDCdUeLs5XksEE4/k8S9hldMIFVsAmYSBxetBusQEYiT+HC5nx2kiFlgP6PE69f7wRLC
	QImuxg4WEJtFQFVi/ZnbzCA2r4CLxPXH01i7GDmA1ilIzJlkAxLmFHCVmL/jMxuILQRUcqvz
	FeMERt4FjAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYLj75n0DsZVDRaHGAU4GJV4eD0e
	iYcIsSaWFVfmHmKU4GBWEuF98AkoxJuSWFmVWpQfX1Sak1p8iNEU6KiJzFKiyfnA1JBXEm9o
	bGJuamxqaWJhYmapJM57sNU6UEggPbEkNTs1tSC1CKaPiYNTqoFxwbSGTSmXA9on+gS8Zcxj
	eea3xau7Ycvdh0zTlF8xK+spBBeft7omL7DBqbq95krOub+xPge3bVNJCQ1n3bPecDqHjcHO
	V+Fz1oavvRh1QbrchfWoXm2Vhoz51MdpVRLc4u+2LBf9uJLjqu3sDwe3vmYsOiyt1XhVR+Xz
	lLqDDLLZQZmN/zSVWIozEg21mIuKEwEdz19S1QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the DT bindings for ADC in exynos-adc.txt with the
syscon phandle to the ADC nodes.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: devicetree@vger.kernel.org
---
 .../devicetree/bindings/arm/samsung/exynos-adc.txt |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
index 709efaa..c368210 100644
--- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
+++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
@@ -43,13 +43,16 @@ Required properties:
 				   compatible ADC block)
 - vdd-supply		VDD input supply.
 
+- samsung,syscon-phandle Contains the PMU system controller node
+			(To access the ADC_PHY register on Exynos5250/5420/5800/3250)
+
 Note: child nodes can be added for auto probing from device tree.
 
 Example: adding device info in dtsi file
 
 adc: adc@12D10000 {
 	compatible = "samsung,exynos-adc-v1";
-	reg = <0x12D10000 0x100>, <0x10040718 0x4>;
+	reg = <0x12D10000 0x100>;
 	interrupts = <0 106 0>;
 	#io-channel-cells = <1>;
 	io-channel-ranges;
@@ -58,13 +61,14 @@ adc: adc@12D10000 {
 	clock-names = "adc";
 
 	vdd-supply = <&buck5_reg>;
+	samsung,syscon-phandle = <&pmu_system_controller>;
 };
 
 Example: adding device info in dtsi file for Exynos3250 with additional sclk
 
 adc: adc@126C0000 {
 	compatible = "samsung,exynos3250-adc", "samsung,exynos-adc-v2;
-	reg = <0x126C0000 0x100>, <0x10020718 0x4>;
+	reg = <0x126C0000 0x100>;
 	interrupts = <0 137 0>;
 	#io-channel-cells = <1>;
 	io-channel-ranges;
@@ -73,6 +77,7 @@ adc: adc@126C0000 {
 	clock-names = "adc", "sclk";
 
 	vdd-supply = <&buck5_reg>;
+	samsung,syscon-phandle = <&pmu_system_controller>;
 };
 
 Example: Adding child nodes in dts file
-- 
1.7.9.5

