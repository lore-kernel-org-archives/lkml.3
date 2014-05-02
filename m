Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaEBRjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 13:39:45 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:57714 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbaEBRjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 13:39:44 -0400
Message-ID: <5363D860.30104@kernel.dk>
Date: Fri, 02 May 2014 11:39:44 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] block/blk-core.c: convert printk to pr_foo()
References: <20140502184911.61e6207c63864476bd06570a@skynet.be>
In-Reply-To: <20140502184911.61e6207c63864476bd06570a@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2014 10:49 AM, Fabian Frederick wrote:
> -Convert all printk,print_ratelimited ...
> -Define debug to have pr_debug emitted
> -Fix checkpatch warning: Lu->llu
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  block/blk-core.c | 60 +++++++++++++++++++++++++++-----------------------------
>  1 file changed, 29 insertions(+), 31 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index a0e3096..5c544fa 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -11,6 +11,7 @@
>  /*
>   * This handles all read/write requests to block devices
>   */
> +#define DEBUG
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/backing-dev.h>

That's a mess.

-- 
Jens Axboe

