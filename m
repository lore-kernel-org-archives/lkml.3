Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbaJKRrb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 13:47:31 -0400
Received: from gloria.sntech.de ([95.129.55.99]:56007 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbaJKRra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 13:47:30 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, linux-rockchip@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/6] ARM: dts: rockchip: add pmu references to cpus nodes
Date: Sat, 11 Oct 2014 19:47:09 +0200
Message-ID: <4066180.uVEMeJn3o5@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1412976370-14468-5-git-send-email-kever.yang@rock-chips.com>
References: <1412976370-14468-1-git-send-email-kever.yang@rock-chips.com> <1412976370-14468-5-git-send-email-kever.yang@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 10. Oktober 2014, 14:26:08 schrieb Kever Yang:
> This patch add pmu reference and enable-method for smp
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

there should be no Signed-off from me be included here.


> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> ---
> 
> Changes in v3:
> - add this patch
> 
> Changes in v2: None
> 
>  arch/arm/boot/dts/rk3288.dtsi | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index 06f39be..44108fe 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -46,6 +46,8 @@
>  	cpus {
>  		#address-cells = <1>;
>  		#size-cells = <0>;
> +		enable-method = "rockchip,rk3066-smp";
> +		rockchip,pmu = <&pmu>;
> 
>  		cpu@500 {
>  			device_type = "cpu";

