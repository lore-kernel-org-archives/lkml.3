Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaFESrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 14:47:23 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:50828
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaFESrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 14:47:21 -0400
Date: Thu, 5 Jun 2014 20:47:19 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: Change in security maintainer for a few weeks
Message-ID: <20140605184719.GA15438@mail.hallyn.com>
References: <20140605183050.GA5054@kroah.com>
 <CA+5PVA5aG98VfjxjgKdOwN9DQzDbJAJMBWfBwBpV8Ko4565bHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA5aG98VfjxjgKdOwN9DQzDbJAJMBWfBwBpV8Ko4565bHg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Josh Boyer (jwboyer@fedoraproject.org):
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
> 
> Confused...

Yes, but (this time :) James didn't actually ask me to, so if he asked
Greg that's great.  Greg, the 5 patches I added on top of James' tree
were 4 from Paul which are already in linux-next, and one (the highest
priority one out of a larger set) from Mimi.  If you could add those
that would be great.

thanks,
-serge
