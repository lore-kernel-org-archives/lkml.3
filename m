Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148Ab3EXIwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 04:52:37 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:11086 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759982Ab3EXIwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 04:52:34 -0400
Message-ID: <519F2A4F.8080008@atmel.com>
Date: Fri, 24 May 2013 10:52:31 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] ARM: at91/dt: fix macb pinctrl_macb_rmii_mii_alt definition
References: <1369324881-31428-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1369324881-31428-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/05/2013 18:01, Boris BREZILLON :
> The PA24 pin is wrongly assigned to peripheral B.
> In the current config there is 2 ETX3 pins (PA11 and PA24) and
> no ETXER pin (PA22).
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Nice catch!

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

and stacked on at91-3.10-fixes and add the stable tag #3.8+

Thanks, bye.

> ---
>   arch/arm/boot/dts/at91sam9260.dtsi |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
> index 70b5ccb..84c4bef 100644
> --- a/arch/arm/boot/dts/at91sam9260.dtsi
> +++ b/arch/arm/boot/dts/at91sam9260.dtsi
> @@ -264,7 +264,7 @@
>   						atmel,pins =
>   							<0 10 0x2 0x0	/* PA10 periph B */
>   							 0 11 0x2 0x0	/* PA11 periph B */
> -							 0 24 0x2 0x0	/* PA24 periph B */
> +							 0 22 0x2 0x0	/* PA22 periph B */
>   							 0 25 0x2 0x0	/* PA25 periph B */
>   							 0 26 0x2 0x0	/* PA26 periph B */
>   							 0 27 0x2 0x0	/* PA27 periph B */
>


-- 
Nicolas Ferre
