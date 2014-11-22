Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaKVTCg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 14:02:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbaKVTCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 14:02:35 -0500
Date: Sat, 22 Nov 2014 11:01:12 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: sunwxg <sun.wxg@gmail.com>
Cc: Peng Tao <bergwolf@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:lustre:lnet:lnet Function must be static
Message-ID: <20141122190112.GA29470@kroah.com>
References: <1416144284-31138-2-git-send-email-sun.wxg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416144284-31138-2-git-send-email-sun.wxg@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2014 at 09:24:44PM +0800, sunwxg wrote:
> From: Sun Wang <sun.wxg@gmail.com>
> 
> Function must be static if function will not be used in other files.
> 
> Signed-off-by: Sun Wang <sun.wxg@gmail.com>
> 
> ---
>  drivers/staging/lustre/lnet/lnet/{module.c.org => module.c} | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/lustre/lnet/lnet/module.c.org b/drivers/staging/lustre/lnet/lnet/module.c
> index e84d59d..4ca7b1d 100644
> --- a/drivers/staging/lustre/lnet/lnet/module.c.org
> +++ b/drivers/staging/lustre/lnet/lnet/module.c
> @@ -43,7 +43,7 @@ MODULE_PARM_DESC(config_on_load, "configure network at module load");
>  
>  static struct mutex lnet_config_mutex;
>  
> -int
> +static int
>  lnet_configure(void *arg)
>  {
>  	/* 'arg' only there so I can be passed to cfs_create_thread() */

Does not apply :(
