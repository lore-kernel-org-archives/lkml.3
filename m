Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbaGJWLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:11:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59728 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaGJWK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 18:10:58 -0400
Date: Thu, 10 Jul 2014 15:15:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: sanjeev sharma <sanjeevsharmaengg@gmail.com>
Cc: devel@driverdev.osuosl.org, peter.senna@gmail.com,
        linux-kernel@vger.kernel.org, rmfrfs@gmail.com, teobaluta@gmail.com,
        Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
Subject: Re: [PATCH v4 2/4] staging: rtl8192u: Removed unnecessary whitespace
 & tab warning
Message-ID: <20140710221524.GA26493@kroah.com>
References: <20140708100142.GR25934@mwanda>
 <1404995097-12689-1-git-send-email-sanjeevsharmaengg@gmail.com>
 <1404995097-12689-3-git-send-email-sanjeevsharmaengg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404995097-12689-3-git-send-email-sanjeevsharmaengg@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 05:54:55PM +0530, sanjeev sharma wrote:
> From: sanjeev sharma <sanjeev_sharma@mentor.com>
> 
> This patch will remove whitespace and tabs reported by
> checkpatch.pl script.
> 
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
> ---
>  drivers/staging/rtl8192u/r819xU_phy.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/staging/rtl8192u/r819xU_phy.c b/drivers/staging/rtl8192u/r819xU_phy.c
> index 0bcdd4e..0fcb673 100644
> --- a/drivers/staging/rtl8192u/r819xU_phy.c
> +++ b/drivers/staging/rtl8192u/r819xU_phy.c
> @@ -106,10 +106,10 @@ void rtl8192_setBBreg(struct net_device *dev, u32 reg_addr, u32 bitmask,
>  /******************************************************************************
>   * function:  This function reads specific bits from BB register
>   * input:     net_device	*dev
> - *            u32	 	reg_addr   //target addr to be readback
> - *            u32	 	bitmask    //taget bit pos to be readback
> - * output:    none
> - * return:    u32	 	data       //the readback register value
> + * u32		reg_addr   //target addr to be readback
> + * u32		bitmask    //taget bit pos to be readback
> + * output:	none
> + * return:	u32		data       //the readback register value
>   * notice:
>   ******************************************************************************/
>  u32 rtl8192_QueryBBReg(struct net_device *dev, u32 reg_addr, u32 bitmask)

That doesn't look like you cleaned it up well, it now looks worse.
Please keep the proper indentation of the variables.  It's not the
"proper" kernel coding style, but don't make code worse, like you did
here :(

greg k-h
