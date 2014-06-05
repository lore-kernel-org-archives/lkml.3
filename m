Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaFEWuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 18:50:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58445 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbaFEWum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 18:50:42 -0400
Date: Thu, 5 Jun 2014 15:54:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: Change in security maintainer for a few weeks
Message-ID: <20140605225424.GC32470@kroah.com>
References: <20140605183050.GA5054@kroah.com>
 <CA+5PVA5aG98VfjxjgKdOwN9DQzDbJAJMBWfBwBpV8Ko4565bHg@mail.gmail.com>
 <20140605185202.GA25521@kroah.com>
 <20140605185513.GA15591@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140605185513.GA15591@mail.hallyn.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 08:55:13PM +0200, Serge E. Hallyn wrote:
> Quoting Greg KH (gregkh@linuxfoundation.org):
> > On Thu, Jun 05, 2014 at 02:38:25PM -0400, Josh Boyer wrote:
> > > On Thu, Jun 5, 2014 at 2:30 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > Hi all,
> > > >
> > > > James has had to step back from doing kernel work for a few weeks, so
> > > > I've offered to step up and handle the security patches to get shuttled
> > > > to Linus for merging for a while.
> > > >
> > > > I'll take his git tree on kernel.org and push those to Linus for
> > > > 3.16-rc1, as those look like they have had proper testing in linux-next.
> > > >
> > > > But there only seems to be 14 patches in there.  Are there pending
> > > > patches that people have been sending and need to get in besides those?
> > > 
> > > Serge seems to have already done this?
> > > 
> > > https://lkml.org/lkml/2014/6/4/350
> > 
> > Ah, that's good, but wasn't sent to the linux-security-module list where
> > I would have noticed it :(
> > 
> > The patches also don't seem to have ended up in Linus's tree either
> > yet...
> > 
> > Serge, are you going to be doing this in replacement of James for a
> > while?
> 
> I don't mind, but I definately don't mind if you do.  In the past with
> planned vacations James has asked me to babysit the tree, so I just
> wanted to make sure it didn't get neglected.  But he did not ask me,
> I'm just an interloper.

That's great, I wasn't aware of this.  Feel free to keep doing this and
taking over for now.  As you already have a kernel.org account, and have
done it in the past, it only makes sense for you to continue.

But next time, cc: the subsystem mailing list :)

thanks,

greg k-h
