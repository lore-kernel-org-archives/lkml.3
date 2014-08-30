Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaH3Ulm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 16:41:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaH3Ull (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 16:41:41 -0400
Date: Sat, 30 Aug 2014 13:41:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Miguel Oliveira <cmroliv@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 4/4] staging: rtl8188eu: rtw_debug.h
Message-ID: <20140830204141.GD16168@kroah.com>
References: <1408703558-32167-1-git-send-email-cmroliv@gmail.com>
 <1408703632-32286-1-git-send-email-cmroliv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408703632-32286-1-git-send-email-cmroliv@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 11:33:52AM +0100, Miguel Oliveira wrote:
> Convert all rtw_proc_xxx references to rtw_sys_xxx in file
> include/rtw_debug.h

That's interesting, but:

> 
> Signed-off-by: Miguel Oliveira <cmroliv@gmail.com>
> ---
>  drivers/staging/rtl8188eu/include/rtw_debug.h |  227 +++++++++++--------------
>  1 file changed, 98 insertions(+), 129 deletions(-)
> 
> diff --git a/drivers/staging/rtl8188eu/include/rtw_debug.h b/drivers/staging/rtl8188eu/include/rtw_debug.h
> index a38616e..aa0f46a 100644
> --- a/drivers/staging/rtl8188eu/include/rtw_debug.h
> +++ b/drivers/staging/rtl8188eu/include/rtw_debug.h
> @@ -87,7 +87,7 @@ extern u32 GlobalDebugLevel;
>  #define MSG_88E(...)							\
>  	do {								\
>  		if (_drv_err_ <= GlobalDebugLevel)			\
> -			pr_info(DRIVER_PREFIX __VA_ARGS__);			\
> +			pr_info(DRIVER_PREFIX __VA_ARGS__);		\

How does this change relate to what you said you were going to do above?

confused,

greg k-h
