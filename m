Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbbAYQPa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 11:15:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54661 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbbAYQPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 11:15:24 -0500
Date: Sun, 25 Jan 2015 19:41:24 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Mohamed Lotfy Hammad <mohamed.lotfy.hammad@gmail.com>
Cc: devel@driverdev.osuosl.org, gclement@baobob.org, tvboxspy@gmail.com,
        linux-kernel@vger.kernel.org, forest@alittletooquiet.net,
        joe@perches.com, silvagustavosilva@gmail.com, fred.chou.nd@gmail.com
Subject: Re: [PATCH] staging: vt6655: mac.h: fix space prohibited before that
 ','
Message-ID: <20150125114124.GA23094@kroah.com>
References: <20150119123025.GA24976@lotfy1893-Ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150119123025.GA24976@lotfy1893-Ubuntu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 02:30:25PM +0200, Mohamed Lotfy Hammad wrote:
> This patch fixes the following checkpatch.pl error:
> fix space prohibited before that ','
> 
> Signed-off-by: Mohamed Lotfy Hammad <mohamed.lotfy.hammad@gmail.com>
> Reviewed-by: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
> ---
>  drivers/staging/vt6655/mac.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/vt6655/mac.h b/drivers/staging/vt6655/mac.h
> index e1e7e10..4985c63 100644
> --- a/drivers/staging/vt6655/mac.h
> +++ b/drivers/staging/vt6655/mac.h
> @@ -888,7 +888,7 @@ do {									\
>  	VNSvOutPortB(dwIoBase + MAC_REG_PAGE1SEL, 1)
>  
>  #define MACvReadMIBCounter(dwIoBase, pdwCounter)			\
> -	VNSvInPortD(dwIoBase + MAC_REG_MIBCNTR , pdwCounter)
> +	VNSvInPortD(dwIoBase + MAC_REG_MIBCNTR, pdwCounter)
>  
>  #define MACvPwrEvntDisable(dwIoBase)					\
>  	VNSvOutPortW(dwIoBase + MAC_REG_WAKEUPEN0, 0x0000)

Doesn't apply to my staging-next branch of staging.git :(
