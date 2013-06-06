Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab3FFX2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 19:28:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54604 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab3FFX2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 19:28:06 -0400
Date: Thu, 6 Jun 2013 16:28:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: usbutils 006 release
Message-ID: <20130606232805.GA8875@kroah.com>
References: <20120706203547.GA28678@kroah.com>
 <Pine.LNX.4.44L0.1207091121060.1954-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1207091121060.1954-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 11:22:22AM -0400, Alan Stern wrote:
> On Fri, 6 Jul 2012, Greg KH wrote:
> 
> > Here's the 006 release of usbutils.
> > 
> > Some USB 3.0 updates, a new usb.ids file update, and a number of other
> > fixes and updates for annoying problems that people had reported.  Full
> > shortlog information is below if people are curious.
> > 
> > The package can be downladed from kernel.org:
> >         http://www.kernel.org/pub/linux/utils/usb/usbutils/
> > 
> > We've switched over to using git for development now, which makes things
> > much easier than the old cvs tree.  The tree can be found on both
> > kernel.org and github.com if you want to fork it and send us changes
> > easier:
> > 	http://git.kernel.org/?p=linux/kernel/git/gregkh/usbutils.git
> 
> This link doesn't work for me.  Are you sure the repository is 
> installed at git.kernel.org?

It wasn't, sorry, I've pushed it there now, and should show up in a few
hours.

thanks,

greg k-h
