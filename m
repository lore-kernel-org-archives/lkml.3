Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbaESL0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 07:26:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:28880 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbaESL0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 07:26:04 -0400
X-AuditID: cbfee68f-b7fef6d000003970-c1-5379ea4930bc
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        robh+dt@kernel.org, gregkh@linuxfoundation.org, t.figa@samsung.com,
        balbi@ti.com, kishon@ti.com, jg1.han@samsung.com
References: <1400076070-12456-1-git-send-email-gautam.vivek@samsung.com>
 <1400076070-12456-6-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1400076070-12456-6-git-send-email-gautam.vivek@samsung.com>
Subject: RE: [PATCH v6 5/8] ARM: dts: exynos5250-snow: Add Vbus regulator for
 USB 3.0
Date: Mon, 19 May 2014 20:26:01 +0900
Message-id: <03a701cf7355$1d485dd0$57d91970$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIXm3ShKIn7NnMD/ynVWft4k6zsdgM2h7a9mp2+YIA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+Zsa7nq8pgg6+vbCwO3q+3mH/kHKtF
	25WD7BbNi9ezWVxeeInV4sLTHjaLTY+vsVpc3jWHzWLG+X1MFouWtTJbtO49wm6xfsZrFgce
	j02rOtk89s9dw+6xeUm9R9+WVYwex29sZ/L4vEkugC2KyyYlNSezLLVI3y6BK+PQq362gmbu
	irY7nSwNjAc5uhg5OSQETCSWPNjGCmGLSVy4t56ti5GLQ0hgGaPEhMWL2LsYOcCKWr/YQcSn
	M0os23mCHcL5yyhx9/hdRpBuNgENicPvn4ElRAS6GSXa9y5iBnGYBQ4wSvzbc5QFoqWdUWLO
	lB/sIC2cAp4SPzadBLOFBcIlLhx6CGazCKhKPD7WBjaWV8BSYvum78wQtqDEj8n3WEBsZgEt
	ifU7jzNB2PISm9e8ZYZ4QkFix9nXYL0iAlYSvRteskLUiEjse/GOEeQICYGZHBKHj7xmgVgm
	IPFt8iEWiEdlJTYdgJojKXFwxQ2WCYwSs5CsnoVk9Swkq2chWbGAkWUVo2hqQXJBcVJ6kbFe
	cWJucWleul5yfu4mRkj09+9gvHvA+hBjMtD6icxSosn5wOSRVxJvaGxmZGFqYmpsZG5pRpqw
	kjjv/YdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYw26obw/qi3rP4fcyWG1ZaeCTNVXd
	DakTGzLML76XP/vp6U/JzTmZacF582Yc6a/es1no39q5hb0BK+sezjVVV17Fe6jj+hfvs4L1
	fUwiWkv+iJ7YEt0rEcu/pHtde8nSZhae6VonZlzQW+X1db30ApPkJ4GZMVKsUYurIk9tlTx/
	ekukh8JNJZbijERDLeai4kQAo3zNmhQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHKsWRmVeSWpSXmKPExsVy+t9jQV3PV5XBBmffm1scvF9vMf/IOVaL
	tisH2S2aF69ns7i88BKrxYWnPWwWmx5fY7W4vGsOm8WM8/uYLBYta2W2aN17hN1i/YzXLA48
	HptWdbJ57J+7ht1j85J6j74tqxg9jt/YzuTxeZNcAFtUA6NNRmpiSmqRQmpecn5KZl66rZJ3
	cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtCNSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAa
	I3R9Q4LgeowM0EDCOsaMQ6/62QqauSva7nSyNDAe5Ohi5OCQEDCRaP1i18XICWSKSVy4t56t
	i5GLQ0hgOqPEsp0n2CGcv4wSd4/fZQSpYhPQkDj8/hlYQkSgm1Gife8iZhCHWeAAo8S/PUdZ
	IFraGSXmTPnBDtLCKeAp8WPTSTBbWCBc4sKhh2A2i4CqxONjbWBjeQUsJbZv+s4MYQtK/Jh8
	jwXEZhbQkli/8zgThC0vsXnNW2aIYxUkdpx9DdYrImAl0bvhJStEjYjEvhfvGCcwCs1CMmoW
	klGzkIyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzg1PJMagfjygaLQ4wCHIxK
	PLwTwiuDhVgTy4orcw8xSnAwK4nw8jwHCvGmJFZWpRblxxeV5qQWH2JMBvp0IrOUaHI+MO3l
	lcQbGpuYGVkamVkYmZibkyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVAPjmZrgs7uj7Tbl
	p5zxbWEw3rheQenTjcfJzffcbk2vXyhater61meR73i8ipLDXX5lxSw4mWAadivHt608s09X
	RVmY/c3L19t6A/VOHr609fW6VwvP/JnmJPvj4eJH2/TObYnyv/rn8I9V7xo+X0j1Mmh6WC5/
	fJnJ+Rfvzr5dLsArt1/cfnaMvxJLcUaioRZzUXEiAOT2gtJxAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Gautam wrote:
> 
> Add required fixed-regulator for VBUS supply for USB 3.0
> controller phy.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  arch/arm/boot/dts/exynos5250-snow.dts |   22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos5250-snow.dts
> b/arch/arm/boot/dts/exynos5250-snow.dts
> index 1ce1088..fd9b3b3 100644
> --- a/arch/arm/boot/dts/exynos5250-snow.dts
> +++ b/arch/arm/boot/dts/exynos5250-snow.dts
> @@ -37,6 +37,13 @@
>  		sd3_bus4: sd3-bus-width4 {
>  			samsung,pin-drv = <0>;
>  		};
> +
> +		usb3_vbus_en: usb3-vbus-en {
> +			samsung,pins = "gpx2-7";
> +			samsung,pin-function = <1>;
> +			samsung,pin-pud = <0>;
> +			samsung,pin-drv = <0>;
> +		};
>  	};
> 
>  	gpio-keys {
> @@ -196,6 +203,21 @@
>  		};
>  	};
> 
> +	usb3_vbus_reg: regulator-usb3 {
> +		compatible = "regulator-fixed";
> +		regulator-name = "P5.0V_USB3CON";
> +		regulator-min-microvolt = <5000000>;
> +		regulator-max-microvolt = <5000000>;
> +		gpio = <&gpx2 7 0>;
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&usb3_vbus_en>;
> +		enable-active-high;
> +	};
> +
> +	phy@12100000 {
> +		vbus-supply = <&usb3_vbus_reg>;
> +	};
> +
>  	usb@12110000 {
>  		samsung,vbus-gpio = <&gpx1 1 0>;
>  	};
> --
> 1.7.10.4

Looks OK to me and applied 5 to 8 as well.

Thanks,
Kukjin

