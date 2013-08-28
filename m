Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab3H1CDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 22:03:17 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:49827 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab3H1CDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 22:03:16 -0400
Date: Tue, 27 Aug 2013 18:58:34 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jingoo Han <jg1.han@samsung.com>,
        "'David Woodhouse'" <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 33/35] power: use dev_get_platdata()
Message-ID: <20130828015834.GH10506@lizard>
References: <005c01ce8cfd$82078af0$8616a0d0$@samsung.com>
 <20130809220451.GG12638@lizard.sbx05730.santaca.wayport.net>
 <003401ce96f2$0f53b840$2dfb28c0$@samsung.com>
 <20130813090039.GA5604@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130813090039.GA5604@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 12:00:39PM +0300, Dan Carpenter wrote:
> > > > Use the wrapper function for retrieving the platform data instead of
> > > > accessing dev->platform_data directly.
> > > 
> > > Um.. what is the benefit or rationale of this patch?
> > 
> > CC'ed Joe Perches, Dan Carpenter
> > 
> > Hi Anton Vorontsov,
> > 
> > Usually, using the wrapper function makes the code simpler.
> > Also, it make the code more readable.
> 
> Since people are asking my opinion, then yes using
> dev_get_platdata() as intended is better than open coding.  It's a
> coding standard thing.

I don't see any immediate benefit of applying this patch... It does not
fix anything now or in the near future (or we are about to add something
into dev_get_platdata() wrapper, or get rid of dev.platform_data member?
Any plans for this? Then it should be in the commit message.)

Without any plans to actually use the wrapper the patch is just a churn
[that might result into patch conflicts that I'll have to deal with], so
I'll refrain from applying it.

Thanks,

Anton
