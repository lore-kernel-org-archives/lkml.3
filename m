Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab3E0MqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:46:22 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34352 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363Ab3E0MqU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:46:20 -0400
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: "tony@atomide.com" <tony@atomide.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: RE: [PATCH] ARM: dts: omap2plus: remove interrupt-parent property
Thread-Topic: [PATCH] ARM: dts: omap2plus: remove interrupt-parent property
Thread-Index: AQHOHj8sT/H/Rx7soEuCgw71s8VNApjSVYhwgEceKCA=
Date: Mon, 27 May 2013 12:45:35 +0000
Message-ID: <A4887BF146CD57468F700B415D2F470159537D@DBDE04.ent.ti.com>
References: <1362996002-15552-1-git-send-email-manishv.b@ti.com>
 <A4887BF146CD57468F700B415D2F470158738C@DBDE01.ent.ti.com>
In-Reply-To: <A4887BF146CD57468F700B415D2F470158738C@DBDE01.ent.ti.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

Are there any review comments on this patch?
Could you please accept this patch if there are not any review comments?

Thanks and Regards
Manish Badarkhe

-----Original Message-----
From: Vishwanathrao Badarkhe, Manish 
Sent: Friday, April 12, 2013 12:20 PM
To: Vishwanathrao Badarkhe, Manish; devicetree-discuss@lists.ozlabs.org; linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; linux-omap@vger.kernel.org
Cc: tony@atomide.com; Cousson, Benoit; linux@arm.linux.org.uk
Subject: RE: [PATCH] ARM: dts: omap2plus: remove interrupt-parent property

Hi Benoit,
Are there any review comments on this patch? 
Could you please accept this patch if there are not any review comments?

Thanks
Manish Badarkhe

-----Original Message-----
From: Vishwanathrao Badarkhe, Manish 
Sent: Monday, March 11, 2013 3:30 PM
To: devicetree-discuss@lists.ozlabs.org; linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; linux-omap@vger.kernel.org
Cc: tony@atomide.com; Cousson, Benoit; linux@arm.linux.org.uk; Vishwanathrao Badarkhe, Manish
Subject: [PATCH] ARM: dts: omap2plus: remove interrupt-parent property

Removed interrupt-parent property from dts file as it is already
with root node in dtsi file.

Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
---
:100644 100644 f624dc8... 36e839a... M	arch/arm/boot/dts/omap3-beagle.dts
:100644 100644 e8ba1c2... a5375fd... M	arch/arm/boot/dts/omap3-evm.dts
:100644 100644 4122efe... 389c9c7... M	arch/arm/boot/dts/omap4-panda.dts
:100644 100644 43e5258... cdf5dfd... M	arch/arm/boot/dts/omap4-sdp.dts
:100644 100644 6601e6a... 1d4a9d4... M	arch/arm/boot/dts/omap4-var-som.dts
 arch/arm/boot/dts/omap3-beagle.dts  |    1 -
 arch/arm/boot/dts/omap3-evm.dts     |    1 -
 arch/arm/boot/dts/omap4-panda.dts   |    2 --
 arch/arm/boot/dts/omap4-sdp.dts     |    2 --
 arch/arm/boot/dts/omap4-var-som.dts |    1 -
 5 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-beagle.dts b/arch/arm/boot/dts/omap3-beagle.dts
index f624dc8..36e839a 100644
--- a/arch/arm/boot/dts/omap3-beagle.dts
+++ b/arch/arm/boot/dts/omap3-beagle.dts
@@ -46,7 +46,6 @@
 	twl: twl@48 {
 		reg = <0x48>;
 		interrupts = <7>; /* SYS_NIRQ cascaded to intc */
-		interrupt-parent = <&intc>;
 	};
 };
 
diff --git a/arch/arm/boot/dts/omap3-evm.dts b/arch/arm/boot/dts/omap3-evm.dts
index e8ba1c2..a5375fd 100644
--- a/arch/arm/boot/dts/omap3-evm.dts
+++ b/arch/arm/boot/dts/omap3-evm.dts
@@ -34,7 +34,6 @@
 	twl: twl@48 {
 		reg = <0x48>;
 		interrupts = <7>; /* SYS_NIRQ cascaded to intc */
-		interrupt-parent = <&intc>;
 	};
 };
 
diff --git a/arch/arm/boot/dts/omap4-panda.dts b/arch/arm/boot/dts/omap4-panda.dts
index 4122efe..389c9c7 100644
--- a/arch/arm/boot/dts/omap4-panda.dts
+++ b/arch/arm/boot/dts/omap4-panda.dts
@@ -119,7 +119,6 @@
 		reg = <0x48>;
 		/* SPI = 0, IRQ# = 7, 4 = active high level-sensitive */
 		interrupts = <0 7 4>; /* IRQ_SYS_1N cascaded to gic */
-		interrupt-parent = <&gic>;
 	};
 
 	twl6040: twl@4b {
@@ -127,7 +126,6 @@
 		reg = <0x4b>;
 		/* SPI = 0, IRQ# = 119, 4 = active high level-sensitive */
 		interrupts = <0 119 4>; /* IRQ_SYS_2N cascaded to gic */
-		interrupt-parent = <&gic>;
 		ti,audpwron-gpio = <&gpio4 31 0>;  /* gpio line 127 */
 
 		vio-supply = <&v1v8>;
diff --git a/arch/arm/boot/dts/omap4-sdp.dts b/arch/arm/boot/dts/omap4-sdp.dts
index 43e5258..cdf5dfd 100644
--- a/arch/arm/boot/dts/omap4-sdp.dts
+++ b/arch/arm/boot/dts/omap4-sdp.dts
@@ -221,7 +221,6 @@
 		reg = <0x48>;
 		/* SPI = 0, IRQ# = 7, 4 = active high level-sensitive */
 		interrupts = <0 7 4>; /* IRQ_SYS_1N cascaded to gic */
-		interrupt-parent = <&gic>;
 	};
 
 	twl6040: twl@4b {
@@ -229,7 +228,6 @@
 		reg = <0x4b>;
 		/* SPI = 0, IRQ# = 119, 4 = active high level-sensitive */
 		interrupts = <0 119 4>; /* IRQ_SYS_2N cascaded to gic */
-		interrupt-parent = <&gic>;
 		ti,audpwron-gpio = <&gpio4 31 0>;  /* gpio line 127 */
 
 		vio-supply = <&v1v8>;
diff --git a/arch/arm/boot/dts/omap4-var-som.dts b/arch/arm/boot/dts/omap4-var-som.dts
index 6601e6a..1d4a9d4 100644
--- a/arch/arm/boot/dts/omap4-var-som.dts
+++ b/arch/arm/boot/dts/omap4-var-som.dts
@@ -35,7 +35,6 @@
 		reg = <0x48>;
 		/* SPI = 0, IRQ# = 7, 4 = active high level-sensitive */
 		interrupts = <0 7 4>; /* IRQ_SYS_1N cascaded to gic */
-		interrupt-parent = <&gic>;
 	};
 };
 
-- 
1.7.4.1

