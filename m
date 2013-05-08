Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab3EHS2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:28:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757561Ab3EHS2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:28:38 -0400
Date: Wed, 8 May 2013 11:28:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.9.1
Message-ID: <20130508182837.GA26128@kroah.com>
References: <20130508041010.GA17374@kroah.com>
 <20130508072245.GB4169@fysh.org>
 <20130508175020.GA17950@kroah.com>
 <20130508181943.GC4169@fysh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508181943.GC4169@fysh.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 07:19:43PM +0100, Athanasius wrote:
> On Wed, May 08, 2013 at 10:50:20AM -0700, Greg KH wrote:
> > On Wed, May 08, 2013 at 08:22:45AM +0100, Athanasius wrote:
> > > On Tue, May 07, 2013 at 09:10:10PM -0700, Greg KH wrote:
> > > > I'm announcing the release of the 3.9.1 kernel.
> > > > 
> > > > All users of the 3.9 kernel series must upgrade.
> > > > 
> > > > The updated 3.9.y git tree can be found at:
> > > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.9.y
> > > 
> > >   Usually I can:
> > > 
> > > 	git pull git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git master
> > 
> > If you do that, you only get the master branch updated locally.  Which
> > tracks Linus's tree, not the different stable releases.
> > 
> > > which means not having to update scripts/commandline history on each
> > > major verison change, but this time I did indeed need to:
> > > 
> > > 	git pull git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.9.y
> > > 
> > > is this an intended change, or did you do something like forgetting to
> > > merge into master on linux-stable ?
> > 
> > No, I have not changed anything on my end, perhaps you never really were
> > updating the different stable branches?
> 
>   'uname -r' says I was.  Also 'git log' for my v3.8 branch currently on
> 3.8.9 via the 'master' method does include at least the top few commits
> listed on:
> 
> <https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/log/?id=refs/tags/v3.8.9>
> 
> Of course only having gotten to 3.8.9 a pull against linux-3.8.y does
> see changes.  Perhaps someone else, or a script on git.kernel.org was
> merging into master before and now isn't ?

No, nothing was ever mergeing into master in the linux-stable git tree.
You might have been doing that locally, check the merges to see who was
doing it.

>   Anyway, if it's unsupported to pull from linux-stable.git master I'll
> change my scripts.

It's not unsupported, you will just get a copy of Linus's tree there,
delayed by usually a -rc release or so.

thanks,

greg k-h
