Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbaBQH6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 02:58:14 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:43611 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750903AbaBQH6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 02:58:13 -0500
Message-ID: <5301C0D2.8040408@st.com>
Date: Mon, 17 Feb 2014 08:57:06 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: Richard Weinberger <richard@nod.at>, <kernel@stlinux.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm: sti: Remove SOC_STIH415 and SOC_STIH416
References: <1392577524.28866.32.camel@x220>
In-Reply-To: <1392577524.28866.32.camel@x220>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 02/16/2014 08:05 PM, Paul Bolle wrote:
> The Kconfig symbols SOC_STIH415 and SOC_STIH416 were added in v3.11.
> They have never been used. They default to "y" but nothing cares. They
> can safely be removed.

This is going to be used by the reset controller series from Srinivas:
http://marc.info/?l=linux-arm-kernel&m=139143833415806&w=2

Regards,
Maxime

>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Tested with "git grep".
>
>   arch/arm/mach-sti/Kconfig | 23 -----------------------
>   1 file changed, 23 deletions(-)
>
> diff --git a/arch/arm/mach-sti/Kconfig b/arch/arm/mach-sti/Kconfig
> index d71654b..c360ae1 100644
> --- a/arch/arm/mach-sti/Kconfig
> +++ b/arch/arm/mach-sti/Kconfig
> @@ -21,26 +21,3 @@ menuconfig ARCH_STI
>   	  for discovery
>   	  More information at Documentation/arm/STiH41x and
>   	  at Documentation/devicetree
> -
> -
> -if ARCH_STI
> -
> -config SOC_STIH415
> -	bool "STiH415 STMicroelectronics Consumer Electronics family"
> -	default y
> -	help
> -	  This enables support for STMicroelectronics Digital Consumer
> -	  Electronics family StiH415 parts, primarily targeted at set-top-box
> -	  and other digital audio/video applications using Flattned Device
> -	  Trees.
> -
> -config SOC_STIH416
> -	bool "STiH416 STMicroelectronics Consumer Electronics family"
> -	default y
> -	help
> -	  This enables support for STMicroelectronics Digital Consumer
> -	  Electronics family StiH416 parts, primarily targeted at set-top-box
> -	  and other digital audio/video applications using Flattened Device
> -	  Trees.
> -
> -endif
>
