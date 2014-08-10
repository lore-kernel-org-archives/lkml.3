Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaHJMLa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 08:11:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaHJMLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 08:11:19 -0400
Date: Sat, 9 Aug 2014 21:25:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Miguel Oliveira <cmroliv@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Larry.Finger@lwfinger.net
Subject: Re: [PATCH] staging: rtl8188eu: HalPhyRf_8188e: Fix static symbol
 sparse warning
Message-ID: <20140810042549.GA20106@kroah.com>
References: <1407269028-10673-1-git-send-email-cmroliv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407269028-10673-1-git-send-email-cmroliv@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 09:03:48PM +0100, Miguel Oliveira wrote:
> Fix sparse warning:
> drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c:25:4: warning: symbol 'ODM_GetRightChnlPlaceforIQK' was not declared. Should it be static?
> by making it static since it's only used once.
> 
> Signed-off-by: Miguel Oliveira <cmroliv@gmail.com>
> ---
>  drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
> index 7fa744b..d2bcc16 100644
> --- a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
> +++ b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
> @@ -22,7 +22,7 @@
>  #define		ODM_TXPWRTRACK_MAX_IDX_88E		6
>  
>  
> -u8 ODM_GetRightChnlPlaceforIQK(u8 chnl)
> +static u8 ODM_GetRightChnlPlaceforIQK(u8 chnl)
>  {
>  	u8	channel_all[ODM_TARGET_CHNL_NUM_2G_5G] = {
>  		1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,

Someone else made this change already, always work against the
linux-next tree :(

thanks,

greg k-h
