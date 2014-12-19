Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbaLSPUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 10:20:18 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:41998 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaLSPUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 10:20:17 -0500
Date: Fri, 19 Dec 2014 07:20:13 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: ssfdc: Fix space before ( coding style
Message-ID: <20141219152013.GA2046@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Mohammad Jamal <md.jamalmohiuddin@gmail.com>, dwmw2@infradead.org,
	computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
	linux-kernel@vger.kernel.org
References: <1418999413-29428-1-git-send-email-md.jamalmohiuddin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418999413-29428-1-git-send-email-md.jamalmohiuddin@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mohammad,

On Fri, Dec 19, 2014 at 08:00:13PM +0530, Mohammad Jamal wrote:
> Patch solves the space before ( coding style issue of ssfdc.c
> 
> Signed-off-by: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
> ---
>  drivers/mtd/ssfdc.c |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/mtd/ssfdc.c b/drivers/mtd/ssfdc.c
> index daf82ba..d4a922c 100644
> --- a/drivers/mtd/ssfdc.c
> +++ b/drivers/mtd/ssfdc.c
> @@ -42,8 +42,8 @@ struct ssfdcr_record {
>  #define MAX_LOGIC_BLK_PER_ZONE	1000
>  #define MAX_PHYS_BLK_PER_ZONE	1024
>  
> -#define KiB(x)	( (x) * 1024L )
> -#define MiB(x)	( KiB(x) * 1024L )
> +#define KiB(x)	((x) * 1024L)
> +#define MiB(x)	(KiB(x) * 1024L)
This looks better than before.

>  
>  /** CHS Table
>  		1MiB	2MiB	4MiB	8MiB	16MiB	32MiB	64MiB	128MiB
> @@ -63,13 +63,13 @@ typedef struct {
>  
>  /* Must be ordered by size */
>  static const chs_entry_t chs_table[] = {
> -	{ MiB(  1), 125,  4,  4 },
> -	{ MiB(  2), 125,  4,  8 },
> -	{ MiB(  4), 250,  4,  8 },
> -	{ MiB(  8), 250,  4, 16 },
> -	{ MiB( 16), 500,  4, 16 },
> -	{ MiB( 32), 500,  8, 16 },
> -	{ MiB( 64), 500,  8, 32 },
> +	{ MiB(1), 125,  4,  4 },
> +	{ MiB(2), 125,  4,  8 },
> +	{ MiB(4), 250,  4,  8 },
> +	{ MiB(8), 250,  4, 16 },
> +	{ MiB(16), 500,  4, 16 },
> +	{ MiB(32), 500,  8, 16 },
> +	{ MiB(64), 500,  8, 32 },
>  	{ MiB(128), 500, 16, 32 },
>  	{ 0 },
>  };
I like the original version better here.  The columns were lined up
nicely and it was easier to read.

-- 
- Jeremiah Mahler
