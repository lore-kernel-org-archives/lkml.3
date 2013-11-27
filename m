Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab3K0I6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 03:58:14 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56862 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab3K0I6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 03:58:12 -0500
Message-ID: <5295B3EF.8010602@ti.com>
Date: Wed, 27 Nov 2013 14:27:19 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Matt Porter <matt.porter@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>
CC: Tomasz Figa <t.figa@samsung.com>, Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH v3 9/9] ARM: dts: add usb udc support to bcm281xx
References: <1385403367-18144-1-git-send-email-matt.porter@linaro.org> <1385403367-18144-10-git-send-email-matt.porter@linaro.org>
In-Reply-To: <1385403367-18144-10-git-send-email-matt.porter@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 25 November 2013 11:46 PM, Matt Porter wrote:
> Adds USB OTG/PHY and clock support to BCM281xx and enables
> UDC support on the bcm11351-brt and bcm28155-ap boards.
> 
> Signed-off-by: Matt Porter <matt.porter@linaro.org>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
> ---
>  arch/arm/boot/dts/bcm11351-brt.dts |  6 ++++++
>  arch/arm/boot/dts/bcm11351.dtsi    | 18 ++++++++++++++++++
>  arch/arm/boot/dts/bcm28155-ap.dts  |  8 ++++++++
>  3 files changed, 32 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/bcm11351-brt.dts b/arch/arm/boot/dts/bcm11351-brt.dts
> index 23cd16d..396b704 100644
> --- a/arch/arm/boot/dts/bcm11351-brt.dts
> +++ b/arch/arm/boot/dts/bcm11351-brt.dts
> @@ -44,5 +44,11 @@
>  		status = "okay";
>  	};
>  
> +	usbotg: usb@3f120000 {
> +		status = "okay";
> +	};

using &usbotg could have been better. I mean if you have something like
&usbotg, you realise that the node has been created somewhere and we are just
referencing it here to add more properties.

Thanks
Kishon
