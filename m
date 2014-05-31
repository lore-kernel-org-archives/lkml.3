Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323AbaEaETv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 00:19:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42346 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaEaETu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 00:19:50 -0400
Date: Fri, 30 May 2014 21:19:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Scott Weir <sjw0410@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: android: fix Missing a blank line after
 declarations warnings
Message-ID: <20140531041948.GA10014@kroah.com>
References: <1401267171-4106-1-git-send-email-sjw0410@gmail.com>
 <20140528213027.GA15313@kroah.com>
 <20140530055644.GA1782@lubuntuVM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140530055644.GA1782@lubuntuVM>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 03:56:44PM +1000, Scott Weir wrote:
> On Wed, May 28, 2014 at 02:30:27PM -0700, Greg KH wrote:
> > On Wed, May 28, 2014 at 06:52:51PM +1000, Scott Weir wrote:
> > > This patch corrects coding style issue:
> > > WARNING: Missing a black line after declarations
> > > 
> > > Signed-off-by: Scott Weir <sjw0410@gmail.com>
> > > ---
> > >  drivers/staging/android/sync_debug.c | 4 ++++
> > 
> > This file isn't in my tree.  Always work against linux-next, not Linus's
> > tree for new patches.
> > 
> > thanks,
> > 
> > greg k-h
> 
> This patch was made against linux-next. Is it better to use your staging tree?

Yes, but normally it should also be fine to use linux-next.

I don't know where that sync_debug.c file is coming from, it's not in my
staging branch, some other tree must be creating it, which is
troublesome to me...

Anyway, sorry, but yes, work off of the staging-next branch of
staging.git on git.kernel.org and you should be fine.

thanks,

greg k-h
