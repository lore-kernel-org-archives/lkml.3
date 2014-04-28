Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbaD1ILx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 04:11:53 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:35450 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaD1ILu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 04:11:50 -0400
Date: Mon, 28 Apr 2014 10:11:45 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] s390: add slab.h for kzalloc/kfree
Message-ID: <20140428081145.GB4337@osiris>
References: <535D782F.3020801@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535D782F.3020801@suse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042808-0342-0000-0000-000008942CD7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 05:35:43PM -0400, Jeff Mahoney wrote:
> This fixes:
> arch/s390/appldata/appldata_mem.c:135:2: error: implicit declaration of function 'kzalloc' [-Werror=implicit-function-declaration]
> arch/s390/appldata/appldata_mem.c:141:3: error: implicit declaration of function 'kfree' [-Werror=implicit-function-declaration]
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  arch/s390/appldata/appldata_mem.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/arch/s390/appldata/appldata_mem.c
> +++ b/arch/s390/appldata/appldata_mem.c
> @@ -13,6 +13,7 @@
>  #include <linux/kernel_stat.h>
>  #include <linux/pagemap.h>
>  #include <linux/swap.h>
> +#include <linux/slab.h>
>  #include <asm/io.h>

Applied, thanks.

