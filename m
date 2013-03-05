Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab3CEOm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 09:42:56 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:37130 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab3CEOmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 09:42:54 -0500
Message-ID: <51360436.6050409@cogentembedded.com>
Date: Tue, 05 Mar 2013 18:41:58 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        b-cousson@ti.com, tony@atomide.com, linux@arm.linux.org.uk,
        balbi@ti.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 7/8] ARM: dts: omap5: add dwc3 omap dt data
References: <1362494223-14151-1-git-send-email-kishon@ti.com> <1362494223-14151-8-git-send-email-kishon@ti.com>
In-Reply-To: <1362494223-14151-8-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05-03-2013 18:37, Kishon Vijay Abraham I wrote:

> Add dwc3 omap glue data to the omap5 dt data file. The information about
> the dt node added here is available @
> Documentation/devicetree/bindings/usb/omap-usb.txt

> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>   arch/arm/boot/dts/omap5.dtsi |   11 +++++++++++
>   1 file changed, 11 insertions(+)

> diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
> index bd73257..c4eb2ec 100644
> --- a/arch/arm/boot/dts/omap5.dtsi
> +++ b/arch/arm/boot/dts/omap5.dtsi
> @@ -505,6 +505,17 @@
>   			ti,type = <2>;
>   		};
>
> +		omap_dwc3@4a020000 {
> +			compatible = "ti,dwc3";
> +			ti,hwmods = "usb_otg_ss";
> +			reg = <0x4a020000 0x1000>;
> +			interrupts = <0 93 4>;
> +			#address-cells = <1>;
> +			#size-cells = <1>;

   Why the above two props? You don't seem to have the subnodes...

WBR, Sergei

