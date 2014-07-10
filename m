Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbaGJWLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:11:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59731 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbaGJWLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 18:11:40 -0400
Date: Thu, 10 Jul 2014 15:16:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: sanjeev sharma <sanjeevsharmaengg@gmail.com>
Cc: devel@driverdev.osuosl.org, peter.senna@gmail.com,
        linux-kernel@vger.kernel.org, rmfrfs@gmail.com, teobaluta@gmail.com,
        Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
Subject: Re: [PATCH v4 4/4] staging: rtl8192u: Fixed too long line
Message-ID: <20140710221606.GB26493@kroah.com>
References: <20140708100142.GR25934@mwanda>
 <1404995097-12689-1-git-send-email-sanjeevsharmaengg@gmail.com>
 <1404995097-12689-5-git-send-email-sanjeevsharmaengg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404995097-12689-5-git-send-email-sanjeevsharmaengg@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 05:54:57PM +0530, sanjeev sharma wrote:
> From: sanjeev sharma <sanjeev_sharma@mentor.com>
> 
> This patch will fix too long lines warning
> reported by checkpatch.pl.
> 
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
> ---
>  drivers/staging/rtl8192u/r819xU_phy.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/rtl8192u/r819xU_phy.c b/drivers/staging/rtl8192u/r819xU_phy.c
> index 3155616..b2d81e9 100644
> --- a/drivers/staging/rtl8192u/r819xU_phy.c
> +++ b/drivers/staging/rtl8192u/r819xU_phy.c
> @@ -1236,7 +1236,8 @@ static u8 rtl8192_phy_SetSwChnlCmdArray(SwChnlCmd *CmdTable, u32 CmdTableIdx,
>  		return false;
>  	}
>  	if (CmdTableIdx >= CmdTableSz) {
> -		RT_TRACE(COMP_ERR, "%s(): Access invalid index, please check size of the table, CmdTableIdx:%d, CmdTableSz:%d\n",
> +		RT_TRACE(COMP_ERR,
> +			 "%s():invalid index,CmdTableIdx:%d, CmdTableSz:%d\n",

Why did you change the string?  That's not ok, you can ignore this
warning, it's a string that you can not break up, or change.

thanks,

greg k-h
