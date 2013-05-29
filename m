Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934343Ab3E2BGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 21:06:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34890 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932863Ab3E2BGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 21:06:53 -0400
Date: Wed, 29 May 2013 10:07:16 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yinghai Lu <yinghai@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: System slow down from udev
Message-ID: <20130529010716.GD1893@kroah.com>
References: <CAE9FiQUbSeCGTsukX3zfVYBhFKgWfVd8WDDvpix==wSXzc=RVQ@mail.gmail.com>
 <1826731.cQudjZKeXZ@vostro.rjw.lan>
 <CAE9FiQVC6ByeBmYojctsQ4n2_QV=hw_5zO=87DOeWZBfLH8cug@mail.gmail.com>
 <2013173.c6WKZTQWxj@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2013173.c6WKZTQWxj@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 02:30:12AM +0200, Rafael J. Wysocki wrote:
> On Tuesday, May 28, 2013 05:01:41 PM Yinghai Lu wrote:
> > On Tue, May 28, 2013 at 4:57 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > On Tuesday, May 28, 2013 04:46:30 PM Yinghai Lu wrote:
> > >> On Tue, May 28, 2013 at 4:50 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > >> > On Tuesday, May 28, 2013 04:39:37 PM Yinghai Lu wrote:
> > >> >> Raphael:
> > >> >>
> > >> >> Found one commit in your linus-pm cause user space very slow...
> > >> >> at least from udev start...
> > >> >
> > >> > I obviously can't reproduce it, so it would be great if you could give me
> > >> > more details.
> > >> >
> > >> > Is there anything unusual about your test system?
> > >>
> > >> they are normal nehalem ex, westmere ex and ivybridge ex 8 sockets system.
> > >
> > > Do all of them have the same problem?
> > 
> > yes
> > 
> > >
> > > What distro is running there?
> > 
> > Using rescue initrd/root disk from opensuse 11.4 (?) and boot from network.
> > 
> > udevd version is 128.
> 
> I'm successfully running kernels including that commit on two different boxes
> (dual-core and quad-core, both Intel, the quad-core one is Sandy Bridge) with
> OpenSUSE 12.2 and 12.3.
> 
> There's a machine with an older OpenSUSE on it somewhere here, but I won't be
> able to get to it before tomorrow evening.
> 
> I have no idea what's wrong at the moment.
> 
> Please attach your .config for comparison and maybe Greg will have an idea about what's up with udev vs that commit (Greg, the
> commit in question, unfortunately far from trivial, is http://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=acpi-hotplug&id=ac212b6980d8d5eda705864fc5a8ecddc6d6eacc).

I don't see how this would "slow down" the boot process.  Can someone
run the bootchart tool on the machine to see where the delays are?

thanks,

greg k-h
