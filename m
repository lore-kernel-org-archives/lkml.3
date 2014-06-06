Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbaFFEmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 00:42:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33616 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaFFEmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 00:42:07 -0400
Date: Fri, 6 Jun 2014 04:42:01 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Paul Moore <paul@paul-moore.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        "Serge E. Hallyn" <serge@canonical.com>
Subject: Re: Change in security maintainer for a few weeks
Message-ID: <20140606044201.GG22106@ubuntumail>
References: <20140605183050.GA5054@kroah.com>
 <alpine.LRH.2.00.1406052355500.2434@twin.jikos.cz>
 <4426926.gIRHbeKnmD@sifl>
 <20140605225311.GB32470@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140605225311.GB32470@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Greg KH (gregkh@linuxfoundation.org):
> On Thu, Jun 05, 2014 at 06:39:09PM -0400, Paul Moore wrote:
> > On Thursday, June 05, 2014 11:59:11 PM Jiri Kosina wrote:
> > > On Thu, 5 Jun 2014, Greg KH wrote:
> > > > James has had to step back from doing kernel work for a few weeks, so
> > > > I've offered to step up and handle the security patches to get shuttled
> > > > to Linus for merging for a while.
> > > 
> > > As exactly this (working with active contributors to help co-maintain the
> > > subsystem) has been brought at the ksummit maling list, I am just curious
> > > whether noone else actively working in that area was willing to step up?
> > > 
> > > 	$ ./scripts/get_maintainer.pl --git -f security/
> > > 	James Morris <james.l.morris@oracle.com> (supporter:SECURITY SUBSYSTEM)
> > >    ...
> > > 
> > > If not, then I think this can be shown as a prime example why the problem
> > > of "non-substituability" of many maintainers is actually real.
> > 
> > Once several of us became aware that James was stepping away for a few weeks 
> > (I should mention this was not a planned absence and took most of us by 
> > surprise) we had a brief discussion off-list and several of us did offer to 
> > "step-up"; Serge had already created a repo and since he had pushed patches 
> > while James was away in the past it seemed a reasonable approach this time 
> > around.
> 
> That's great, as the communication around this has not been very much
> (an non-existant on the subsystem mailing list) I was not aware of it.
> 
> If Serge wants to do this, and as he has been the stand-in for James in
> the past, I have _no_ objection to this at all.
> 
> Serge, feel free to resend your patches to Linus if he doesn't pick them
> up in a few days, with the information that you are doing this in
> James's absence for a while.

Will do (and wil cc: lsm).

> So, that was easy, I don't have to do this at all, great.
> 
> greg k-h
