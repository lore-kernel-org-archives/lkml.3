Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab3LHDTR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 22:19:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50155 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab3LHDTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 22:19:15 -0500
Message-ID: <52A3E52F.1090303@infradead.org>
Date: Sat, 07 Dec 2013 19:19:11 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
CC: npiggin@gmail.com
Subject: Re: [PATCH 1/1] ramdisk: documentation update
References: <20131207075221.5401d0c4fdebe5515c4f1643@skynet.be>
In-Reply-To: <20131207075221.5401d0c4fdebe5515c4f1643@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/13 15:52, Fabian Frederick wrote:
> -ramdisk_blocksize doesn't exist anymore.
> -Module parameters added to documentation.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  Documentation/blockdev/ramdisk.txt | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/blockdev/ramdisk.txt b/Documentation/blockdev/ramdisk.txt
> index fa72e97..5dca7b1 100644
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
>  default is 4096 (4 MB) (8192 (8 MB) on S390).

I don't find any place that S390 changes CONFIG_BLK_DEV_RAM_SIZE from its default
of 4096 to 8192.  Did you?  If so, where please?


>  
> -	ramdisk_blocksize=N
> -	===================
> +2b) Module parameters
> +
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
> +	cf ramdisk_size.

Compare to ramdisk_size?  how about

	See ramdisk_size.
or
	Same as ramdisk_size.

>  
>  3) Using "rdev -r"
>  ------------------


As for the Changelog, it would be better just to delete all of it.
That's what git is for (and good at).


-- 
~Randy
