Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab3FYPY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:24:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39841 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab3FYPY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:24:27 -0400
Date: Tue, 25 Jun 2013 08:25:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: USB tree now closed for 3.11
Message-ID: <20130625152510.GA20552@kroah.com>
References: <20130625150732.GA19676@kroah.com>
 <Pine.LNX.4.44L0.1306251119100.1340-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1306251119100.1340-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 11:21:43AM -0400, Alan Stern wrote:
> On Tue, 25 Jun 2013, Greg KH wrote:
> 
> > Hi all,
> > 
> > With the release of the 3.10-rc7 kernel, I think it's time to close the
> > USB tree for new features / cleanups for 3.11.  So I'm closing my
> > tree, and will only be applying obvious bugfixes or regressions to it
> > until 3.11-rc1 comes out.
> > 
> > You can keep sending me patches for the tree that don't fit the "bugfix"
> > category, but note that I'll be storing them away to wait for 3.11-rc1
> > comes out, which might be a few weeks, so please be patient.
> > 
> > The USB tree right now contains 382 patches, and the diffstat
> > summary is:
> > 	 410 files changed, 18183 insertions(+), 4956 deletions(-)
> 
> Instead of storing away new patches where people can't easily get at
> them, you could create a temporary branch to hold them until 3.11-rc1
> is released.  Would that involve a significant amount of extra work?

Yes that would, because I'm busy doing other merge-related things for
these next 3 weeks, I don't have the time to be building a new tree.  I
supposed you could always use patchwork to see the pending patches, but
I need this time "away" from applying patches to catch up on my other
tasks.

sorry,

greg k-h
