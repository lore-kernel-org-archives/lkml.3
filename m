Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbaF3Cu1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 22:50:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34318 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbaF3Cu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 22:50:26 -0400
Date: Sun, 29 Jun 2014 14:22:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: devel@driverdev.osuosl.org, weo@weo1.de, sachin.kamat@linaro.org,
        peter.p.waskiewicz.jr@intel.com, linux-kernel@vger.kernel.org,
        himangi774@gmail.com, fempsci@gmail.com
Subject: Re: [PATCH 2/3] staging: cxt1e1: count fragmented packet properly.
Message-ID: <20140629212238.GA12439@kroah.com>
References: <20140627095608.GA9427@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140627095608.GA9427@devel.8.8.4.4>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 06:56:08PM +0900, Daeseok Youn wrote:
> OS_mem_token_tlen() is same return value as OS_mem_token_len().
> That means packet count is always 1. So OS_mem_token_tlen()
> must be total length of packet and OS_mem_token_len() has a
> length of fragmented packet. And then it can count total
> count of fragmented packets properly.
> 
> And OS_mem_token_next() returns NULL, it will be dereferencing
> a NULL pointer. So it must return next fragmented packet buffer as
> sk_buff.
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
> I'm not sure of this patch and not tested.(just only build test).
> Please review for this.
> Thanks.

Please refresh these last two based on the changes in the first one you
should do.

thanks,

greg k-h
