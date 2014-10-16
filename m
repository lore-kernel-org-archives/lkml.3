Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbaJPKa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:30:58 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56021 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751815AbaJPKUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:20:13 -0400
Date: Thu, 16 Oct 2014 11:20:02 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "zyw@rock-chips.com" <zyw@rock-chips.com>
Cc: Heiko Stuebner <heiko@sntech.de>, Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-rockchip@lists.infradead.org" 
	<linux-rockchip@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Xie <xxx@rock-chips.com>
Subject: Re: [PATCH 3/4] ARM: dts: add RK3288 suspend support
Message-ID: <20141016102001.GA24714@leverpostej>
References: <1413405987-16196-1-git-send-email-zyw@rock-chips.com>
 <1413406144-16329-1-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413406144-16329-1-git-send-email-zyw@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 09:49:04PM +0100, zyw@rock-chips.com wrote:
> From: Chris Zhong <zyw@rock-chips.com>
> 
> add pmu_intmem subnode for suspend, add suspend pinctrl
> 
> Signed-off-by: Tony Xie <xxx@rock-chips.com>
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> ---
> 
>  arch/arm/boot/dts/rk3288.dtsi |   11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index 5950b0a..081af7a 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -241,6 +241,11 @@
>  		status = "disabled";
>  	};
>  
> +	pmu_intmem@ff720000 {
> +		compatible = "mmio-sram", "rockchip,rk3288-pmu-sram";

These strings should be the other way around -- the most specific string
should be first.

Mark.
