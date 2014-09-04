Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbaIDLe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 07:34:58 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:60496 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbaIDLe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 07:34:57 -0400
Date: Thu, 4 Sep 2014 17:04:40 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Dipak Zope <dipakzope.kernel.org@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: staging: android: uapi: binder.h: Used __packed instead of
 __attribute__((packed))
Message-ID: <20140904113440.GA27239@sudip-PC>
References: <20140901124712.GA48606@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140901124712.GA48606@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 08:47:12AM -0400, Dipak Zope wrote:

you have not mentioned any commit message . 

thanks
sudip

> Signed-off-by: Dipak Zope <dipakzope.kernel.org@gmail.com>
> ---
>  drivers/staging/android/uapi/binder.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/android/uapi/binder.h b/drivers/staging/android/uapi/binder.h
> index 904adb7..dba4cef 100644
> --- a/drivers/staging/android/uapi/binder.h
> +++ b/drivers/staging/android/uapi/binder.h
> @@ -169,7 +169,7 @@ struct binder_ptr_cookie {
>  struct binder_handle_cookie {
>  	__u32 handle;
>  	binder_uintptr_t cookie;
> -} __attribute__((packed));
> +} __packed;
>  
>  struct binder_pri_desc {
>  	__s32 priority;
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
