Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbaAPNx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:53:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbaAPNxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:53:22 -0500
Message-ID: <52D7E41A.1060408@redhat.com>
Date: Thu, 16 Jan 2014 14:52:26 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 7/8] zram: drop not used table `count' member
References: <1389877936-15543-1-git-send-email-sergey.senozhatsky@gmail.com> <1389877936-15543-8-git-send-email-sergey.senozhatsky@gmail.com>
In-Reply-To: <1389877936-15543-8-git-send-email-sergey.senozhatsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 02:12 PM, Sergey Senozhatsky wrote:
> struct table `count' member is not used.

What was the intended use of this counter anyway?

> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> ---
>  drivers/block/zram/zram_drv.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
> index 58d4ac5..1d5b1f5 100644
> --- a/drivers/block/zram/zram_drv.h
> +++ b/drivers/block/zram/zram_drv.h
> @@ -64,7 +64,6 @@ enum zram_pageflags {
>  struct table {
>  	unsigned long handle;
>  	u16 size;	/* object size (excluding header) */
> -	u8 count;	/* object ref count (not yet used) */
>  	u8 flags;

I noticed that your earlier version of this patch changed the
flags size to 16. What has changed?

Jerome

>  } __aligned(4);
>  
> 

