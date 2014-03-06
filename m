Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaCFTza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 14:55:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35139 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaCFTz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 14:55:29 -0500
Date: Thu, 6 Mar 2014 11:57:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: devel@driverdev.osuosl.org, shaun@xresource.ca, sachin.kamat@linaro.org,
        linux-kernel@vger.kernel.org, dulshani.gunawardhana89@gmail.com,
        davem@davemloft.net, dan.carpenter@oracle.com
Subject: Re: [PATCH 4/7 v3] staging: cxt1e1: fix checkpatch error 'assignment
 in if condition'
Message-ID: <20140306195716.GD3403@kroah.com>
References: <2109601.U7a2ESYcJ8@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2109601.U7a2ESYcJ8@daeseok-laptop.cloud.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 10:21:01AM +0900, Daeseok Youn wrote:
> 
> checkpatch.pl error in linux.c:
>  ERROR: do not use assignment in if condition
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  drivers/staging/cxt1e1/linux.c |   31 +++++++++++++++++++------------
>  1 files changed, 19 insertions(+), 12 deletions(-)

I don't see patches 1-3 here, so I'm dropping this whole series.

I do not have any short-term, or long-term, memory about patches I've
rejected / approved / discussed, as I deal with thousands of them every
week.  You need to be explicit as to what is going on, and don't try to
confused me.

Please resend properly.

greg k-h
