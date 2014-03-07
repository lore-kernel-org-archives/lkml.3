Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaCGKZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 05:25:44 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:49920 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbaCGKZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:25:40 -0500
Message-ID: <53199E88.8000800@ti.com>
Date: Fri, 7 Mar 2014 12:25:12 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <balbi@ti.com>, <kishon@ti.com>, <rob@landley.net>, <galak@codeaurora.org>,
        <ijc+devicetree@hellion.org.uk>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <robh+dt@kernel.org>, <tony@atomide.com>,
        <anatol.pomozov@gmail.com>, <bcousson@baylibre.com>
Subject: Re: [PATCH v2 4/5] ARM: dts: am437x-gp-evm: Enable USB
References: <1394183758-3821-1-git-send-email-george.cherian@ti.com> <1394183758-3821-5-git-send-email-george.cherian@ti.com>
In-Reply-To: <1394183758-3821-5-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi George,

On 03/07/2014 11:15 AM, George Cherian wrote:
> Enable
> 	- ocp2scp
> 	- USB PHY control module
> 	- USB PHY
> 	- dwc3_omap
> 	- USB
> for am437x-gp-evm
> 
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>  arch/arm/boot/dts/am437x-gp-evm.dts | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/am437x-gp-evm.dts b/arch/arm/boot/dts/am437x-gp-evm.dts
> index 4eb72b8..1d516a7 100644
> --- a/arch/arm/boot/dts/am437x-gp-evm.dts
> +++ b/arch/arm/boot/dts/am437x-gp-evm.dts
> @@ -98,3 +98,31 @@
>  &gpio4 {
>  	status = "okay";
>  };
> +
> +
> +&usb2_phy1 {
> +	status = "okay";
> +};
> +
> +&dwc3_1 {
> +	status = "okay";
> +};

Do you need to explicitly enable dwc3_1 nand dwc3_2?

> +
> +&usb1 {
> +	dr_mode = "peripheral";
> +	status = "okay";
> +};
> +
> +
> +&usb2_phy2 {
> +	status = "okay";
> +};
> +
> +&dwc3_2 {
> +	status = "okay";
> +};
> +
> +&usb2 {
> +	dr_mode = "host";
> +	status = "okay";
> +};
> 

cheers,
-roger
