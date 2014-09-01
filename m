Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaIAVoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 17:44:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34352 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751464AbaIAVoF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 17:44:05 -0400
Date: Mon, 1 Sep 2014 23:44:01 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: =?UTF-8?B?R2HDq2w=?= PORTAY <gael.portay@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: at91/dt: sam9g20: set at91sam9g20 pllb driver
Message-ID: <20140901234401.1406f3c5@bbrezillon>
In-Reply-To: <1409606986-32455-1-git-send-email-gael.portay@gmail.com>
References: <1409606986-32455-1-git-send-email-gael.portay@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  1 Sep 2014 23:29:46 +0200
Gaël PORTAY <gael.portay@gmail.com> wrote:

> The at91sam9g20 SOC uses its own pllb implementation which is different
> from the one inherited from at91sam9260 SOC.
> 
> Signed-off-by: Gaël PORTAY <gael.portay@gmail.com>

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

> ---
>  arch/arm/boot/dts/at91sam9g20.dtsi | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/boot/dts/at91sam9g20.dtsi b/arch/arm/boot/dts/at91sam9g20.dtsi
> index 31f7652..4e0abbd 100644
> --- a/arch/arm/boot/dts/at91sam9g20.dtsi
> +++ b/arch/arm/boot/dts/at91sam9g20.dtsi
> @@ -40,6 +40,7 @@
>  				};
>  
>  				pllb: pllbck {
> +					compatible = "atmel,at91sam9g20-clk-pllb";
>  					atmel,clk-input-range = <2000000 32000000>;
>  					atmel,pll-clk-output-ranges = <30000000 100000000 0 0>;
>  				};



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
