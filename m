Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933690AbaFQULX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 16:11:23 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:54542 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932927AbaFQULW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 16:11:22 -0400
Date: Tue, 17 Jun 2014 21:11:15 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: swarren@nvidia.com, mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, dwillemsen@nvidia.com
Subject: Re: [PATCH] dt-binding: mfd: as3722: correct macro name
Message-ID: <20140617201115.GV29841@lee--X1>
References: <1402302719-9766-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402302719-9766-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jun 2014, Laxman Dewangan wrote:

> The macro name for enable3 pin is named as AS3722_EXT_CONTROL_PIN_ENABLE2
> which is conflict with the enable2 pin.
> 
> Correct this macro name to correctly reflect the enable pin i.e.
> AS3722_EXT_CONTROL_PIN_ENABLE3.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Reported-by: Dan Willemsen <dwillemsen@nvidia.com>
> ---
>  include/dt-bindings/mfd/as3722.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

> diff --git a/include/dt-bindings/mfd/as3722.h b/include/dt-bindings/mfd/as3722.h
> index 0e69256..e66c089 100644
> --- a/include/dt-bindings/mfd/as3722.h
> +++ b/include/dt-bindings/mfd/as3722.h
> @@ -13,7 +13,7 @@
>  /* External control pins */
>  #define AS3722_EXT_CONTROL_PIN_ENABLE1 1
>  #define AS3722_EXT_CONTROL_PIN_ENABLE2 2
> -#define AS3722_EXT_CONTROL_PIN_ENABLE2 3
> +#define AS3722_EXT_CONTROL_PIN_ENABLE3 3
>  
>  /* Interrupt numbers for AS3722 */
>  #define AS3722_IRQ_LID			0

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
