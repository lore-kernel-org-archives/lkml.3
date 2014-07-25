Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761094AbaGYTvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 15:51:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:49047 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760948AbaGYTvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 15:51:38 -0400
Message-ID: <53D2B547.5080607@infradead.org>
Date: Fri, 25 Jul 2014 12:51:35 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Raymond L. Rivera" <ray.l.rivera@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH 2/2] linux/pagemap.h: Fixed a typo in a code comment.
References: <1406194785-19596-1-git-send-email-ray.l.rivera@gmail.com> <1406194785-19596-3-git-send-email-ray.l.rivera@gmail.com>
In-Reply-To: <1406194785-19596-3-git-send-email-ray.l.rivera@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/14 02:39, Raymond L. Rivera wrote:
> Corrected a minor typo in a code comment where 'be' was missing.
> 
> Signed-off-by: Raymond L. Rivera <ray.l.rivera@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  include/linux/pagemap.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 0a97b58..bcabdbe 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -96,7 +96,7 @@ static inline void mapping_set_gfp_mask(struct address_space *m, gfp_t mask)
>  }
>  
>  /*
> - * The page cache can done in larger chunks than
> + * The page cache can be done in larger chunks than
>   * one page, because it allows for more efficient
>   * throughput (it can then be mapped into user
>   * space in smaller chunks for same flexibility).
> 


-- 
~Randy
