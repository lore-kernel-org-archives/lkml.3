Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbaE3QEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:04:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60939 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbaE3QEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:04:53 -0400
Date: Fri, 30 May 2014 09:08:31 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Sumit Semwal <sumit.semwal@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fence: Use smp_mb__before_atomic()
Message-ID: <20140530160831.GA11182@kroah.com>
References: <1401287192-14701-1-git-send-email-thierry.reding@gmail.com>
 <20140528205145.GB10468@kroah.com>
 <20140530081504.GA16669@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140530081504.GA16669@ulmo>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 10:15:05AM +0200, Thierry Reding wrote:
> On Wed, May 28, 2014 at 01:51:45PM -0700, Greg Kroah-Hartman wrote:
> > On Wed, May 28, 2014 at 04:26:32PM +0200, Thierry Reding wrote:
> > > From: Thierry Reding <treding@nvidia.com>
> > > 
> > > Commit febdbfe8a91c (arch: Prepare for smp_mb__{before,after}_atomic())
> > > deprecated the smp_mb__{before,after}_{atomic,clear}_{dec,inc,bit}*()
> > > functions in favour of the unified smp_mb__{before,after}_atomic().
> > > 
> > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > > ---
> > >  drivers/base/fence.c | 4 ++--
> > 
> > Where does this file come from?  I've not seen it before, and it's not
> > in my tree.
> 
> I think it came in through Sumit's tree and it's only in linux-next I
> believe.

Odd, linux-next is for merging things in Linus's next release.

And as I have never seen this code that will end up being my
responsibility to maintain, it seems strange that it will be merged in
the next kernel development cycle.

What broke down here with our review process that required something to
be merged without at least a cc: to me?

greg k-h
