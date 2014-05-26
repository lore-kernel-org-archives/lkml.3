Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628AbaEZHWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 03:22:42 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35357 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751547AbaEZHWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 03:22:41 -0400
Date: Mon, 26 May 2014 09:22:37 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiubo Li <Li.Xiubo@freescale.com>
Subject: Re: linux-next: build failure after merge of the devicetree tree
Message-ID: <20140526092237.24631389@free-electrons.com>
In-Reply-To: <20140526150557.219ea08f@canb.auug.org.au>
References: <20140526150557.219ea08f@canb.auug.org.au>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Stephen Rothwell,

On Mon, 26 May 2014 15:05:57 +1000, Stephen Rothwell wrote:

> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 395ee2b3146d..03e7fc6c93e8 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -1901,10 +1901,6 @@ int of_update_property(struct device_node *np, struct property *newprop)
>  	if (!of_kset)
>  		return 0;
>  
> -	/* At early boot, bail out and defer setup to of_init() */
> -	if (!of_kset)
> -		return found ? 0 : -ENODEV;
> -

Seems like this is in fact reverting my change entirely, so maybe Grant
should drop my patch instead?

Thanks,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
