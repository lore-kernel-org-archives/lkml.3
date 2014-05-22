Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaEVOOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 10:14:42 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:58954 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaEVOOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 10:14:40 -0400
Date: Thu, 22 May 2014 15:14:32 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Cc: dbaryshkov@gmail.com, dwmw2@infradead.org, santosh.shilimkar@ti.com,
        arnd@arndb.de, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, grant.likely@linaro.org,
        devicetree@vger.kernel.org, grygorii.strashko@ti.com,
        linux@arm.linux.org.uk, sergei.shtylyov@cogentembedded.com,
        linux-doc@vger.kernel.org, w-kwok2@ti.com, rdunlap@infradead.org,
        sboyd@codeaurora.org, linux-kernel@vger.kernel.org,
        m-karicheri2@ti.com, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch v5 3/7] mfd: ti-keystone-devctrl: add bindings for device
 state control
Message-ID: <20140522141432.GA19747@lee--X1>
References: <1400766516-14537-1-git-send-email-ivan.khoronzhuk@ti.com>
 <1400766516-14537-4-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400766516-14537-4-git-send-email-ivan.khoronzhuk@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why do I only have this patch?  Where is the rest of the set?  Also,
it's on v5 and I don't recall seeing the other 4 versions?

> The Keystone II devices have a set of registers that are used to control
> the status of its peripherals. This node is intended to allow access to
> this functionality.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
>  .../devicetree/bindings/mfd/ti-keystone-devctrl.txt   | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/ti-keystone-devctrl.txt
> 
> diff --git a/Documentation/devicetree/bindings/mfd/ti-keystone-devctrl.txt b/Documentation/devicetree/bindings/mfd/ti-keystone-devctrl.txt
> new file mode 100644
> index 0000000..35f7a66
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/ti-keystone-devctrl.txt
> @@ -0,0 +1,19 @@
> +* Device tree bindings for Texas Instruments keystone device state control
> +
> +The Keystone II devices have a set of registers that are used to control
> +the status of its peripherals. This node is intended to allow access to
> +this functionality.
> +
> +Required properties:
> +
> +- compatible:		"ti,keystone-devctrl", "syscon"
> +
> +- reg:			contains offset/length value for pll controller
> +			registers space.

Why have you tabbed out all that way?

> +Example:
> +
> +devctrl: device-state-control {

This node needs an address:

devctrl: device-state-control@02620000 {

> +	compatible = "ti,keystone-devctrl", "syscon";
> +	reg = <0x02620000 0x1000>;
> +};

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
