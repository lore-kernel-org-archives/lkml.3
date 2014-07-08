Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbaGHGVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 02:21:54 -0400
Received: from router.aksignal.cz ([188.175.113.102]:57562 "EHLO
	router.aksignal.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbaGHGVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 02:21:52 -0400
X-Greylist: delayed 618 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jul 2014 02:21:52 EDT
Message-ID: <53BB8B91.8020501@aksignal.cz>
Date: Tue, 08 Jul 2014 08:11:29 +0200
From: =?UTF-8?B?SmnFmcOtIFByY2hhbA==?= <jiri.prchal@aksignal.cz>
Reply-To: jiri.prchal@aksignal.cz
Organization: AK signal Brno
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: Re: [PATCHv2 17/32] ARM: at91/dt: ge863-pro3: define crystals frequencies
References: <1404764629-29136-1-git-send-email-alexandre.belloni@free-electrons.com> <1404764629-29136-18-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1404764629-29136-18-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
the slow crystal is not on the module "ge863-pro3", but it's usually on application board. So I think this clock should 
be in board dts.

Dne 7.7.2014 22:23, Alexandre Belloni napsal(a):
> Define Telit GE863-PRO3, AK signal CDU and Telit EVK-PRO3 main and slow
> crystals frequencies.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Cc: Fabio Porcedda <fabio.porcedda@gmail.com>
> Cc: Jiri Prchal <jiri.prchal@aksignal.cz>
> ---
>   arch/arm/boot/dts/ge863-pro3.dtsi | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/arch/arm/boot/dts/ge863-pro3.dtsi b/arch/arm/boot/dts/ge863-pro3.dtsi
> index 230099bb31c8..a32fdbefbbd9 100644
> --- a/arch/arm/boot/dts/ge863-pro3.dtsi
> +++ b/arch/arm/boot/dts/ge863-pro3.dtsi
> @@ -19,6 +19,14 @@
>   			compatible = "atmel,osc", "fixed-clock";
>   			clock-frequency = <6000000>;
>   		};
> +
> +		slow_xtal {
> +			clock-frequency = <32768>;
> +		};
> +
> +		main_xtal {
> +			clock-frequency = <6000000>;
> +		};
>   	};
>
>   	ahb {
>
