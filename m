Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762035Ab3EBT5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 15:57:17 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:37150 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761631Ab3EBT5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 15:57:16 -0400
Message-ID: <5182C512.4050102@free-electrons.com>
Date: Thu, 02 May 2013 21:57:06 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: kirkwood: add button for OpenBlock A6
References: <1367523802-16372-1-git-send-email-gregory.clement@free-electrons.com>
In-Reply-To: <1367523802-16372-1-git-send-email-gregory.clement@free-electrons.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2013 09:43 PM, Gregory CLEMENT wrote:
> The OpenBlocks A6 board has one software-controlled button on the
> front side, labeled "INIT", so we add minimal support for this button
> in the kernel.
> 

Oh, I found that Thomas have already submitted the same patch but I was
misleaded because I didn't find anything related to this in v3.9,
nor in next-20130502.

You can drop this patch of course, but waht happens to Thomas' patch?

> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  arch/arm/boot/dts/kirkwood-openblocks_a6.dts |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/kirkwood-openblocks_a6.dts b/arch/arm/boot/dts/kirkwood-openblocks_a6.dts
> index d27f724..627d8d0 100644
> --- a/arch/arm/boot/dts/kirkwood-openblocks_a6.dts
> +++ b/arch/arm/boot/dts/kirkwood-openblocks_a6.dts
> @@ -209,4 +209,17 @@
>  			gpios = <&gpio1 11 1>;
>  		};
>          };
> +
> +	gpio_keys {
> +		compatible = "gpio-keys";
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +			button@1 {
> +			label = "Init Button";
> +			linux,code = <116>;
> +			gpios = <&gpio1 6 0>;
> +		};
> +	};
> +
>  };
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
