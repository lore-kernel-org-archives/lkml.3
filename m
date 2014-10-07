Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbaJGNML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:12:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbaJGNMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:12:09 -0400
Date: Tue, 7 Oct 2014 09:11:19 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Masanari Iida <standby24x7@gmail.com>
Cc: linux-kernel@vger.kernel.org, hbabu@us.ibm.com, kexec@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kexec: Remove unnecessary KERN_ERR from kexec.c
Message-ID: <20141007131119.GA27464@redhat.com>
References: <1412654098-31847-1-git-send-email-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412654098-31847-1-git-send-email-standby24x7@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 12:54:58PM +0900, Masanari Iida wrote:
> This patch remove unnecessary KERN_ERR from pr_err() within kexec.c.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

[cc akpm]

Thanks for the fix. 

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  kernel/kexec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 2abf9f6..9a8a01a 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -600,7 +600,7 @@ kimage_file_alloc_init(struct kimage **rimage, int kernel_fd,
>  	if (!kexec_on_panic) {
>  		image->swap_page = kimage_alloc_control_pages(image, 0);
>  		if (!image->swap_page) {
> -			pr_err(KERN_ERR "Could not allocate swap buffer\n");
> +			pr_err("Could not allocate swap buffer\n");
>  			goto out_free_control_pages;
>  		}
>  	}
> -- 
> 2.1.1.273.g97b8860
