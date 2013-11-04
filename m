Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab3KDJFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 04:05:53 -0500
Received: from top.free-electrons.com ([176.31.233.9]:33014 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752209Ab3KDJFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 04:05:51 -0500
Message-ID: <5277636D.8050204@free-electrons.com>
Date: Mon, 04 Nov 2013 10:05:49 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: linux@arm.linux.org.uk
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: Re: [PATCH] ARM: iop3xx: remove unused MACH_EP80219 Kconfig parameter
References: <1383555042-4135-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1383555042-4135-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2013 09:50 AM, Michael Opdenacker wrote:
> This removes the MACH_EP80219 Kconfig parameter,
> which was no longer used anywhere in the source code
> and Makefiles.
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  arch/arm/mach-iop32x/Kconfig | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/arch/arm/mach-iop32x/Kconfig b/arch/arm/mach-iop32x/Kconfig
> index 5e8c6f7dfabb..65f3500258e5 100644
> --- a/arch/arm/mach-iop32x/Kconfig
> +++ b/arch/arm/mach-iop32x/Kconfig
> @@ -4,9 +4,6 @@ menu "IOP32x Implementation Options"
>  
>  comment "IOP32x Platform Types"
>  
> -config MACH_EP80219
> -	bool
> -
>  config MACH_GLANTANK
>  	bool "Enable support for the IO-Data GLAN Tank"
>  	help
> @@ -22,7 +19,6 @@ config ARCH_IQ80321
>  
>  config ARCH_IQ31244
>  	bool "Enable support for EP80219/IQ31244"
> -	select MACH_EP80219
>  	help
>  	  Say Y here if you want to run your kernel on the Intel EP80219
>  	  evaluation kit for the Intel 80219 processor (a IOP321 variant)
Actually, in another thread, Sascha Hauer made me realize that this
symbol is actually used to make machine_is_ep80219() become true when
the kernel is started with the corresponding machine id.

Let's drop this patch.

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

