Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbaKJGIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 01:08:13 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:42109 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751184AbaKJGIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 01:08:11 -0500
X-Sasl-enc: 8AnugmPAMVqsuf0C2zPdUE0VAGfaj1QggEM34C/NMPwl 1415599688
Date: Mon, 10 Nov 2014 14:58:05 +0900
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pratik Patel <pratikp@codeaurora.org>
Subject: Re: linux-next: manual merge of the char-misc tree with the staging
 tree
Message-ID: <20141110055805.GA28761@kroah.com>
References: <20141110165316.5c122b47@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110165316.5c122b47@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 04:53:16PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the char-misc tree got a conflict in
> drivers/Makefile between commit 777783e0abae ("staging: android:
> binder: move to the "real" part of the kernel") from the staging tree and
> commit a06ae8609b3d ("coresight: add CoreSight core layer framework")
> from the char-misc tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/Makefile
> index 60d19820a4d4,628b512b625b..000000000000
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@@ -161,4 -161,4 +161,5 @@@ obj-$(CONFIG_POWERCAP)		+= powercap
>   obj-$(CONFIG_MCB)		+= mcb/
>   obj-$(CONFIG_RAS)		+= ras/
>   obj-$(CONFIG_THUNDERBOLT)	+= thunderbolt/
>  +obj-$(CONFIG_ANDROID)		+= android/
> + obj-$(CONFIG_CORESIGHT)		+= coresight/


Looks good, thanks.

greg k-h
