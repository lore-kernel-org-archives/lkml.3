Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbaFESsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 14:48:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55205 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaFESsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 14:48:21 -0400
Date: Thu, 5 Jun 2014 11:52:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: Change in security maintainer for a few weeks
Message-ID: <20140605185202.GA25521@kroah.com>
References: <20140605183050.GA5054@kroah.com>
 <CA+5PVA5aG98VfjxjgKdOwN9DQzDbJAJMBWfBwBpV8Ko4565bHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA5aG98VfjxjgKdOwN9DQzDbJAJMBWfBwBpV8Ko4565bHg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 02:38:25PM -0400, Josh Boyer wrote:
> On Thu, Jun 5, 2014 at 2:30 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > Hi all,
> >
> > James has had to step back from doing kernel work for a few weeks, so
> > I've offered to step up and handle the security patches to get shuttled
> > to Linus for merging for a while.
> >
> > I'll take his git tree on kernel.org and push those to Linus for
> > 3.16-rc1, as those look like they have had proper testing in linux-next.
> >
> > But there only seems to be 14 patches in there.  Are there pending
> > patches that people have been sending and need to get in besides those?
> 
> Serge seems to have already done this?
> 
> https://lkml.org/lkml/2014/6/4/350

Ah, that's good, but wasn't sent to the linux-security-module list where
I would have noticed it :(

The patches also don't seem to have ended up in Linus's tree either
yet...

Serge, are you going to be doing this in replacement of James for a
while?  What made you push these to Linus and not tell the security
list?

> Confused...

Me as well...

greg k-h
