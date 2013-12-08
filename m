Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502Ab3LHRTG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 12:19:06 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56353 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab3LHRTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 12:19:03 -0500
Message-ID: <52A4AA04.6040507@infradead.org>
Date: Sun, 08 Dec 2013 09:19:00 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
CC: npiggin@gmail.com, axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] RAM block device support module name update in Kconfig
References: <20131206213845.c2fc58a65acd990b97794414@skynet.be>
In-Reply-To: <20131206213845.c2fc58a65acd990b97794414@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/13 05:38, Fabian Frederick wrote:
> RAM block device support module name changed to brd.ko 
> some years ago with an "rd" alias to match previous module implementation.
> This patch updates its Kconfig definition.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

I haven't seen any activity from Nick lately.
Let's Cc: Jens and Andrew.

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  drivers/block/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
> index 86b9f37..9ffa90c 100644
> --- a/drivers/block/Kconfig
> +++ b/drivers/block/Kconfig
> @@ -368,7 +368,8 @@ config BLK_DEV_RAM
>  	  For details, read <file:Documentation/blockdev/ramdisk.txt>.
>  
>  	  To compile this driver as a module, choose M here: the
> -	  module will be called rd.
> +	  module will be called brd. An alias "rd" has been defined
> +	  for historical reasons.
>  
>  	  Most normal users won't need the RAM disk functionality, and can
>  	  thus say N here.
> --



-- 
~Randy
