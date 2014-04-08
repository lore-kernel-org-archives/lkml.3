Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbaDHVIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 17:08:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063AbaDHVId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 17:08:33 -0400
Date: Tue, 8 Apr 2014 14:11:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Luis Ortega <luiorpe1@gmail.com>
Cc: lisa@xenapiadmin.com, daeseok.youn@gmail.com, rashika.kheria@gmail.com,
        dan.carpenter@oracle.com, veeableful@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: bcm: Qos: fixed braces' coding style
Message-ID: <20140408211103.GA17219@kroah.com>
References: <1396998065-4448-1-git-send-email-luiorpe1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396998065-4448-1-git-send-email-luiorpe1@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 01:01:05AM +0200, Luis Ortega wrote:
> Fixed badly placed and unnecessary braces.
> 
> PS: Performed as task 10 of the Eudyptula Challenge.
> 
> Signed-off-by: Luis Ortega <luiorpe1@gmail.com>
> ---
>  drivers/staging/bcm/Qos.c | 174 +++++++++++++---------------------------------
>  1 file changed, 48 insertions(+), 126 deletions(-)
> 
> diff --git a/drivers/staging/bcm/Qos.c b/drivers/staging/bcm/Qos.c
> index 4f31583..4b9ce26 100644
> --- a/drivers/staging/bcm/Qos.c
> +++ b/drivers/staging/bcm/Qos.c
> @@ -33,14 +33,11 @@ static bool MatchSrcIpAddress(struct bcm_classifier_rule *pstClassifierRule, ULO
>  	ulSrcIP = ntohl(ulSrcIP);
>  	if (0 == pstClassifierRule->ucIPSourceAddressLength)
>  		return TRUE;
> -	for (ucLoopIndex = 0; ucLoopIndex < (pstClassifierRule->ucIPSourceAddressLength); ucLoopIndex++)
> -	{
> +	for (ucLoopIndex = 0; ucLoopIndex < (pstClassifierRule->ucIPSourceAddressLength); ucLoopIndex++) 	{

Why the <TAB> before the '{' character?

thanks,

greg k-h
