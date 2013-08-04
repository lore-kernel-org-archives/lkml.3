Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab3HDS4w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 14:56:52 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:40413 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab3HDS4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 14:56:50 -0400
Date: Sun, 4 Aug 2013 21:56:41 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Kumar Gaurav <kumargauravgupta3@gmail.com>
Cc: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        dan.carpenter@oracle.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Staging:xgifb:Fixed a warning of Space before semicolon
Message-ID: <20130804185630.GC29933@blackmetal.musicnaut.iki.fi>
References: <1375641662-17378-1-git-send-email-kumargauravgupta3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375641662-17378-1-git-send-email-kumargauravgupta3@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 12:11:02AM +0530, Kumar Gaurav wrote:
> Fixed issue by removing Space before semicolon
> 
> Signed-off-by: Kumar Gaurav <kumargauravgupta3@gmail.com>
> ---
>  drivers/staging/xgifb/vb_setmode.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/xgifb/vb_setmode.h b/drivers/staging/xgifb/vb_setmode.h
> index 2c0a31c..679a822 100644
> --- a/drivers/staging/xgifb/vb_setmode.h
> +++ b/drivers/staging/xgifb/vb_setmode.h
> @@ -13,7 +13,7 @@ extern void XGI_GetVBType(struct vb_device_info *);
>  extern void XGI_SenseCRT1(struct vb_device_info *);
>  extern unsigned char XGISetModeNew(struct xgifb_video_info *xgifb_info,
>  				   struct xgi_hw_device_info *HwDeviceExtension,
> -				   unsigned short ModeNo) ;
> +				   unsigned short ModeNo);

There's a similar issue in vb_table.h, line 1287. Maybe fix that also
at the same time?

Thanks,

A.
