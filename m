Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab3GOIu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 04:50:26 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:50634 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab3GOIuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 04:50:25 -0400
Message-ID: <51E3B6FB.7040002@linux.vnet.ibm.com>
Date: Mon, 15 Jul 2013 14:16:51 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/pseries: drop "select HOTPLUG"
References: <1373799735.1370.5.camel@x61.thuisdomein>
In-Reply-To: <1373799735.1370.5.camel@x61.thuisdomein>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071508-8878-0000-0000-000007F30485
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2013 04:32 PM, Paul Bolle wrote:
> The Kconfig symbol HOTPLUG was removed with commit 40b313608a ("Finally
> eradicate CONFIG_HOTPLUG"). But there's still one select statement for
> that symbol. It seems that select statement was added after the patch to
> remove CONFIG_HOTPLUG was submitted. Anyhow, it is useless and can be
> dropped.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

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

Regards,
Srivatsa S. Bhat

