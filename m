Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab3FGPKB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:10:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3FGPJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:09:59 -0400
Date: Fri, 7 Jun 2013 08:10:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Li Zefan <lizefan@huawei.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 3.0.80
Message-ID: <20130607151030.GB5264@kroah.com>
References: <20130524182347.GA3110@kroah.com>
 <51B1A33C.1020708@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B1A33C.1020708@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 05:09:16PM +0800, Li Zefan wrote:
> On 2013/5/25 2:23, Greg KH wrote:
> > I'm announcing the release of the 3.0.80 kernel.
> > 
> > All users of the 3.0 kernel series must upgrade.
> > 
> > The updated 3.0.y git tree can be found at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
> > and can be browsed at the normal kernel.org git web browser:
> > 	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------
> > 
> >  Makefile                              |    2 +-
> >  drivers/hwmon/abituguru.c             |   16 ++++++++++------
> >  drivers/media/dvb/mantis/mantis_dvb.c |    6 ++++--
> >  fs/btrfs/ioctl.c                      |   10 +++++-----
> >  4 files changed, 20 insertions(+), 14 deletions(-)
> > 
> 
> 3.0.80 failed to boot, and looks like the culprit is blkcg, so I disabled
> CONFIG_CGROUP and it boot successfully.

Did 3.0.79 boot properly with this same hardware / kernel configuration?
If so, can you bisect it down to the problem commit please?

> I haven't tried 3.0.81, as it's not released yet.

Give me a few hours, but odds are, it's not fixed, as I have not heard
of this problem before.

thanks,

greg k-h
