Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947262Ab3BHWf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 17:35:28 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:58949 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760328Ab3BHWfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 17:35:25 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-90-51157dab704c
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        linux-samsung-soc@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, grant.likely@secretlab.ca,
        dianders@chromium.org, jg1.han@samsung.com,
        Thomas Abraham <thomas.ab@samsung.com>
References: <CAFp+6iFgaT9D2hR0pX34jo2g+GHftmA0Mw3y96-oKe0KakZOxA@mail.gmail.com>
 <1358315143-16620-1-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1358315143-16620-1-git-send-email-gautam.vivek@samsung.com>
Subject: RE: [PATCH v5 1/4] ARM: Exynos5250: Enabling ehci-s5p driver
Date: Fri, 08 Feb 2013 14:35:06 -0800
Message-id: <1a5501ce064c$8d2ed1a0$a78c74e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKJ3PkCUeMen/p9rsbqXSC8/IESzQEV7/7jlvAsP2A=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t8zQ93VtaKBBht+y1hc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjFZZOSmpNZllqkb5fAlXF+3nGWgi/SFdOuzWFuYOwQ62Lk5JAQMJG4
	0LqIGcIWk7hwbz1bFyMXh5DAMkaJu4f+McMUnT89lwkisYhR4tbuvywQzl9Gid8Xz7GBVLEJ
	aEgcfv+MHcQWEQiQ+HrrBSNIEbPAZUaJk5/fM0N0TGSUOLHqI1A7BwengKfEz22GIA3CAq4S
	jZfnMYGEWQRUJZZ2soCEeQUsJZbvamaGsAUlfky+BxZnFtCSWL/zOBOELS+xec1bqEsVJHac
	fc0IcYOVxPFVTxkhasQlJj14yA5ygoTANnaJrpeHwBIsAgIS3yYfAjtHQkBWYtMBqDmSEgdX
	3GCZwCgxC8nqWUhWz0KyehaSFQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525ihESc1A7G
	lQ0WhxgFOBiVeHgXiIsGCrEmlhVX5h5ilOBgVhLh3WYLFOJNSaysSi3Kjy8qzUktPsSYDHTs
	RGYp0eR8YDLIK4k3NDY2MTMxNTG3NDU3JU1YSZyX8dSTACGB9MSS1OzU1ILUIpgtTBycUg2M
	Wj+cbRSmvzdb45jMzr14NkNjbBnTJeGbD5LPrl/h8mdZ+6QYFx7fqm9LmWOztm2aP0dwhpV0
	w28vufk59/6KFZ+QMnkr9SjyOvPXTxP6jFVDc5grTjc0nL+qoMfzr9Yo7pdnas6WFYtt9eav
	z3CoEa/v+2689c8TY+V7msdrt/qaRO94u4VHiaU4I9FQi7moOBEAstP/cvwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t9jAd3VtaKBBvN6xCwu75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIxqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xN
	tVVy8QnQdcvMAZqvpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8w4P+84
	S8EX6Ypp1+YwNzB2iHUxcnJICJhInD89lwnCFpO4cG89WxcjF4eQwCJGiVu7/7JAOH8ZJX5f
	PMcGUsUmoCFx+P0zdhBbRCBA4uutF4wgRcwClxklTn5+zwzRMZFR4sSqj0DtHBycAp4SP7cZ
	gjQIC7hKNF6exwQSZhFQlVjayQIS5hWwlFi+q5kZwhaU+DH5HlicWUBLYv3O40wQtrzE5jVv
	mSEuVZDYcfY1I8QNVhLHVz1lhKgRl5j04CH7BEahWUhGzUIyahaSUbOQtCxgZFnFKJpakFxQ
	nJSea6hXnJhbXJqXrpecn7uJERzPz6R2MK5ssDjEKMDBqMTDu0BcNFCINbGsuDL3EKMEB7OS
	CO82W6AQb0piZVVqUX58UWlOavEhxmSgRycyS4km5wNTTV5JvKGxiZmRpZGZhZGJuTlpwkri
	vIynngQICaQnlqRmp6YWpBbBbGHi4JRqYFRZe7/g1aXPMxNuf9HO923PX6A4bVb2mQcyx0od
	X9cUedinZbhPCpliFBk92ali3WEBpQs7v+blPpP6fUxMmLFhz4JD/gYGGbfn/osv/RB5y2/y
	3WaNOz0X1HxWNaXZ+DK/fdS0tXtNc//tZVG2Qdx+E29ZvclUm2Z/9MTGpVtZJhdZ7+P4VKrE
	UpyRaKjFXFScCADqBaltKwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Gautam wrote:
> 
> Adding EHCI device tree node for Exynos5250 along with
> the device base adress and gpio line for vbus.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> ---
> 
> Changes from v4:
>  - Added gpio line for VBUS of USB2.0 on snow board.
> 
>  .../devicetree/bindings/usb/exynos-usb.txt         |   25
> ++++++++++++++++++++
>  arch/arm/boot/dts/exynos5250-smdk5250.dts          |    4 +++
>  arch/arm/boot/dts/exynos5250-snow.dts              |    4 +++
>  arch/arm/boot/dts/exynos5250.dtsi                  |    6 ++++
>  4 files changed, 39 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/usb/exynos-
> usb.txt
> 
> diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt
> b/Documentation/devicetree/bindings/usb/exynos-usb.txt
> new file mode 100644
> index 0000000..e8bbb47
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
> @@ -0,0 +1,25 @@
> +Samsung Exynos SoC USB controller
> +
> +The USB devices interface with USB controllers on Exynos SOCs.
> +The device node has following properties.
> +
> +EHCI
> +Required properties:
> + - compatible: should be "samsung,exynos4210-ehci" for USB 2.0
> +   EHCI controller in host mode.
> + - reg: physical base address of the controller and length of memory
> mapped
> +   region.
> + - interrupts: interrupt number to the cpu.
> +
> +Optional properties:
> + - samsung,vbus-gpio:  if present, specifies the GPIO that
> +   needs to be pulled up for the bus to be powered.
> +
> +Example:
> +
> +	usb@12110000 {
> +		compatible = "samsung,exynos4210-ehci";
> +		reg = <0x12110000 0x100>;
> +		interrupts = <0 71 0>;
> +		samsung,vbus-gpio = <&gpx2 6 1 3 3>;
> +	};
> diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts
> b/arch/arm/boot/dts/exynos5250-smdk5250.dts
> index 942d576..7363e14 100644
> --- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
> +++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
> @@ -204,4 +204,8 @@
>  		samsung,mfc-r = <0x43000000 0x800000>;
>  		samsung,mfc-l = <0x51000000 0x800000>;
>  	};
> +
> +	usb@12110000 {
> +		samsung,vbus-gpio = <&gpx2 6 1 3 3>;
> +	};
>  };
> diff --git a/arch/arm/boot/dts/exynos5250-snow.dts
> b/arch/arm/boot/dts/exynos5250-snow.dts
> index 17dd951..47b6b84 100644
> --- a/arch/arm/boot/dts/exynos5250-snow.dts
> +++ b/arch/arm/boot/dts/exynos5250-snow.dts
> @@ -40,4 +40,8 @@
>  				<&gpc4 5 2 3 0>, <&gpc4 6 2 3 0>;
>  		};
>  	};
> +
> +	usb@12110000 {
> +		samsung,vbus-gpio = <&gpx1 1 1 3 3>;
> +	};
>  };
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi
> b/arch/arm/boot/dts/exynos5250.dtsi
> index 30485de..2cbe53e 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -275,6 +275,12 @@
>  		#size-cells = <0>;
>  	};
> 
> +	usb@12110000 {
> +		compatible = "samsung,exynos4210-ehci";
> +		reg = <0x12110000 0x100>;
> +		interrupts = <0 71 0>;
> +	};
> +
>  	amba {
>  		#address-cells = <1>;
>  		#size-cells = <1>;
> --
> 1.7.6.5

Looks good to me and applied this and "[PATCH v3 2/4] ARM: Exynos5250:
Enabling ohci-exynos driver" in Samsung tree.

Note, I think, you need to implement to use pinctrl for this instead of old
gpio bindings next time, probably after release v3.9-rc1.

Ah, one more, please use subject lines appropriate like others, "ARM: dts:
....".

Thanks.

- Kukjin

