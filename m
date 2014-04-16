Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161596AbaDPOoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:44:22 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:24890 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161145AbaDPOoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:44:21 -0400
Date: Wed, 16 Apr 2014 17:44:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Seunghun Lee <waydi1@gmail.com>
Cc: greg@kroah.com, devel@driverdev.osuosl.org, swetland@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging : android : uapi : fix coding style
Message-ID: <20140416144404.GR26890@mwanda>
References: <1397658459-4357-1-git-send-email-waydi1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397658459-4357-1-git-send-email-waydi1@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject is not correct format.  Should be:

[PATCH] staging: android: uapi: fix coding style

On Wed, Apr 16, 2014 at 11:27:39PM +0900, Seunghun Lee wrote:
> This patch fix checkpatch.pl warnings and errors.
> 

Patch does too many things at once.  Split it up.

> Signed-off-by: Seunghun Lee <waydi1@gmail.com>
> ---
>  drivers/staging/android/uapi/binder.h |    2 +-
>  drivers/staging/android/uapi/ion.h    |   20 +++++++++-----------
>  2 files changed, 10 insertions(+), 12 deletions(-)
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
> diff --git a/drivers/staging/android/uapi/ion.h b/drivers/staging/android/uapi/ion.h
> index f09e7c1..36332dc 100644
> --- a/drivers/staging/android/uapi/ion.h
> +++ b/drivers/staging/android/uapi/ion.h
> @@ -20,19 +20,17 @@
>  #include <linux/ioctl.h>
>  #include <linux/types.h>
>  
> -typedef int ion_user_handle_t;

This typedef is probably a valid use.  Plus it looks to be part of the
user space API.  Just leave it alone.

regards,
dan carpenter

