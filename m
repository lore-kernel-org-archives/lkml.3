Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaBIVEJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 16:04:09 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:61652 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687AbaBIVEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 16:04:08 -0500
Message-ID: <1391979846.25855.42.camel@x220>
Subject: Re: [PATCH 17/28] Remove USE_GENERIC_SMP_HELPERS
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        "open list:TENSILICA XTENSA..." <linux-xtensa@linux-xtensa.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Sun, 09 Feb 2014 22:04:06 +0100
In-Reply-To: <1391971686-9517-18-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-18-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 21:04:06.0772 (UTC) FILETIME=[7841F340:01CF25DA]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
> The symbol is an orphan, get rid of it.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/xtensa/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
> index ba56e11..c1d69ba 100644
> --- a/arch/xtensa/Kconfig
> +++ b/arch/xtensa/Kconfig
> @@ -135,7 +135,6 @@ config HAVE_SMP
>  config SMP
>  	bool "Enable Symmetric multi-processing support"
>  	depends on HAVE_SMP
> -	select USE_GENERIC_SMP_HELPERS
>  	select GENERIC_SMP_IDLE_THREAD
>  	help
>  	  Enabled SMP Software; allows more than one CPU/CORE

I sent an identical patch (with a more verbose explanation) a few hours
ago. But this one is OK too.


Paul Bolle

