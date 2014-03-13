Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbaCMKiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:38:10 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35836 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769AbaCMKiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:38:08 -0400
Message-ID: <53218A72.9080304@ti.com>
Date: Thu, 13 Mar 2014 12:37:38 +0200
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
Subject: Re: [PATCH v3 4/5] ARM: dts: am437x-gp-evm: Enable USB
References: <1394193422-18242-1-git-send-email-george.cherian@ti.com> <1394193422-18242-5-git-send-email-george.cherian@ti.com>
In-Reply-To: <1394193422-18242-5-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2014 01:57 PM, George Cherian wrote:
> Enable
> 	- ocp2scp
> 	- USB PHY control module
> 	- USB PHY
> 	- dwc3_omap
> 	- USB
> for am437x-gp-evm
> 
> Signed-off-by: George Cherian <george.cherian@ti.com>

Acked-by: Roger Quadros <rogerq@ti.com>

> ---
>  arch/arm/boot/dts/am437x-gp-evm.dts | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/am437x-gp-evm.dts b/arch/arm/boot/dts/am437x-gp-evm.dts
> index 4eb72b8..347d367 100644
> --- a/arch/arm/boot/dts/am437x-gp-evm.dts
> +++ b/arch/arm/boot/dts/am437x-gp-evm.dts
> @@ -98,3 +98,21 @@
>  &gpio4 {
>  	status = "okay";
>  };
> +
> +&usb2_phy1 {
> +	status = "okay";
> +};
> +
> +&usb1 {
> +	dr_mode = "peripheral";
> +	status = "okay";
> +};
> +
> +&usb2_phy2 {
> +	status = "okay";
> +};
> +
> +&usb2 {
> +	dr_mode = "host";
> +	status = "okay";
> +};
> 

