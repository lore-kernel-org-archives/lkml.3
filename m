Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760416Ab3LIGSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 01:18:16 -0500
Received: from gate.crashing.org ([63.228.1.57]:55328 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078Ab3LIGSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 01:18:15 -0500
Message-ID: <1386569840.5159.40.camel@pasglop>
Subject: Re: [PATCH][RESEND] powerpc: remove unused REDBOOT Kconfig parameter
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: paulus@samba.org, galak@kernel.crashing.org, vitb@kernel.crashing.org,
        marcelo@kvack.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Mon, 09 Dec 2013 17:17:20 +1100
In-Reply-To: <1386566860-19785-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1383554336-3829-1-git-send-email-michael.opdenacker@free-electrons.com>
	 <1386566860-19785-1-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-09 at 06:27 +0100, Michael Opdenacker wrote:
> This removes the REDBOOT Kconfig parameter,
> which was no longer used anywhere in the source code
> and Makefiles.

It hasn't been lost :-) It's still in patchwork and it's even in my
queue.

Cheers,
Ben.

> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  arch/powerpc/Kconfig                | 3 ---
>  arch/powerpc/platforms/83xx/Kconfig | 1 -
>  arch/powerpc/platforms/8xx/Kconfig  | 1 -
>  3 files changed, 5 deletions(-)
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index b44b52c0a8f0..70dc283050b5 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -209,9 +209,6 @@ config DEFAULT_UIMAGE
>  	  Used to allow a board to specify it wants a uImage built by default
>  	default n
>  
> -config REDBOOT
> -	bool
> -
>  config ARCH_HIBERNATION_POSSIBLE
>  	bool
>  	default y
> diff --git a/arch/powerpc/platforms/83xx/Kconfig b/arch/powerpc/platforms/83xx/Kconfig
> index 670a033264c0..2bdc8c862c46 100644
> --- a/arch/powerpc/platforms/83xx/Kconfig
> +++ b/arch/powerpc/platforms/83xx/Kconfig
> @@ -99,7 +99,6 @@ config SBC834x
>  config ASP834x
>  	bool "Analogue & Micro ASP 834x"
>  	select PPC_MPC834x
> -	select REDBOOT
>  	help
>  	  This enables support for the Analogue & Micro ASP 83xx
>  	  board.
> diff --git a/arch/powerpc/platforms/8xx/Kconfig b/arch/powerpc/platforms/8xx/Kconfig
> index 8dec3c0911ad..bd6f1a1cf922 100644
> --- a/arch/powerpc/platforms/8xx/Kconfig
> +++ b/arch/powerpc/platforms/8xx/Kconfig
> @@ -45,7 +45,6 @@ config PPC_EP88XC
>  config PPC_ADDER875
>  	bool "Analogue & Micro Adder 875"
>  	select CPM1
> -	select REDBOOT
>  	help
>  	  This enables support for the Analogue & Micro Adder 875
>  	  board.


