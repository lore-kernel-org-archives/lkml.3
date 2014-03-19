Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965562AbaCSPk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 11:40:59 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43289 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965524AbaCSPk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 11:40:57 -0400
Date: Wed, 19 Mar 2014 16:40:56 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Boris BREZILLON <brezillonboris@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mike Turquette <mturquette@linaro.org>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: Re: [PATCH 11/11] ARM: at91/dt: define sam9rlek crystal frequencies
Message-ID: <20140319154055.GO12021@piout.net>
References: <1395173924-3648-1-git-send-email-b.brezillon.dev@gmail.com>
 <1395173924-3648-12-git-send-email-b.brezillon.dev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395173924-3648-12-git-send-email-b.brezillon.dev@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/03/2014 at 21:18:44 +0100, Boris BREZILLON wrote :
> Define at91sam9rlek crystal frequencies.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>

Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

> ---
>  arch/arm/boot/dts/at91sam9rlek.dts |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/at91sam9rlek.dts b/arch/arm/boot/dts/at91sam9rlek.dts
> index cddb378..85b68b9 100644
> --- a/arch/arm/boot/dts/at91sam9rlek.dts
> +++ b/arch/arm/boot/dts/at91sam9rlek.dts
> @@ -25,6 +25,14 @@
>  		#size-cells = <1>;
>  		ranges;
>  
> +		slow_xtal: slow_xtal {
> +			clock-frequency = <32768>;
> +		};
> +
> +		main_xtal: main_xtal {
> +			clock-frequency = <12000000>;
> +		};
> +
>  		main_clock: clock {
>  			compatible = "atmel,osc", "fixed-clock";
>  			clock-frequency = <12000000>;
> -- 
> 1.7.9.5
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
