Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbaESJ3C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:29:02 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:10491 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbaESJ26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:28:58 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-83-5379ced833b5
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        stern@rowland.harvard.edu, kishon@ti.com, k.debski@samsung.com,
        jg1.han@samsung.com
References: <1399641784-10833-1-git-send-email-gautam.vivek@samsung.com>
 <1399641784-10833-2-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1399641784-10833-2-git-send-email-gautam.vivek@samsung.com>
Subject: RE: [PATCH v9 1/4] ARM: dts: Add sysreg sytem controller node to
 exynos5250 and exynos5420
Date: Mon, 19 May 2014 18:28:55 +0900
Message-id: <02fe01cf7344$c19d36f0$44d7a4d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHPDZLCoGnx6+EQOBbO44c7+dsEuwJd0BHfmzV/NFA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t8zY90b5yqDDbYcELCYf+Qcq0XblYPs
	FpcXXmK1+PH6ApvFhac9bBabHl9jtbi8aw6bxYzz+5gsFi1rZbZo3XuE3WLC7wtsDtwem1Z1
	snlsXlLvMfvuD0aPvi2rGD2O39jO5PF5k1wAWxSXTUpqTmZZapG+XQJXRs/uC2wFa/krXvU+
	YGlg3MbTxcjJISFgIrHr+Tw2CFtM4sK99UA2F4eQwDJGiVezr7DDFC189pkRIrGIUWLL5y5m
	COcvo8Ssj5PBqtgENCQOv38GZosI5ErMeruSGcRmFrjIKHH7SjFEQzujxLZdv4ASHBycAp4S
	b5pDQGqEBVIl9iw6zQhiswioSrTfaAY7iVfAUuLVlXnMELagxI/J91ggZmpJrN95nAnClpfY
	vOYtM8SlChI7zr5mhLjBSqLr5gyoehGJfS/egX0gIdDLIbF/6hZWiGUCEt8mH2IBuUdCQFZi
	0wGoOZISB1fcYJkA9B6S1bOQrJ6FZPUsJCsWMLKsYhRNLUguKE5KLzLSK07MLS7NS9dLzs/d
	xAiJ+L4djDcPWB9iTAZaP5FZSjQ5H5gw8kriDY3NjCxMTUyNjcwtzUgTVhLnXfQwKUhIID2x
	JDU7NbUgtSi+qDQntfgQIxMHp1QDY+WDHQuq5p/Z9kCk1tTUffndPWxaOxx4GbgEZWuutkg/
	m5EVo313b3xE1KHkmlVy75JPbpozMTN7oejhteXrN2xdv+PPFafMX5s5Erwkyk8p90bbrryo
	Y73UOtcp6gu34j69Fz/jdsZ/ufXq9QeV1Ru9fyiJ1beefXJr6w/Z/443OLf8Wa7/o1aJpTgj
	0VCLuag4EQBHCJz7DgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBKsWRmVeSWpSXmKPExsVy+t9jAd0b5yqDDZqucFvMP3KO1aLtykF2
	i8sLL7Fa/Hh9gc3iwtMeNotNj6+xWlzeNYfNYsb5fUwWi5a1Mlu07j3CbjHh9wU2B26PTas6
	2Tw2L6n3mH33B6NH35ZVjB7Hb2xn8vi8SS6ALaqB0SYjNTEltUghNS85PyUzL91WyTs43jne
	1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6D4lhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4h
	QXA9RgZoIGEdY0bP7gtsBWv5K171PmBpYNzG08XIySEhYCKx8NlnRghbTOLCvfVsXYxcHEIC
	ixgltnzuYoZw/jJKzPo4mR2kik1AQ+Lw+2dgtohArsSstyuZQWxmgYuMErevFEM0tDNKbNv1
	CyjBwcEp4CnxpjkEpEZYIFViz6LTYNtYBFQl2m80s4HYvAKWEq+uzGOGsAUlfky+xwIxU0ti
	/c7jTBC2vMTmNW+ZIS5VkNhx9jUjxA1WEl03Z0DVi0jse/GOcQKj0Cwko2YhGTULyahZSFoW
	MLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAhOJ8+kdjCubLA4xCjAwajEwzshvDJYiDWx
	rLgy9xCjBAezkgiv32mgEG9KYmVValF+fFFpTmrxIcZkoE8nMkuJJucDU11eSbyhsYmZkaWR
	mYWRibk5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTAaxxkvb2oTSQrruDW7OYvpb4Xd
	t/vS8QsfKnusa/ugX28kxm8T4/LBdomSPN+C91rFmvEfSu/KqglsWbX2Du/7YyLvF7BGWQqU
	iYdec/1Ys2gHe6fBlayDt45827/Uu96F67envJHWDs5nU1/stb7MIqw62zx1Jwd37xFfjks+
	mt81xK7FJymxFGckGmoxFxUnAgCQUGn1awMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Gautam wrote:
> 
> This patch adds sysreg-syscon node to exynos5250 and exynos5420 device
> tree, to access System Register's registers using syscon driver.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> [gautam.vivek@samsung.com: Split this syreg-syscon dts entry from
> dts: Add usb2phy to Exynos 5250 patch]
> [gautam.vivek@samsung.com: added similar syscon entry for exynos5420]
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
> 
Vivek,

See my comment below.

And please don't version each patch in series...it's really not a good way.
It cause very big confusing...

> Changes since v7:
> None
> 
>  arch/arm/boot/dts/exynos5250.dtsi |    5 +++++
>  arch/arm/boot/dts/exynos5420.dtsi |    5 +++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi
> b/arch/arm/boot/dts/exynos5250.dtsi
> index 3742331..70f0cd5 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -175,6 +175,11 @@
>  		reg = <0x10040000 0x5000>;
>  	};
> 
> +	sysreg_system_controller: syscon@10050000 {
> +		compatible = "samsung,exynos5250-sys", "syscon";

Maybe exynos5250-sysreg?

And need to add/modify binding doc?

- Kukjin

> +		reg = <0x10050000 0x5000>;
> +	};
> +
>  	watchdog@101D0000 {
>  		compatible = "samsung,exynos5250-wdt";
>  		reg = <0x101D0000 0x100>;
> diff --git a/arch/arm/boot/dts/exynos5420.dtsi
> b/arch/arm/boot/dts/exynos5420.dtsi
> index a802f74..5d5d6e3 100644
> --- a/arch/arm/boot/dts/exynos5420.dtsi
> +++ b/arch/arm/boot/dts/exynos5420.dtsi
> @@ -682,6 +682,11 @@
>  		reg = <0x10040000 0x5000>;
>  	};
> 
> +	sysreg_system_controller: syscon@10050000 {
> +		compatible = "samsung,exynos5420-sys", "syscon";
> +		reg = <0x10050000 0x5000>;
> +	};
> +
>  	tmu_cpu0: tmu@10060000 {
>  		compatible = "samsung,exynos5420-tmu";
>  		reg = <0x10060000 0x100>;
> --
> 1.7.10.4

