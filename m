Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab3CSONT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:13:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40617 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab3CSONS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:13:18 -0400
Date: Tue, 19 Mar 2013 15:13:17 +0100
From: Michal Hocko <mhocko@suse.cz>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        andi@firstfloor.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        kamezawa.hiroyuki@gmail.com, hannes@cmpxchg.org, yinghan@google.com
Subject: Re: [PATCH V2 1/3]  mm: Export split_page()
Message-ID: <20130319141317.GI7869@dhcp22.suse.cz>
References: <1363639873-1576-1-git-send-email-kys@microsoft.com>
 <1363639898-1615-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363639898-1615-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 18-03-13 13:51:36, K. Y. Srinivasan wrote:
> This symbol would be used in the Hyper-V balloon driver to support 2M
> allocations.
> 
> In this version of the patch, based on feedback from Michal Hocko
> <mhocko@suse.cz>, I have updated the patch description.

I guess this part is not necessary ;)

> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Anyway
Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/page_alloc.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 6cacfee..7e0ead6 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1404,6 +1404,7 @@ void split_page(struct page *page, unsigned int order)
>  	for (i = 1; i < (1 << order); i++)
>  		set_page_refcounted(page + i);
>  }
> +EXPORT_SYMBOL_GPL(split_page);
>  
>  static int __isolate_free_page(struct page *page, unsigned int order)
>  {
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
