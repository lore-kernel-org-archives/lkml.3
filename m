Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbaHVKtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 06:49:55 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18342 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757AbaHVKtr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 06:49:47 -0400
X-AuditID: cbfee68f-b7fa26d0000039a0-94-53f720485753
From: Kukjin Kim <kgene.kim@samsung.com>
To: "=?UTF-8?Q?'Andreas_F=C3=A4rber'?=" <afaerber@suse.de>,
        linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        "'Vincent Palatin'" <vpalatin@chromium.org>,
        "'Doug Anderson'" <dianders@chromium.org>,
        "'Javier Martinez Canillas'" <javier.martinez@collabora.co.uk>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Pawel Moll'" <pawel.moll@arm.com>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Ian Campbell'" <ijc+devicetree@hellion.org.uk>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <53DCD74B.8090400@gmail.com>
 <1408539764-5835-1-git-send-email-afaerber@suse.de>
In-reply-to: <1408539764-5835-1-git-send-email-afaerber@suse.de>
Subject: RE: [PATCH v7] ARM: dts: Prepare node labels for exynos5250
Date: Fri, 22 Aug 2014 19:49:44 +0900
Message-id: <080101cfbdf6$c8fd1f30$5af75d90$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQF/9AkePbHshrqOzuLNSxElPRZOTgHeDirUnG0SkjA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t8zI11Phe/BBqecLZo3FVtMWneAyWL+
	kXOsFmeXHWSz6H+zkNXi3KuVjBZHfxdYbHp8jdXi8q45bBYzzu9jsrh9mddi6fWLTBYTpq9l
	sWjde4TdYv2M1ywW277dYXEQ8Fgzbw2jR0tzD5vH7IaLLB6X+3qZPP4+v87i8XfVC2aPlcu/
	sHlsWtXJ5rF5Sb1H35ZVjB6bT1d7fN4kF8ATxWWTkpqTWZZapG+XwJXxdNsWloJ/whUndk1h
	bGCcw9/FyMEhIWAi0bRKoYuRE8gUk7hwbz0biC0ksIxR4tXbeoi4icSK7o+sXYxcQPHpjBKP
	Pz6Bcv4ySpy4vYcFpIpNQEPi8Ptn7CC2iECsxOHtt5hBipgFjrNI/Fw+lwlibJzEzXmrwFZw
	CjhIzH5yiRXEFhZwkVjbfhksziKgKrF6+xpmEJtXwFJi9pGnULagxI/J98CWMQuoS0yat4gZ
	wtaWePLuAivEqQoSO86+ZoQ4wkri1aL5rBA1IhL7XrxjBDlIQuAGh8Snw91MEMsEJL5NPsQC
	CQpZiU0HmCHmSEocXHGDZQKjxCwkq2chWT0LyepZSFYsYGRZxSiaWpBcUJyUXmSsV5yYW1ya
	l66XnJ+7iRGSUvp3MN49YH2IMRlo/URmKdHkfGBKyiuJNzQ2M7IwNTE1NjK3NCNNWEmc9/7D
	pCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjN1fg2XETnSYpd9eHnfVq6/lgCfPDZ2swFWr
	XiXvSAhISju24VpHrdH0eSr3fq5jlvjouuC7UIJia4pb0PT4D3aTP65Mt4wSfiKrv4Lt0k7u
	/0FPKhqFp62bXm7iL5XKzvA4OFFSi3VXefIh9yclJqIOjGv3PF7wMoHrgcHcY4pR/eJ12zmf
	KrEUZyQaajEXFScCAE9xWbo/AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHKsWRmVeSWpSXmKPExsVy+t9jQV0Phe/BBjvWWVg0byq2mLTuAJPF
	/CPnWC3OLjvIZtH/ZiGrxblXKxktjv4usNj0+BqrxeVdc9gsZpzfx2Rx+zKvxdLrF5ksJkxf
	y2LRuvcIu8X6Ga9ZLLZ9u8PiIOCxZt4aRo+W5h42j9kNF1k8Lvf1Mnn8fX6dxePvqhfMHiuX
	f2Hz2LSqk81j85J6j74tqxg9Np+u9vi8SS6AJ6qB0SYjNTEltUghNS85PyUzL91WyTs43jne
	1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6CUlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4h
	QXA9RgZoIGEdY8bTbVtYCv4JV5zYNYWxgXEOfxcjJ4eEgInEiu6PrBC2mMSFe+vZuhi5OIQE
	pjNKPP74hBXC+csoceL2HhaQKjYBDYnD75+xg9giArESh7ffYgYpYhY4ziLxc/lcJpCEkECc
	xM15q9hAbE4BB4nZTy6BrRAWcJFY234ZLM4ioCqxevsaZhCbV8BSYvaRp1C2oMSPyffAljEL
	qEtMmreIGcLWlnjy7gLUqQoSO86+ZoQ4wkri1aL5rBA1IhL7XrxjnMAoNAvJqFlIRs1CMmoW
	kpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYLT1jPpHYyrGiwOMQpwMCrx8EZ8+Ros
	xJpYVlyZe4hRgoNZSYT3hsD3YCHelMTKqtSi/Pii0pzU4kOMpkCfTmSWEk3OB6bUvJJ4Q2MT
	MyNLIzMLIxNzcyVx3oOt1oFCAumJJanZqakFqUUwfUwcnFINjBsj97AYWQdKaix4HmJl9XSu
	/XKlVD3pEnl9rqR7q0xFPh2exZfFFZ25re+BwiahHZHOy59cmNB2p7+k5Fb7WYPC7ubvHfwd
	xt+Z9b3OlZT87DrFJXosfY3/phkb7maJb/mmPFX+2K5103O6Gv4Zvf+ZfangwfZFZzf5Zf+I
	mrz3YGO/SEl5lBJLcUaioRZzUXEiAPbQfTlxAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Färber wrote:
> 
> Allows them to be extended by reference.
> 
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Andreas Färber <afaerber@suse.de>
> ---
>  v6 -> v7:
>  * Dropped uart* labels (Tomasz Figa)
> 
>  v6: Split off from Snow/SMDK cleanups (Doug Anderson)
> 
>  arch/arm/boot/dts/exynos5250.dtsi | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index 492e1eff37bd..42eafd19cfb2 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -218,7 +218,7 @@
>  		clock-names = "fimg2d";
>  	};
> 
> -	codec@11000000 {
> +	mfc: codec@11000000 {
>  		compatible = "samsung,mfc-v6";
>  		reg = <0x11000000 0x10000>;
>  		interrupts = <0 96 0>;
> @@ -227,7 +227,7 @@
>  		clock-names = "mfc";
>  	};
> 
> -	rtc@101E0000 {
> +	rtc: rtc@101E0000 {
>  		clocks = <&clock CLK_RTC>;
>  		clock-names = "rtc";
>  		status = "disabled";
> @@ -261,7 +261,7 @@
>  		clock-names = "uart", "clk_uart_baud0";
>  	};
> 
> -	sata@122F0000 {
> +	sata: sata@122F0000 {
>  		compatible = "snps,dwc-ahci";
>  		samsung,sata-freq = <66>;
>  		reg = <0x122F0000 0x1ff>;
> @@ -573,7 +573,7 @@
>  		#phy-cells = <1>;
>  	};
> 
> -	usb@12110000 {
> +	ehci: usb@12110000 {

I'm not sure which one is recommended between above and "ehci: ehci@12110000 {"

>  		compatible = "samsung,exynos4210-ehci";
>  		reg = <0x12110000 0x100>;
>  		interrupts = <0 71 0>;
> @@ -588,7 +588,7 @@
>  		};
>  	};
> 
> -	usb@12120000 {
> +	ohci: usb@12120000 {

Same as above...

>  		compatible = "samsung,exynos4210-ohci";
>  		reg = <0x12120000 0x100>;
>  		interrupts = <0 71 0>;
> @@ -725,7 +725,7 @@
>  		clock-names = "gscl";
>  	};
> 
> -	hdmi {
> +	hdmi: hdmi {

Should be

+	hdmi: hdmi@14530000 { ?

>  		compatible = "samsung,exynos4212-hdmi";
>  		reg = <0x14530000 0x70000>;
>  		interrupts = <0 95 0>;
> @@ -751,14 +751,14 @@
>  		#phy-cells = <0>;
>  	};
> 
> -	dp-controller@145B0000 {
> +	dp: dp-controller@145B0000 {
>  		clocks = <&clock CLK_DP>;
>  		clock-names = "dp";
>  		phys = <&dp_phy>;
>  		phy-names = "dp";
>  	};
> 
> -	fimd@14400000 {
> +	fimd: fimd@14400000 {
>  		clocks = <&clock CLK_SCLK_FIMD1>, <&clock CLK_FIMD1>;
>  		clock-names = "sclk_fimd", "fimd";
>  	};
> --
> 2.0.4

