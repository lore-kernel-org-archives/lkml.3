Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082Ab3E2AVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 20:21:22 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:53703 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933350Ab3E2AVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 20:21:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: System slow down from udev
Date: Wed, 29 May 2013 02:30:12 +0200
Message-ID: <2013173.c6WKZTQWxj@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQVC6ByeBmYojctsQ4n2_QV=hw_5zO=87DOeWZBfLH8cug@mail.gmail.com>
References: <CAE9FiQUbSeCGTsukX3zfVYBhFKgWfVd8WDDvpix==wSXzc=RVQ@mail.gmail.com> <1826731.cQudjZKeXZ@vostro.rjw.lan> <CAE9FiQVC6ByeBmYojctsQ4n2_QV=hw_5zO=87DOeWZBfLH8cug@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 28, 2013 05:01:41 PM Yinghai Lu wrote:
> On Tue, May 28, 2013 at 4:57 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Tuesday, May 28, 2013 04:46:30 PM Yinghai Lu wrote:
> >> On Tue, May 28, 2013 at 4:50 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > On Tuesday, May 28, 2013 04:39:37 PM Yinghai Lu wrote:
> >> >> Raphael:
> >> >>
> >> >> Found one commit in your linus-pm cause user space very slow...
> >> >> at least from udev start...
> >> >
> >> > I obviously can't reproduce it, so it would be great if you could give me
> >> > more details.
> >> >
> >> > Is there anything unusual about your test system?
> >>
> >> they are normal nehalem ex, westmere ex and ivybridge ex 8 sockets system.
> >
> > Do all of them have the same problem?
> 
> yes
> 
> >
> > What distro is running there?
> 
> Using rescue initrd/root disk from opensuse 11.4 (?) and boot from network.
> 
> udevd version is 128.

I'm successfully running kernels including that commit on two different boxes
(dual-core and quad-core, both Intel, the quad-core one is Sandy Bridge) with
OpenSUSE 12.2 and 12.3.

There's a machine with an older OpenSUSE on it somewhere here, but I won't be
able to get to it before tomorrow evening.

I have no idea what's wrong at the moment.

Please attach your .config for comparison and maybe Greg will have an idea about what's up with udev vs that commit (Greg, the
commit in question, unfortunately far from trivial, is http://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=acpi-hotplug&id=ac212b6980d8d5eda705864fc5a8ecddc6d6eacc).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
