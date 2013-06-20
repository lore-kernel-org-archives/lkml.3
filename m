Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab3FTIZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:25:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:38012 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab3FTIZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:25:15 -0400
X-AuditID: cbfee68f-b7f436d000000f81-06-51c2bc698906
From: Jingoo Han <jg1.han@samsung.com>
To: "'Tomasz Figa'" <tomasz.figa@gmail.com>
Cc: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>
References: <00c201ce6d85$83b072a0$8b1157e0$@samsung.com>
 <3250954.dVh4O1LchK@flatron>
In-reply-to: <3250954.dVh4O1LchK@flatron>
Subject: RE: [PATCH V6 3/3] ARM: dts: Add pcie controller node for Samsung
 EXYNOS5440 SoC
Date: Thu, 20 Jun 2013 17:25:12 +0900
Message-id: <00c501ce6d8f$af1bf900$0d53eb00$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKCeiqjUMDl9MJHZtKATS766DS40AJuOCeel8K29xA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsVy+t8zY93MPYcCDQ4cE7No/r+d1eLvpGPs
	FkuaMiwOzH7IavHqzEY2i8sLL7FafL9hatG74CqbxabH11gtLu+aw2Zxdt5xNosZ5/cxWaxo
	2sposfjicmaL3SuXsFgcm7GE0eLpgyYmi1W7/jA6CHmsmbeG0eP3r0mMHn1TrrJ5PNl0kdFj
	56y77B4LNpV63Lm2h81j85J6j/MzFjJ6fN/RC1S1ZRWjx8+XOh6fN8kF8EZx2aSk5mSWpRbp
	2yVwZbQ2v2UveKBTcXT1BcYGxglKXYycHBICJhJTbl5hg7DFJC7cWw9kc3EICSxjlFg67SVr
	FyMHWNHzL9YgNUIC0xkl5s8qgqj5xShxe+cGJpAEm4CaxJcvh9lBbBEBTYljT56xgxQxCzxm
	lXjS95kZojtCovPDTjaQoZxART9vOoOEhQWiJRY9XQQ2h0VAVeLB3A9g5bwClhIT/u9hgrAF
	JX5MvscCYjMLaEms33mcCcKWl9i85i0zxAMKEjvOvmaEuMFK4vb9BjaIGhGJfS/eMYLcIyHw
	gUNi1dOdrBDLBCS+TT7EAvGkrMSmA1BzJCUOrrjBMoFRYhaS1bOQrJ6FZPUsJCsWMLKsYhRN
	LUguKE5KLzLWK07MLS7NS9dLzs/dxAhJOP07GO8esD7EmAy0fiKzlGhyPjBh5ZXEGxqbGVmY
	mpgaG5lbmpEmrCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBkUfR70LLwRohG/mp
	S2Wd9r7V+xrH+PjAbUu9s+umbtfIFDxn79AiN8MsPWHyr8nc+T9/8XjNfP3SZca+DwtqJZnZ
	pmZsXPD+1X8xzfsfPIu3cLpvShGu/vb3zysWZc5NqzREqyVkJeO+ZpWv9o9ikdSPVs+oNlox
	aevH+cv2cfxu5vjGY7n9nhJLcUaioRZzUXEiAO7UGaFOAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBJsWRmVeSWpSXmKPExsVy+t9jQd2MPYcCDZ622Vg0/9/OavF30jF2
	iyVNGRYHZj9ktXh1ZiObxeWFl1gtvt8wtehdcJXNYtPja6wWl3fNYbM4O+84m8WM8/uYLFY0
	bWW0WHxxObPF7pVLWCyOzVjCaPH0QROTxapdfxgdhDzWzFvD6PH71yRGj74pV9k8nmy6yOix
	c9Zddo8Fm0o97lzbw+axeUm9x/kZCxk9vu/oBarasorR4+dLHY/Pm+QCeKMaGG0yUhNTUosU
	UvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgD5UUihLzCkFCgUkFhcr
	6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWa0Nr9lL3igU3F09QXGBsYJSl2MHBwSAiYSz79Y
	dzFyApliEhfurWcDsYUEpjNKzJ9V1MXIBWT/YpS4vXMDE0iCTUBN4suXw+wgtoiApsSxJ8/Y
	QYqYBR6zSjzp+8wM0R0h0flhJxvIAk6gop83nUHCwgLREoueLgKbwyKgKvFg7gewcl4BS4kJ
	//cwQdiCEj8m32MBsZkFtCTW7zzOBGHLS2xe85YZ4lAFiR1nXzNC3GAlcft+AxtEjYjEvhfv
	GCcwCs1CMmoWklGzkIyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgdPZMagfj
	ygaLQ4wCHIxKPLwalw8GCrEmlhVX5h5ilOBgVhLhTZ1zKFCINyWxsiq1KD++qDQntfgQYzLQ
	pxOZpUST84GpNq8k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUa
	GNUC5971lX+8telBpPH7MN8Y9StqRfKt4gucSthZ0r2esoXwdr3IvHvt54+9M3i+p+mVe9nG
	X9ioNXNWtf2GILstPD+0ZbWX/Y7IZzvNmNbzYvOikgb5dd8FpzE/WzJpDtP/LU+TVtg/2yIo
	a77qFkeL43QON9+Nny64qL56l7t7Xeqd2C/M75VYijMSDbWYi4oTAQ4ykwarAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 20, 2013 5:04 PM, Tomasz Figa wrote:
> 
> Hi Jingoo,
> 
> On Thursday 20 of June 2013 16:12:24 Jingoo Han wrote:
> > Exynos5440 has two PCIe controllers which can be used as root complex
> > for PCIe interface.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> >  arch/arm/boot/dts/exynos5440-ssdk5440.dts |    8 ++++++
> >  arch/arm/boot/dts/exynos5440.dtsi         |   40
> > ++++++++++++++++++++++++++++- 2 files changed, 47 insertions(+), 1
> > deletion(-)
> >
> > diff --git a/arch/arm/boot/dts/exynos5440-ssdk5440.dts
> > b/arch/arm/boot/dts/exynos5440-ssdk5440.dts index f32cd77..3d93804
> > 100644
> > --- a/arch/arm/boot/dts/exynos5440-ssdk5440.dts
> > +++ b/arch/arm/boot/dts/exynos5440-ssdk5440.dts
> > @@ -65,4 +65,12 @@
> >  			clock-frequency = <50000000>;
> >  		};
> >  	};
> > +
> > +	pcie0@290000 {
> > +		reset-gpio = <&pin_ctrl 5 0>;
> > +	};
> > +
> > +	pcie1@2a0000 {
> > +		reset-gpio = <&pin_ctrl 22 0>;
> > +	};
> >  };
> > diff --git a/arch/arm/boot/dts/exynos5440.dtsi
> > b/arch/arm/boot/dts/exynos5440.dtsi index 03d40c0..6295eda 100644
> > --- a/arch/arm/boot/dts/exynos5440.dtsi
> > +++ b/arch/arm/boot/dts/exynos5440.dtsi
> > @@ -126,7 +126,7 @@
> >  		clock-names = "spi", "spi_busclk0";
> >  	};
> >
> > -	pinctrl {
> > +	pin_ctrl: pinctrl {
> >  		compatible = "samsung,exynos5440-pinctrl";
> >  		reg = <0xE0000 0x1000>;
> >  		interrupts = <0 37 0>, <0 38 0>, <0 39 0>, <0 40 0>,
> > @@ -230,4 +230,42 @@
> >  		clocks = <&clock 24>;
> >  		clock-names = "usbhost";
> >  	};
> 
> I think this patch should be split into two:
>  - patch adding just generlic PCIe nodes for Exynos5440,
>  - patch adding label to the pinctrl node (which is a prerequisite) and
> board-specific properties of PCIe nodes.

Do you mean the following?

1. patch adding just generlic PCIe nodes for Exynos5440
    [PATCH] ARM: dts: Add pcie controller node for Samsung EXYNOS5440 SoC

arch/arm/boot/dts/exynos5440.dtsi
+
+	pcie@290000 {
+		compatible = "samsung,exynos5440-pcie";
+		reg = <0x290000 0x1000
+			0x270000 0x1000
+			0x271000 0x40>;
+		interrupts = <0 20 0>, <0 21 0>, <0 22 0>;
+		clocks = <&clock 28>, <&clock 27>;
+		clock-names = "pcie", "pcie_bus";
+		#address-cells = <3>;
+		#size-cells = <2>;
+		device_type = "pci";
+		ranges = <0x00000800 0 0x40000000 0x40000000 0 0x00001000   /* configuration space */
+			  0x81000000 0 0	  0x40001000 0 0x00010000   /* downstream I/O */
+			  0x82000000 0 0x40011000 0x40011000 0 0x1ffef000>; /* non-prefetchable memory */
+		#interrupt-cells = <1>;
+		interrupt-map-mask = <0 0 0 0>;
+		interrupt-map = <0x0 0 &gic 53>;
+	};
+
+	pcie@2a0000 {
+		compatible = "samsung,exynos5440-pcie";
+		reg = <0x2a0000 0x1000
+			0x272000 0x1000
+			0x271040 0x40>;
+		interrupts = <0 23 0>, <0 24 0>, <0 25 0>;
+		clocks = <&clock 29>, <&clock 27>;
+		clock-names = "pcie", "pcie_bus";
+		#address-cells = <3>;
+		#size-cells = <2>;
+		device_type = "pci";
+		ranges = <0x00000800 0 0x60000000 0x60000000 0 0x00001000   /* configuration space */
+			  0x81000000 0 0	  0x60001000 0 0x00010000   /* downstream I/O */
+			  0x82000000 0 0x60011000 0x60011000 0 0x1ffef000>; /* non-prefetchable memory */
+		#interrupt-cells = <1>;
+		interrupt-map-mask = <0 0 0 0>;
+		interrupt-map = <0x0 0 &gic 56>;
+	};



2. patch adding label to the pinctrl node (which is a prerequisite) and
    board-specific properties of PCIe nodes.
   [PATCH] ARM: dts: Add pcie controller node for exynos5440-ssdk5440

arch/arm/boot/dts/exynos5440-ssdk5440.dts
+
+	pcie0@290000 {
+		reset-gpio = <&pin_ctrl 5 0>;
+	};
+
+	pcie1@2a0000 {
+		reset-gpio = <&pin_ctrl 22 0>;
+	};

arch/arm/boot/dts/exynos5440.dtsi
-	pinctrl {
+	pin_ctrl: pinctrl {



> 
> > +
> > +	pcie0@290000 {
> 
> Node naming looks incorrect here. The name should be as generic as
> possible, without any hardware-specific IDs, e.g. pcie, not pcie0. The
> @290000 suffix is enough to make the node unique.

I see. You are right.
I will fix it.


Best regards,
Jingoo Han

> 
> > +		compatible = "samsung,exynos5440-pcie";
> > +		reg = <0x290000 0x1000
> > +			0x270000 0x1000
> > +			0x271000 0x40>;
> > +		interrupts = <0 20 0>, <0 21 0>, <0 22 0>;
> > +		clocks = <&clock 28>, <&clock 27>;
> > +		clock-names = "pcie", "pcie_bus";
> > +		#address-cells = <3>;
> > +		#size-cells = <2>;
> > +		device_type = "pci";
> > +		ranges = <0x00000800 0 0x40000000 0x40000000 0 0x00001000
> /*
> > configuration space */ +			  0x81000000 0 0
> 0x40001000 0 0x00010000
> > /* downstream I/O */ +			  0x82000000 0 0x40011000
> 0x40011000 0
> > 0x1ffef000>; /* non-prefetchable memory */ +		#interrupt-cells =
> <1>;
> > +		interrupt-map-mask = <0 0 0 0>;
> > +		interrupt-map = <0x0 0 &gic 53>;
> > +	};
> > +
> > +	pcie1@2a0000 {
> 
> Same here.
> 
> Best regards,
> Tomasz
> 
> > +		compatible = "samsung,exynos5440-pcie";
> > +		reg = <0x2a0000 0x1000
> > +			0x272000 0x1000
> > +			0x271040 0x40>;
> > +		interrupts = <0 23 0>, <0 24 0>, <0 25 0>;
> > +		clocks = <&clock 29>, <&clock 27>;
> > +		clock-names = "pcie", "pcie_bus";
> > +		#address-cells = <3>;
> > +		#size-cells = <2>;
> > +		device_type = "pci";
> > +		ranges = <0x00000800 0 0x60000000 0x60000000 0 0x00001000
> /*
> > configuration space */ +			  0x81000000 0 0
> 0x60001000 0 0x00010000
> > /* downstream I/O */ +			  0x82000000 0 0x60011000
> 0x60011000 0
> > 0x1ffef000>; /* non-prefetchable memory */ +		#interrupt-cells =
> <1>;
> > +		interrupt-map-mask = <0 0 0 0>;
> > +		interrupt-map = <0x0 0 &gic 56>;
> > +	};
> >  };

