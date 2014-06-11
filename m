Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbaFKE6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 00:58:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbaFKE6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 00:58:16 -0400
Date: Tue, 10 Jun 2014 21:58:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: A Raghavendra Rao <raghav3276@gmail.com>
Cc: devel@driverdev.osuosl.org, A Raghavendra Rao <arrao@cdac.in>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8192e: dot11d: Fixed printk coding style
 issues
Message-ID: <20140611045810.GA24357@kroah.com>
References: <1402461715-15317-1-git-send-email-arrao@cdac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402461715-15317-1-git-send-email-arrao@cdac.in>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 10:11:55AM +0530, A Raghavendra Rao wrote:
> Replaced 'printk' with 'netdev_' function
> 
> Signed-off-by: A Raghavendra Rao <arrao@cdac.in>
> ---
>  drivers/staging/rtl8192e/dot11d.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/rtl8192e/dot11d.c b/drivers/staging/rtl8192e/dot11d.c
> index 53da610..ef9da86 100644
> --- a/drivers/staging/rtl8192e/dot11d.c
> +++ b/drivers/staging/rtl8192e/dot11d.c
> @@ -49,6 +49,7 @@ static struct channel_list ChannelPlan[] = {
>  void dot11d_init(struct rtllib_device *ieee)
>  {
>  	struct rt_dot11d_info *pDot11dInfo = GET_DOT11D_INFO(ieee);
> +
>  	pDot11dInfo->bEnabled = false;
>  
>  	pDot11dInfo->State = DOT11D_STATE_NONE;

This change doesn't match what you said you did :(

