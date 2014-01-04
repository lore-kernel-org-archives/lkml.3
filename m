Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaADRcD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 12:32:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55596 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbaADRcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 12:32:01 -0500
Date: Sat, 4 Jan 2014 09:32:10 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Teck Choon Giam <giamteckchoon@gmail.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org, lwn@lwn.net
Subject: Re: Linux 3.2.54
Message-ID: <20140104173210.GA32402@kroah.com>
References: <1388755289.22017.42.camel@deadeye.wl.decadent.org.uk>
 <CAEwRVpN7z5rDnqNg3ZF+5=Go1EXKAm0TutQPUZ_mj2OCQ5-kwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEwRVpN7z5rDnqNg3ZF+5=Go1EXKAm0TutQPUZ_mj2OCQ5-kwQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 05, 2014 at 12:43:05AM +0800, Teck Choon Giam wrote:
> Hi Ben,
> 
> 
> On Fri, Jan 3, 2014 at 9:21 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
> > I'm announcing the release of the 3.2.54 kernel.
> >
> > All users of the 3.2 kernel series should upgrade.
> >
> > The updated 3.2.y git tree can be found at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.2.y
> > and can be browsed at the normal kernel.org git web browser:
> >         http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git
> 
> 
> Just for your information,
> https://www.kernel.org/pub/linux/kernel/v3.x/ I can only see version
> 3.2.54 with tar.xz and tar.gz where tar.bz2 extension is missing.  I
> don't know whether is this intentionally but just to let you know in
> case.

As was announced earlier, there will not be any more .bz2 tarballs
created starting this year, sorry.  So this was intentional.

thanks,

greg k-h
