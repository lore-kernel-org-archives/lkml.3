Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab3GNWBp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 18:01:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:44688 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294Ab3GNWBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 18:01:44 -0400
Message-ID: <1373839281.19894.272.camel@pasglop>
Subject: Re: [PATCH] powerpc/pseries: drop "select HOTPLUG"
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Mon, 15 Jul 2013 08:01:21 +1000
In-Reply-To: <1373799735.1370.5.camel@x61.thuisdomein>
References: <1373799735.1370.5.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-07-14 at 13:02 +0200, Paul Bolle wrote:
> The Kconfig symbol HOTPLUG was removed with commit 40b313608a ("Finally
> eradicate CONFIG_HOTPLUG"). But there's still one select statement for
> that symbol. It seems that select statement was added after the patch to
> remove CONFIG_HOTPLUG was submitted. Anyhow, it is useless and can be
> dropped.

Thanks. I'll apply.

Ben.

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Not tested.
> 
>  arch/powerpc/platforms/pseries/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platforms/pseries/Kconfig
> index 1bd3399..62b4f80 100644
> --- a/arch/powerpc/platforms/pseries/Kconfig
> +++ b/arch/powerpc/platforms/pseries/Kconfig
> @@ -19,7 +19,6 @@ config PPC_PSERIES
>  	select ZLIB_DEFLATE
>  	select PPC_DOORBELL
>  	select HAVE_CONTEXT_TRACKING
> -	select HOTPLUG if SMP
>  	select HOTPLUG_CPU if SMP
>  	default y
>  


