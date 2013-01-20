Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab3ATX7v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 18:59:51 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:59477 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab3ATX7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 18:59:49 -0500
Date: Sun, 20 Jan 2013 15:59:45 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jake Champlin <jake.champlin.27@gmail.com>
Cc: devel@driverdev.osuosl.org, sjenning@linux.vnet.ibm.com,
        dan.magenheimer@oracle.com, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com
Subject: Re: [PATCH] Staging: ramster: zcache-main: Fixed Bracing Issues
Message-ID: <20130120235945.GA29683@kroah.com>
References: <20130119040950.GA18812@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130119040950.GA18812@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 11:09:56PM -0500, Jake Champlin wrote:
> Fixed Coding Style Bracing Issues
> 
> Signed-off-by: Jake Champlin <jake.champlin.27@gmail.com>
> ---
>  drivers/staging/ramster/zcache-main.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/ramster/zcache-main.c b/drivers/staging/ramster/zcache-main.c
> index a09dd5c..2613889 100644
> --- a/drivers/staging/ramster/zcache-main.c
> +++ b/drivers/staging/ramster/zcache-main.c
> @@ -478,6 +478,7 @@ static void zcache_free_page(struct page *page)
>  #ifdef ZCACHE_DEBUG
>  	if (curr_pageframes > 2L || curr_pageframes < -2L) {
>  		/* pr_info here */
> +		/* unnecessary comment */
>  	}
>  #endif
>  }

That doesn't look like it is fixing any coding style issues, you just
added a comment for no reason?

I understand it will shut checkpatch.pl up, but be reasonable here
please, it's a tool to be used as a guideline, use your judgement
please.

greg k-h
