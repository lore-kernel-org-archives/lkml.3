Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaCIGhp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 01:37:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbaCIGhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 01:37:24 -0500
Date: Sat, 8 Mar 2014 22:38:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: devel@driverdev.osuosl.org, shaun@xresource.ca, sachin.kamat@linaro.org,
        linux-kernel@vger.kernel.org, dulshani.gunawardhana89@gmail.com,
        ying.xue@windriver.com, davem@davemloft.net, dan.carpenter@oracle.com
Subject: Re: [PATCH 3/4] staging: cxtie1: remove unneeded mkret() calls
Message-ID: <20140309063800.GA19386@kroah.com>
References: <3080766.8PpGkKSQoC@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3080766.8PpGkKSQoC@daeseok-laptop.cloud.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 09:03:04AM +0900, Daeseok Youn wrote:
> 
> The mkret() change a value of error from positive to
> negative. This patch is modified to return negative value
> when it failed. It doesn't need to call with function
> for changing from positive to negative.
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  drivers/staging/cxt1e1/linux.c     |   72 +++++++++++++----------------------
>  drivers/staging/cxt1e1/musycc.c    |    2 +-
>  drivers/staging/cxt1e1/pmcc4_drv.c |   40 ++++++++++----------
>  3 files changed, 48 insertions(+), 66 deletions(-)

This patch doesn't apply to my tree, can you refresh it, and patch 4 and
resend?

thanks,

greg k-h
