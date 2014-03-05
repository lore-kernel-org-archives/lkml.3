Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbaCEBE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 20:04:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843AbaCEBEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 20:04:25 -0500
Date: Tue, 4 Mar 2014 17:06:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: DaeSeok Youn <daeseok.youn@gmail.com>
Cc: devel <devel@driverdev.osuosl.org>, Shaun Laing <shaun@xresource.ca>,
        "sachin.kamat" <sachin.kamat@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        "ying.xue" <ying.xue@windriver.com>,
        David Miller <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 5/7] staging: cxt1e1: fix checkpatch errors with open
 brace '{'
Message-ID: <20140305010609.GB32357@kroah.com>
References: <2842786.yy4V63h1Bd@daeseok-laptop.cloud.net>
 <20140305003505.GA28196@kroah.com>
 <CAHb8M2D8miCPsse4twZxqtSaOAv4bKncUWcm47JXvfKxQZodVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHb8M2D8miCPsse4twZxqtSaOAv4bKncUWcm47JXvfKxQZodVw@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 09:55:14AM +0900, DaeSeok Youn wrote:
> Hi, greg
> 
> I already resend patch 4 and 5. :-)
> 
> It had a bug which is noticed by Dan.
> 
> I tried to fix assignment in if condition and missed curly brace in inner loop.
> So I fixed that bug and resend patch 4. And patch 5 is rebased after
> fixing patch 4.
> 
> And I tested to apply these patch to staging-next branch from mailing list.
> Please check.

I've flushed all of your patches from my queue now, please resend
anything I haven't applied.

thanks,

greg k-h
