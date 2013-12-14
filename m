Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab3LNPAZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 10:00:25 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:48951 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751407Ab3LNPAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 10:00:23 -0500
Date: Sat, 14 Dec 2013 15:00:17 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Matt Fleming <matt.fleming@intel.com>, Jens Axboe <axboe@kernel.dk>,
        Matt Domsch <Matt_Domsch@dell.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add myself as gpt maintainer
Message-ID: <20131214150017.GC18640@console-pimps.org>
References: <1386957929.2867.6.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386957929.2867.6.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Dec, at 10:05:29AM, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <davidlohr@hp.com>
> 
> Add a new entry for the GPT standard. Any future changes will now be routed
> through linux-efi.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matt Fleming <matt.fleming@intel.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Matt Domsch <Matt_Domsch@dell.com>
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> ---
> This was discussed offline and both Matts are fine with me maintaining this.
> 
>  MAINTAINERS | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4afcfb4..cf41aa5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3834,6 +3834,12 @@ T:	git git://linuxtv.org/media_tree.git
>  S:	Maintained
>  F:	drivers/media/usb/gspca/
>  
> +GUID PARTITION TABLE (GPT)
> +M:	Davidlohr Bueso <davidlohr@hp.com>
> +L:	linux-efi@vger.kernel.org
> +S:	Maintained
> +F:	block/partitions/efi.*
> +

Acked-by: Matt Fleming <matt.fleming@intel.com>

I'm happy to take this through the EFI tree unless Andrew or Jens wants
to take it?

-- 
Matt Fleming, Intel Open Source Technology Center
