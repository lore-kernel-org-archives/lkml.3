Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab3AZTzM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 14:55:12 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:55833 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab3AZTzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 14:55:09 -0500
Message-ID: <51043333.6030208@mvista.com>
Date: Sat, 26 Jan 2013 23:49:07 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: balbi@ti.com, b-cousson@ti.com, tony@atomide.com, linux@arm.linux.org.uk,
        s-guiriec@ti.com, gg@slimlogic.co.uk, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/6] ARM: dts: omap5: add dwc3 core dt data
References: <1359112312-6918-1-git-send-email-kishon@ti.com> <1359112312-6918-6-git-send-email-kishon@ti.com>
In-Reply-To: <1359112312-6918-6-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25-01-2013 15:11, Kishon Vijay Abraham I wrote:

> Add dwc3 core dt data as a subnode to dwc3 omap glue data in omap5 dt
> data file. The information for the entered data node is available @
> Documentation/devicetree/bindings/usb/dwc3.txt

> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>   arch/arm/boot/dts/omap5.dtsi |    7 +++++++
>   1 file changed, 7 insertions(+)

> diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
> index 1703a72..58118c4 100644
> --- a/arch/arm/boot/dts/omap5.dtsi
> +++ b/arch/arm/boot/dts/omap5.dtsi
> @@ -522,6 +522,13 @@
>   			#size-cells = <1>;
>   			utmi-mode = <2>;
>   			ranges;
> +			dwc3@4a030000 {
> +				compatible = "synopsys,dwc3";
> +				reg = <0x4a030000 0xcfff>;

    Same question here.

WBR, Sergei

