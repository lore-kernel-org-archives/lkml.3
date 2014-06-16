Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbaFPJxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:53:09 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:49437 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbaFPJxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:53:06 -0400
Date: Mon, 16 Jun 2014 10:52:56 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: robh+dt@kernel.org, swarren@nvidia.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        linus.walleij@linaro.org
Subject: Re: [PATCH] Doc: mfd: as3722: Add details of optional missing
 property
Message-ID: <20140616095256.GN14323@lee--X1>
References: <1402297417-9338-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402297417-9338-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC'ing Linus as he had an opinion.

On Mon, 09 Jun 2014, Laxman Dewangan wrote:
> Add details of following properties which are used on driver but
> not documented on DT binding document.
> - ams,enable-internal-int-pullup
> - ams,enable-internal-i2c-pullup
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Reported-by: Lee Jones <lee.jones@linaro.org>
> ---
>  Documentation/devicetree/bindings/mfd/as3722.txt | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/mfd/as3722.txt b/Documentation/devicetree/bindings/mfd/as3722.txt
> index 8edcb9b..4f64b2a 100644
> --- a/Documentation/devicetree/bindings/mfd/as3722.txt
> +++ b/Documentation/devicetree/bindings/mfd/as3722.txt
> @@ -13,6 +13,14 @@ Required properties:
>    The second cell is the flags, encoded as the trigger masks from binding document
>  	interrupts.txt, using dt-bindings/irq.
>  
> +Optional properties:
> +--------------------
> +- ams,enable-internal-int-pullup: Boolean property, to enable internal pullup on
> +	interrupt pin. Missing this will disable internal pullup on INT pin.
> +- ams,enable-internal-i2c-pullup: Boolean property, to enable internal pullup on
> +	i2c scl/sda pins. Missing this will disable internal pullup on i2c
> +	scl/sda lines.
> +
>  Optional submodule and their properties:
>  =======================================
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
