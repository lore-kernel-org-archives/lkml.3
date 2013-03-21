Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932974Ab3CUP6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 11:58:13 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:49204 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601Ab3CUP6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 11:58:08 -0400
Message-ID: <514B21C9.8050108@atmel.com>
Date: Thu, 21 Mar 2013 16:05:45 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] DTS at91sam9x5ek: i2c1 and i2c2 conflict with macb and
 lcd
References: <1363778575-4809-1-git-send-email-richard.genoud@gmail.com>
In-Reply-To: <1363778575-4809-1-git-send-email-richard.genoud@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 12:22 PM, Richard Genoud :
> on at91sam9x5ek, macb0 is enabled, so it conflicts with i2c2 (PB4)
> same for i2c1, (conflicts with LCD).
> Moreover, only i2c0 is used on this board.
> 
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

And pushed to at91-3.10-dt branch.

Thanks,

> ---
>  arch/arm/boot/dts/at91sam9x5ek.dtsi |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/at91sam9x5ek.dtsi b/arch/arm/boot/dts/at91sam9x5ek.dtsi
> index 8a7cf1d..1128565 100644
> --- a/arch/arm/boot/dts/at91sam9x5ek.dtsi
> +++ b/arch/arm/boot/dts/at91sam9x5ek.dtsi
> @@ -61,14 +61,6 @@
>  				status = "okay";
>  			};
>  
> -			i2c1: i2c@f8014000 {
> -				status = "okay";
> -			};
> -
> -			i2c2: i2c@f8018000 {
> -				status = "okay";
> -			};
> -
>  			pinctrl@fffff400 {
>  				mmc0 {
>  					pinctrl_board_mmc0: mmc0-board {
> 


-- 
Nicolas Ferre
