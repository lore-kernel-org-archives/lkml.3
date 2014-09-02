Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbaIBRw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:52:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbaIBRw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:52:56 -0400
Date: Tue, 2 Sep 2014 10:52:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dipak Zope <dipakzope.kernel.org@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: staging: android: uapi: binder.h: Used __packed instead of
 __attribute__((packed))
Message-ID: <20140902175255.GA9582@kroah.com>
References: <20140901124712.GA48606@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140901124712.GA48606@localhost.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 08:47:12AM -0400, Dipak Zope wrote:
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

This is already in my tree, what branch are you working off of here?

thanks,

greg k-h
