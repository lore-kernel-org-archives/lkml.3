Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab3FIHac (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 03:30:32 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:53241 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab3FIHaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 03:30:30 -0400
Date: Sun, 9 Jun 2013 07:30:29 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Rajendra Nayak <rnayak@ti.com>,
        Russ Dill <Russ.Dill@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 08/14] MAINTAINERS: fix mach-omap2
 clockdomain/powerdomain
In-Reply-To: <1362275632-20242-9-git-send-email-cesarb@cesarb.net>
Message-ID: <alpine.DEB.2.02.1306090729220.20050@utopia.booyaka.com>
References: <1362275632-20242-1-git-send-email-cesarb@cesarb.net> <1362275632-20242-9-git-send-email-cesarb@cesarb.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 2 Mar 2013, Cesar Eduardo Barros wrote:

> The code in these files was moved to cm*.[ch] and prm*.[ch] in the same
> directory by commits 4981539 (ARM: OMAP2+: powerdomain/PRM: move the
> low-level powerdomain functions into PRM) and 4bd5259 (ARM: OMAP2/3:
> clockdomain/PRM/CM: move the low-level clockdomain functions into
> PRM/CM).
> 
> I am not sure if this fix is correct, since there are other things in
> these files. Please NAK this patch (and propose a better one) if it is
> wrong.
> 
> Cc: Paul Walmsley <paul@pwsan.com>
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Russ Dill <Russ.Dill@ti.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: linux-omap@vger.kernel.org
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>

Looks like this one got lost in my inbox.  

Acked-by: Paul Walmsley <paul@pwsan.com>

(but you'll probably need to update it against a recent kernel and resend)


- Paul


> ---
>  MAINTAINERS | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 92718d8..46c1288 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5651,10 +5651,8 @@ M:	Rajendra Nayak <rnayak@ti.com>
>  M:	Paul Walmsley <paul@pwsan.com>
>  L:	linux-omap@vger.kernel.org
>  S:	Maintained
> -F:	arch/arm/mach-omap2/powerdomain2xxx_3xxx.c
> -F:	arch/arm/mach-omap2/powerdomain44xx.c
> -F:	arch/arm/mach-omap2/clockdomain2xxx_3xxx.c
> -F:	arch/arm/mach-omap2/clockdomain44xx.c
> +F:	arch/arm/mach-omap2/cm*.[ch]
> +F:	arch/arm/mach-omap2/prm*.[ch]
>  
>  OMAP AUDIO SUPPORT
>  M:	Peter Ujfalusi <peter.ujfalusi@ti.com>
> -- 
> 1.7.11.7
> 

