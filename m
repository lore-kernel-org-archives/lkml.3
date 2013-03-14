Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab3CNWTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:19:31 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:60643 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab3CNWTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:19:30 -0400
Date: Thu, 14 Mar 2013 15:19:27 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] staging: ccg: remove two outdated dependencies
Message-ID: <20130314221927.GA28339@kroah.com>
References: <1363256224.1335.46.camel@x61.thuisdomein>
 <20130314105953.GJ9138@mwanda>
 <1363259393.1335.55.camel@x61.thuisdomein>
 <20130314220229.GA7991@kroah.com>
 <1363299141.1335.88.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363299141.1335.88.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 11:12:21PM +0100, Paul Bolle wrote:
> On Thu, 2013-03-14 at 15:02 -0700, Greg Kroah-Hartman wrote:
> > On Thu, Mar 14, 2013 at 12:09:53PM +0100, Paul Bolle wrote:
> > > Well, now that you somehow managed to review this patch the urge to
> > > clean this line up has suddenly diminished. But maybe you're lucky and
> > > this will not pass Greg. 
> > 
> > It didn't, please clean it up "properly", I'll drop this patch for now,
> > thanks. :)
> 
> The horror is mostly caused by negative dependencies on USB Kconfig
> symbols. Any clue why this driver conflicts with about twenty USB
> related options?

Yes, because it is a horrible thing and needs to be deleted.

Seriously, I had a number of people ask me to delete it last week at the
Linaro event.

Hm, I guess I should just do it, I know it would make the USB developers
much happier, nevermind about your patch, I'll just drop the whole
thing, which will fix your problem in a different way :)

thanks,

greg k-h
