Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaCQVVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 17:21:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48385 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbaCQVVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 17:21:13 -0400
Date: Mon, 17 Mar 2014 14:23:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: nandu.hgowda@gmail.com, devel@driverdev.osuosl.org, shaun@xresource.ca,
        sachin.kamat@linaro.org, gang.chen@asianux.com,
        linux-kernel@vger.kernel.org, dulshani.gunawardhana89@gmail.com,
        himangi774@gmail.com, ying.xue@windriver.com, davem@davemloft.net
Subject: Re: [PATCH 1/2] staging: cxtie1: remove unneeded mkret() calls
Message-ID: <20140317212314.GA3112@kroah.com>
References: <1858518.8JZ4tELMNS@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1858518.8JZ4tELMNS@daeseok-laptop.cloud.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 08:54:18AM +0900, Daeseok Youn wrote:
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

This patch no longer applies to my tree, can you refresh it and resend?
