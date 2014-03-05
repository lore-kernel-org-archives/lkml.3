Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbaCEAdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:33:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbaCEAdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:33:22 -0500
Date: Tue, 4 Mar 2014 16:35:05 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: devel@driverdev.osuosl.org, shaun@xresource.ca, sachin.kamat@linaro.org,
        linux-kernel@vger.kernel.org, dulshani.gunawardhana89@gmail.com,
        ying.xue@windriver.com, davem@davemloft.net
Subject: Re: [PATCH 5/7] staging: cxt1e1: fix checkpatch errors with open
 brace '{'
Message-ID: <20140305003505.GA28196@kroah.com>
References: <2842786.yy4V63h1Bd@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2842786.yy4V63h1Bd@daeseok-laptop.cloud.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 11:10:44AM +0900, Daeseok Youn wrote:
> 
> clean up checkpatch.pl error in linux.c:
>  ERROR: that open brace { should be on the previous line
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  drivers/staging/cxt1e1/linux.c |   67 ++++++++++++---------------------------
>  1 files changed, 21 insertions(+), 46 deletions(-)

As patch 4 can't be applied, I can't apply these either, please resend
the rest of the series when you fix them up.

thanks,

greg k-h
