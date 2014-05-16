Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbaEPIjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:39:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756385AbaEPIjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:39:14 -0400
Message-ID: <5375CEAC.60707@redhat.com>
Date: Fri, 16 May 2014 09:39:08 +0100
From: Steven Whitehouse <swhiteho@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] fs/gfs2/file.c: kernel-doc warning fixes
References: <20140515185708.c1f20b1f89e4b9aeccb31a0f@skynet.be>
In-Reply-To: <20140515185708.c1f20b1f89e4b9aeccb31a0f@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've added this patch, plus the one you sent yesterday to the GFS2 -nmw 
tree. Thanks,

Steve.

On 15/05/14 17:57, Fabian Frederick wrote:
> Related function is not gfs2_set_flags but do_gfs2_set_flags
>
> Cc: Steven Whitehouse <swhiteho@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>   fs/gfs2/file.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
> index 80d6725..768cbd4 100644
> --- a/fs/gfs2/file.c
> +++ b/fs/gfs2/file.c
> @@ -203,9 +203,9 @@ void gfs2_set_inode_flags(struct inode *inode)
>   			     GFS2_DIF_INHERIT_JDATA)
>   
>   /**
> - * gfs2_set_flags - set flags on an inode
> - * @inode: The inode
> - * @flags: The flags to set
> + * do_gfs2_set_flags - set flags on an inode
> + * @filp: file pointer
> + * @reqflags: The flags to set
>    * @mask: Indicates which flags are valid
>    *
>    */
> @@ -318,7 +318,7 @@ static long gfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>   
>   /**
>    * gfs2_size_hint - Give a hint to the size of a write request
> - * @file: The struct file
> + * @filep: The struct file
>    * @offset: The file offset of the write
>    * @size: The length of the write
>    *
> @@ -371,7 +371,7 @@ static int gfs2_allocate_page_backing(struct page *page)
>   /**
>    * gfs2_page_mkwrite - Make a shared, mmap()ed, page writable
>    * @vma: The virtual memory area
> - * @page: The page which is about to become writable
> + * @vmf: The virtual memory fault containing the page to become writable
>    *
>    * When the page becomes writable, we need to ensure that we have
>    * blocks allocated on disk to back that page.

