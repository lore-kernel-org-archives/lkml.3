Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaFESzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 14:55:17 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:50942
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaFESzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 14:55:15 -0400
Date: Thu, 5 Jun 2014 20:55:13 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: Change in security maintainer for a few weeks
Message-ID: <20140605185513.GA15591@mail.hallyn.com>
References: <20140605183050.GA5054@kroah.com>
 <CA+5PVA5aG98VfjxjgKdOwN9DQzDbJAJMBWfBwBpV8Ko4565bHg@mail.gmail.com>
 <20140605185202.GA25521@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140605185202.GA25521@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Greg KH (gregkh@linuxfoundation.org):
> On Thu, Jun 05, 2014 at 02:38:25PM -0400, Josh Boyer wrote:
> > On Thu, Jun 5, 2014 at 2:30 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > > Hi all,
> > >
> > > James has had to step back from doing kernel work for a few weeks, so
> > > I've offered to step up and handle the security patches to get shuttled
> > > to Linus for merging for a while.
> > >
> > > I'll take his git tree on kernel.org and push those to Linus for
> > > 3.16-rc1, as those look like they have had proper testing in linux-next.
> > >
> > > But there only seems to be 14 patches in there.  Are there pending
> > > patches that people have been sending and need to get in besides those?
> > 
> > Serge seems to have already done this?
> > 
> > https://lkml.org/lkml/2014/6/4/350
> 
> Ah, that's good, but wasn't sent to the linux-security-module list where
> I would have noticed it :(
> 
> The patches also don't seem to have ended up in Linus's tree either
> yet...
> 
> Serge, are you going to be doing this in replacement of James for a
> while?

I don't mind, but I definately don't mind if you do.  In the past with
planned vacations James has asked me to babysit the tree, so I just
wanted to make sure it didn't get neglected.  But he did not ask me,
I'm just an interloper.

>   What made you push these to Linus and not tell the security
> list?

Abject failure on my part, sorry.

> > Confused...
> 
> Me as well...
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
