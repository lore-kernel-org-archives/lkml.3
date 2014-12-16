Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbaLPLkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 06:40:11 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:35897 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaLPLkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 06:40:09 -0500
Message-ID: <549019AD.9050807@ti.com>
Date: Tue, 16 Dec 2014 17:08:21 +0530
From: Lokesh Vutla <lokeshvutla@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Kristo, Tero" <t-kristo@ti.com>, Nishanth Menon <nm@ti.com>,
        Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH 1/2] ARM: omap5/dra7xx: Fix frequency typos.
References: <cover.1418421100.git.lsorense@csclub.uwaterloo.ca> <5f7d841d41f6485022e07a22c332d3c8ea985bfa.1418421100.git.lsorense@csclub.uwaterloo.ca>
In-Reply-To: <5f7d841d41f6485022e07a22c332d3c8ea985bfa.1418421100.git.lsorense@csclub.uwaterloo.ca>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,
On Saturday 13 December 2014 03:38 AM, Lennart Sorensen wrote:
> The switch statement of the possible list of SYSCLK1 frequencies is
> missing a 0 in 4 out of the 7 frequencies.
Indeed a good catch !!
Reviewed-by: Lokesh Vutla <lokeshvutla@ti.com>

Thanks and regards,
Lokesh
> 
> Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
> ---
>  arch/arm/mach-omap2/timer.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
> index 4f61148..fb0cb2b 100644
> --- a/arch/arm/mach-omap2/timer.c
> +++ b/arch/arm/mach-omap2/timer.c
> @@ -513,11 +513,11 @@ static void __init realtime_counter_init(void)
>  	rate = clk_get_rate(sys_clk);
>  	/* Numerator/denumerator values refer TRM Realtime Counter section */
>  	switch (rate) {
> -	case 1200000:
> +	case 12000000:
>  		num = 64;
>  		den = 125;
>  		break;
> -	case 1300000:
> +	case 13000000:
>  		num = 768;
>  		den = 1625;
>  		break;
> @@ -529,11 +529,11 @@ static void __init realtime_counter_init(void)
>  		num = 192;
>  		den = 625;
>  		break;
> -	case 2600000:
> +	case 26000000:
>  		num = 384;
>  		den = 1625;
>  		break;
> -	case 2700000:
> +	case 27000000:
>  		num = 256;
>  		den = 1125;
>  		break;
> 

