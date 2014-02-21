Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbaBUMfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:35:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbaBUMfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:35:05 -0500
Date: Fri, 21 Feb 2014 09:34:56 -0300
From: Rafael Aquini <aquini@redhat.com>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, riel@redhat.com,
        akpm@linux-foundation.org, james.leddy@redhat.com
Subject: Re: [PATCH] fs/proc/meminfo: meminfo_proc_show(): fix typo in comment
Message-ID: <20140221123456.GB10170@localhost.localdomain>
References: <20140218170027.00bcf592@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218170027.00bcf592@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 05:00:27PM -0500, Luiz Capitulino wrote:
> It should read "reclaimable slab" and not "reclaimable swap".
> 
> Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
> ---
>  fs/proc/meminfo.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
> index 136e548..7445af0 100644
> --- a/fs/proc/meminfo.c
> +++ b/fs/proc/meminfo.c
> @@ -73,7 +73,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>  	available += pagecache;
>  
>  	/*
> -	 * Part of the reclaimable swap consists of items that are in use,
> +	 * Part of the reclaimable slab consists of items that are in use,
>  	 * and cannot be freed. Cap this estimate at the low watermark.
>  	 */
>  	available += global_page_state(NR_SLAB_RECLAIMABLE) -
> -- 
> 1.8.1.4

Acked-by: Rafael Aquini <aquini@redhat.com>

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
