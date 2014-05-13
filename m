Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941AbaEMJxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:53:09 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:43459 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932920AbaEMJxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:53:05 -0400
Message-ID: <5371EB7B.1050608@atmel.com>
Date: Tue, 13 May 2014 11:52:59 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Boris Brezillon" <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH] ARM: at91/dt: sam9260: correct external trigger value
References: <1399912375-6247-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1399912375-6247-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2014 18:32, Alexandre Belloni :
> The external trigger value is 0b1101 which is 13 but 0xd.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

and pushed on our at91-3.15-fixes branch. I will try to push it for 3.15...

Thanks, bye,

> ---
>  arch/arm/boot/dts/at91sam9260.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
> index 366fc2cbcd64..c0e0eae16a27 100644
> --- a/arch/arm/boot/dts/at91sam9260.dtsi
> +++ b/arch/arm/boot/dts/at91sam9260.dtsi
> @@ -641,7 +641,7 @@
>  				trigger@3 {
>  					reg = <3>;
>  					trigger-name = "external";
> -					trigger-value = <0x13>;
> +					trigger-value = <0xd>;
>  					trigger-external;
>  				};
>  			};
> 


-- 
Nicolas Ferre
