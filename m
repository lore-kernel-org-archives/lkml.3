Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbbAWGh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 01:37:56 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:15265 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbbAWGhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 01:37:53 -0500
X-AuditID: cbfee68f-f791c6d000004834-a0-54c1ec3ffe6c
From: Kukjin Kim <kgene@kernel.org>
To: "'Kevin Hilman'" <khilman@kernel.org>, linux-samsung-soc@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        "'Javier Martinez Canillas'" <javier.martinez@collabora.co.uk>,
        "'Sjoerd Simons'" <sjoerd.simons@collabora.co.uk>,
        "'Kevin Hilman'" <khilman@linaro.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Pawel Moll'" <pawel.moll@arm.com>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Ian Campbell'" <ijc+devicetree@hellion.org.uk>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Kukjin Kim'" <kgene@kernel.org>,
        "'open list:OPEN FIRMWARE AND...'" <devicetree@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1421963668-28359-1-git-send-email-khilman@kernel.org>
In-reply-to: <1421963668-28359-1-git-send-email-khilman@kernel.org>
Subject: RE: [PATCH v3] ARM: dts: exynos5422-odroidxu3: add on-board INA231
 sensors
Date: Fri, 23 Jan 2015 15:37:50 +0900
Message-id: <0b5701d036d7$1bdcad20$53960760$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: AQJqdtlF/jQmSku3bh+6RB1diiIGoZuYwAew
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t8zY137NwdDDCYuU7aYf+Qcq0X/m4Ws
	FuderWS0OPq7wKL/8Wtmi6ebHzNZfD28gtHi/aFnzBabHl9jtbi8aw6bxYzz+5gsbl/mtVh6
	/SKTxYTpa1ksWvceYbeYfvwtq4OAx5p5axg9Wpp72Dwu9/Uyefx9fp3FY+XyL2wem1Z1snnc
	ubaHzWPzknqP2/8eM3t83iQXwBXFZZOSmpNZllqkb5fAlXFs5RS2gn9CFduW72BsYLzI18XI
	ySEhYCJx/s4eFghbTOLCvfVsXYxcHEICyxglGg4tZupi5AAr6jmiDFIjJLCIUWLOE0GImr+M
	Er/Xz2cGqWETUJZobNIHqREW0JJYuKUJbKaIgJfE/WnNjCA2s8ALFomHH5Mg5jhJXNt5GKyG
	U8BZYvfHl0wQvaESeyf+YQaxWQRUJfqubgGr4RWwkPiw4j0bhC0o8WPyPRaImVoS63ceZ4Kw
	5SU2r3nLDPGLgsSOs6+h9opI7HvxjhHiHiOJphVvwH6UELjCIXFr0102iGUCEt8mH2KB+FdW
	YtMBqDmSEgdX3GCZwCg5C8nqWUhWz0KyehaSdQsYWVYxiqYWJBcUJ6UXGesVJ+YWl+al6yXn
	525ihCSW/h2Mdw9YH2IU4GBU4uFt2HIwRIg1say4MvcQoynQRROZpUST84HpK68k3tDYzMjC
	1MTU2Mjc0kxJnHeh1M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYzJLj7GSfYJbzl2J8u/
	Ckp/rp/1pFbHn49Z+miE87VS51CP/dKm97X3N5rt9HIq77W8sthpe6FVT47/Gb5UG+Wggu1a
	Owpr9t7jNr2a7uTEsUxlZsq37FkPHLe+cpM7/Xyb3B/RTZq/XsdJzl26O4+PR236vs1n54Ry
	ZJtwLXXpOlK059OL00osxRmJhlrMRcWJACFW2PonAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHKsWRmVeSWpSXmKPExsVy+t9jAV37NwdDDB6/lrGYf+Qcq0X/m4Ws
	FuderWS0OPq7wKL/8Wtmi6ebHzNZfD28gtHi/aFnzBabHl9jtbi8aw6bxYzz+5gsbl/mtVh6
	/SKTxYTpa1ksWvceYbeYfvwtq4OAx5p5axg9Wpp72Dwu9/Uyefx9fp3FY+XyL2wem1Z1snnc
	ubaHzWPzknqP2/8eM3t83iQXwBXVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlh
	rqSQl5ibaqvk4hOg65aZA/SKkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCw
	jjHj2MopbAX/hCq2Ld/B2MB4ka+LkYNDQsBEoueIchcjJ5ApJnHh3no2EFtIYBGjxJwngl2M
	XED2X0aJ3+vnM4PUswkoSzQ26YPUCAtoSSzc0sQCYosIeEncn9bMCGIzC7xgkXj4MQlijpPE
	tZ2HwWo4BZwldn98yQTRGyqxd+IfZhCbRUBVou/qFrAaXgELiQ8r3rNB2IISPybfY4GYqSWx
	fudxJghbXmLzmrfMEDcrSOw4+xpqr4jEvhfvGCHuMZJoWvGGbQKj8Cwko2YhGTULyahZSNoX
	MLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAhOW8+kdjCubLA4xCjAwajEw9uw5WCIEGti
	WXFl7iFGCQ5mJRHe7kdAId6UxMqq1KL8+KLSnNTiQ4ymQJ9OZJYSTc4HptS8knhDYxMzI0sj
	MwsjE3NzJXFeJfu2ECGB9MSS1OzU1ILUIpg+Jg5OqQbGXOuFRva9K1au7zcKcc/J8Qlkic3L
	3v3U1XZ6o5Gnr9a8e5Y/NmmePnG24nTOZsviqo+PX/2ML7ht7XyYgYH1/d22DxvPX7bj4BJ1
	E34/2fN9OksX28dyhUyOJ5sMWfLkX0w+8X6pgVky0yVfq0ib3tDXJXofxbZ6hx7V5NO8wvSb
	51bDwkdKLMUZiYZazEXFiQAyPwyUcQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Hilman wrote:
> 
> From: Kevin Hilman <khilman@linaro.org>
> 
> The odroid-xu3 has 4 INA231 current sensors on board which can be
> accessed from the Linux via the hwmon interface.
> 
> There is one sensor for each of these power rails:
> 
> - A15 cluster: VDD_ARM
> - A7 cluster: VDD_KFC
> - GPU: VDD_G3D
> - memory: VDD_MEM
> 
> In addition to adding the sensors, LDO26 from the PMIC needs to be
> enabled because it's powering these sensor.
> 
> Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Cc: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
> Reviewed-By: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
> Signed-off-by: Kevin Hilman <khilman@linaro.org>
> ---
> v3: extend existing i2c_0 node
> v2: use "ti,ina231" as compatible string.
> 
> Applies on top of "ARM: dts: Add dts file for odroid XU3 board" from Sjoerd Simons.
> 
>  arch/arm/boot/dts/exynos5422-odroidxu3.dts | 39 ++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos5422-odroidxu3.dts b/arch/arm/boot/dts/exynos5422-odroidxu3.dts
> index c29123c0734d..38694a4a5417 100644
> --- a/arch/arm/boot/dts/exynos5422-odroidxu3.dts
> +++ b/arch/arm/boot/dts/exynos5422-odroidxu3.dts
> @@ -174,6 +174,13 @@
>  					regulator-always-on;
>  				};
> 
> +				ldo26_reg: LDO26 {
> +					regulator-name = "vdd_ldo26";
> +					regulator-min-microvolt = <3000000>;
> +					regulator-max-microvolt = <3000000>;
> +					regulator-always-on;
> +				};
> +
>  				buck1_reg: BUCK1 {
>  					regulator-name = "vdd_mif";
>  					regulator-min-microvolt = <800000>;
> @@ -330,3 +337,35 @@
>  &usbdrd_dwc3_1 {
>  	dr_mode = "otg";
>  };
> +
> +&i2c_0 {
> +	status = "okay";
> +
> +	/* A15 cluster: VDD_ARM */
> +	ina231@40 {
> +		compatible = "ti,ina231";
> +		reg = <0x40>;
> +		shunt-resistor = <10000>;
> +	};
> +
> +	/* memory: VDD_MEM */
> +	ina231@41 {
> +		compatible = "ti,ina231";
> +		reg = <0x41>;
> +		shunt-resistor = <10000>;
> +	};
> +
> +	/* GPU: VDD_G3D */
> +	ina231@44 {
> +		compatible = "ti,ina231";
> +		reg = <0x44>;
> +		shunt-resistor = <10000>;
> +	};
> +
> +	/* A7 cluster: VDD_KFC */
> +	ina231@45 {
> +		compatible = "ti,ina231";
> +		reg = <0x45>;
> +		shunt-resistor = <10000>;
> +	};
> +};
> --
> 2.1.3

OK, let me replace the applied patch with this in my tree.

Thanks,
Kukjin

