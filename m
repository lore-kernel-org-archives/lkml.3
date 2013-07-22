Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab3GVMeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 08:34:17 -0400
Received: from 217-155-41-104.dsl.in-addr.zen.co.uk ([217.155.41.104]:49321
	"EHLO centos1.newflow.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751105Ab3GVMeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 08:34:16 -0400
Message-ID: <51ED26C6.6000004@newflow.co.uk>
Date: Mon, 22 Jul 2013 13:34:14 +0100
From: Mark Jackson <mpfj-list@newflow.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 01/22] ARM: ux500: Remove '0x's from HREF v60+ DTS file
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/07/13 11:52, Lee Jones wrote:
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/boot/dts/hrefv60plus.dts | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/hrefv60plus.dts b/arch/arm/boot/dts/hrefv60plus.dts
> index 3d580d6..46fd8af 100644
> --- a/arch/arm/boot/dts/hrefv60plus.dts
> +++ b/arch/arm/boot/dts/hrefv60plus.dts
> @@ -26,7 +26,7 @@
>  
>  	soc {
>  		i2c@80110000 {
> -			bu21013_tp@0x5c {
> +			bu21013_tp@5c {

Just a query ... why this one .... ^^^ ...

>  				reset-gpio = <&gpio4 15 0x4>;

... and not this one .................................. ^^^ ?

>  			};
>  		};
> 

The same for all the other patches in this series.

If this is by design, it might be worth mentioning why some are
removed and not others.

Mark J.
