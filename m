Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760485Ab3LID7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 22:59:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33824 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760352Ab3LID7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 22:59:17 -0500
Message-ID: <52A54011.909@infradead.org>
Date: Sun, 08 Dec 2013 19:59:13 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
CC: axboe@kernel.dk, akpm@linux-foundation.org, npiggin@gmail.com
Subject: Re: [PATCH 1/1] ramdisk: documentation update
References: <20131208192831.6b1ef921e4c2774cc4af5504@skynet.be>
In-Reply-To: <20131208192831.6b1ef921e4c2774cc4af5504@skynet.be>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/13 03:28, Fabian Frederick wrote:
> -ramdisk_blocksize doesn't exist anymore
> -Module parameters added to documentation
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.


> ---
>  Documentation/blockdev/ramdisk.txt | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/blockdev/ramdisk.txt b/Documentation/blockdev/ramdisk.txt
> index fa72e97..fe2ef97 100644
> --- a/Documentation/blockdev/ramdisk.txt
> +++ b/Documentation/blockdev/ramdisk.txt
> @@ -36,21 +36,30 @@ allowing one to squeeze more programs onto an average installation or
>  rescue floppy disk.
>  
>  
> -2) Kernel Command Line Parameters
> +2) Parameters
>  ---------------------------------
>  
> +2a) Kernel Command Line Parameters
> +
>  	ramdisk_size=N
>  	==============
>  
>  This parameter tells the RAM disk driver to set up RAM disks of N k size.  The
> -default is 4096 (4 MB) (8192 (8 MB) on S390).
> +default is 4096 (4 MB).
> +
> +2b) Module parameters
>  
> -	ramdisk_blocksize=N
> -	===================
> +	rd_nr
> +	=====
> +	/dev/ramX devices created.
>  
> -This parameter tells the RAM disk driver how many bytes to use per block.  The
> -default is 1024 (BLOCK_SIZE).
> +	max_part
> +	========
> +	Maximum partition number.
>  
> +	rd_size
> +	=======
> +	See ramdisk_size.
>  
>  3) Using "rdev -r"
>  ------------------
> 


-- 
~Randy
