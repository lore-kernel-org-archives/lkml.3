Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaE0JYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 05:24:41 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:41050 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbaE0JYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 05:24:37 -0400
Date: Tue, 27 May 2014 10:24:28 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Cc: dbaryshkov@gmail.com, dwmw2@infradead.org, santosh.shilimkar@ti.com,
        arnd@arndb.de, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, grant.likely@linaro.org, rdunlap@infradead.org,
        mturquette@linaro.org, linux@arm.linux.org.uk,
        grygorii.strashko@ti.com, olof@lixom.net, w-kwok2@ti.com,
        sboyd@codeaurora.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, m-karicheri2@ti.com,
        sergei.shtylyov@cogentembedded.com
Subject: Re: [Patch v7 3/7] mfd: ti-keystone-devctrl: add bindings for device
 state control
Message-ID: <20140527092428.GH5875@lee--X1>
References: <1400859812-5761-1-git-send-email-ivan.khoronzhuk@ti.com>
 <1400859812-5761-4-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400859812-5761-4-git-send-email-ivan.khoronzhuk@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The Keystone II devices have a set of registers that are used to control
> the status of its peripherals. This node is intended to allow access to
> this functionality.
> 
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>

Acked-by: Lee Jones <lee.jones@linaro.org>

> ---
>  .../devicetree/bindings/mfd/ti-keystone-devctrl.txt   | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/ti-keystone-devctrl.txt
> 
> diff --git a/Documentation/devicetree/bindings/mfd/ti-keystone-devctrl.txt b/Documentation/devicetree/bindings/mfd/ti-keystone-devctrl.txt
> new file mode 100644
> index 0000000..20963c7
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
> +- reg:			contains offset/length value for device state control
> +			registers space.
> +
> +Example:
> +
> +devctrl: device-state-control@0x02620000 {
> +	compatible = "ti,keystone-devctrl", "syscon";
> +	reg = <0x02620000 0x1000>;
> +};

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
