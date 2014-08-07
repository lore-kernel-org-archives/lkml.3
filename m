Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550AbaHGQDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:03:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45745 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbaHGQDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:03:13 -0400
Date: Thu, 7 Aug 2014 09:03:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sanjeev Sharma <sanjeev_sharma@mentor.com>
Cc: devel@driverdev.osuosl.org, oort10@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:r819xU: coding style: Fixed commenting style
Message-ID: <20140807160312.GA8014@kroah.com>
References: <1407393957-27948-1-git-send-email-sanjeev_sharma@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407393957-27948-1-git-send-email-sanjeev_sharma@mentor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 12:15:57PM +0530, Sanjeev Sharma wrote:
> This is a patch to the r819xU_phyreg.h file that fixes
> commenting style warning
> 
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
> ---
>  drivers/staging/rtl8192u/r819xU_phyreg.h | 188 ++++++++++++++++---------------
>  1 file changed, 97 insertions(+), 91 deletions(-)
> 
> diff --git a/drivers/staging/rtl8192u/r819xU_phyreg.h b/drivers/staging/rtl8192u/r819xU_phyreg.h
> index 64285d6..f07d2f1 100644
> --- a/drivers/staging/rtl8192u/r819xU_phyreg.h
> +++ b/drivers/staging/rtl8192u/r819xU_phyreg.h
> @@ -2,10 +2,10 @@
>  #define _R819XU_PHYREG_H
>  
>  
> -#define   RF_DATA				0x1d4					// FW will write RF data in the register.
> +#define   RF_DATA				0x1d4					/* FW will write RF data in the register.*/
>  
> -//Register   //duplicate register due to connection: RF_Mode, TRxRN, NumOf L-STF
> -//page 1
> +/* Register   //duplicate register due to connection: RF_Mode, TRxRN, NumOf L-STF */

Does that line look correct?

