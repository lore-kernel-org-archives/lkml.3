Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab3LSNGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:06:23 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:58481 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab3LSNGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 08:06:18 -0500
Date: Thu, 19 Dec 2013 13:06:10 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: anton@enomsg.org, dwmw2@infradead.org, mark.rutland@arm.com,
        rob@landley.net, ijc+devicetree@hellion.org.uk, swarren@nvidia.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: AS3722: add dt node properties for system power
 controller
Message-ID: <20131219130610.GI27373@lee--X1>
References: <1387457821-12509-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387457821-12509-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013, Laxman Dewangan wrote:

> ams AS3722 device supports the power off by turning off its all rails.
> 
> Add dt node properties to enable this functionality on this device.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  Documentation/devicetree/bindings/mfd/as3722.txt |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/mfd/as3722.txt b/Documentation/devicetree/bindings/mfd/as3722.txt
> index fc2191e..1e54937 100644
> --- a/Documentation/devicetree/bindings/mfd/as3722.txt
> +++ b/Documentation/devicetree/bindings/mfd/as3722.txt
> @@ -112,6 +112,15 @@ Following are properties of regulator subnode.
>  		ams,enable-tracking: Enable tracking with SD1, only supported
>  			by LDO3.
>  
> +Power-off:
> +=========
> +AS3722 supports the system power off by turning off all its rail. The power off
> +is provided through pm power off.

I think pm_power_off is a Linuxisum.

> +The device node should have the following properties to enable power-off

Why is it power-off here and power off everywhere else?

> +functionality from ams AS3722:
> +ams,system-power-controller: To enable the power off functionality through
> +	device.

Do what with it? "on", "<1>", something else?

>  Example:
>  --------
>  #include <dt-bindings/mfd/as3722.h>

Should it be represented in the example?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
