Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab3GDNtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 09:49:33 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59350 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756585Ab3GDNtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 09:49:31 -0400
Message-ID: <51D57D4F.30905@ti.com>
Date: Thu, 4 Jul 2013 19:19:03 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        =?UTF-8?B?QmVub8OudCBDb3Vzc29u?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <linux-input@vger.kernel.org>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH 14/22] arm/am33xx: add TSC/ADC mfd device support
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de> <1370950268-7224-15-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1370950268-7224-15-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 6/11/2013 5:01 PM, Sebastian Andrzej Siewior wrote:
> From: "Patil, Rachna" <rachna@ti.com>
> 
> Add support for core multifunctional device along
> with its clients touchscreen and ADC.
> 
> [ panto@antoniou-consulting.com : make sure status is
> 	set to 'disabled' in dtsi file. ]
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> Signed-off-by: Patil, Rachna <rachna@ti.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> [bigeasy: add 'status = "okay"']
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> ---
>  arch/arm/boot/dts/am335x-evm.dts |   14 ++++++++++++++
>  arch/arm/boot/dts/am33xx.dtsi    |   18 ++++++++++++++++++
>  2 files changed, 32 insertions(+)

> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 1460d9b..4ad7797 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -404,6 +404,24 @@
>  			ti,hwmods = "wkup_m3";
>  		};
>  
> +		tscadc: tscadc@44e0d000 {
> +			compatible = "ti,am3359-tscadc";
> +			reg = <0x44e0d000 0x1000>;
> +			interrupt-parent = <&intc>;

interrupt-parent can be dropped since it will be inherited from parent.

Thanks,
Sekhar
