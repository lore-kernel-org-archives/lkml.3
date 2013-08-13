Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab3HMGkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:40:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757461Ab3HMGk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:40:29 -0400
Date: Mon, 12 Aug 2013 23:41:54 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [ 000/102] 3.10.6-stable review
Message-ID: <20130813064154.GA9867@kroah.com>
References: <20130809015010.208118575@linuxfoundation.org>
 <20130809192030.GD4079@1wt.eu>
 <20130809193329.GA5792@kroah.com>
 <20130813040206.GA6009@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813040206.GA6009@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 09:02:06PM -0700, Guenter Roeck wrote:
> On Fri, Aug 09, 2013 at 12:33:29PM -0700, Greg Kroah-Hartman wrote:
> > On Fri, Aug 09, 2013 at 09:20:30PM +0200, Willy Tarreau wrote:
> > > Hi Greg,
> > > 
> > > On Thu, Aug 08, 2013 at 06:56:36PM -0700, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 3.10.6 release.
> > > > There are 102 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > 
> > > Just checked on my OpenBlocks AX3 (dual-core ARMv7 in thumbs mode),
> > > everything seems OK, I did not even notice any performance regression
> > > compared to 3.10.5 on syscall intensive workloads with the recent
> > > changes. I'm sure that I'm using the kuser helpers page since the
> > > system doesn't boot without. Also I did observe minor changes in
> > > /proc/self/maps, but I don't think they should have any impact, so
> > > all in all it's OK :
> > 
> > Wonderful, thanks so much for testing the arm stuff, I wasn't sure I got
> > it all correct in the backport.
> > 
> > One of these days I'll get a system here that I can test arm changes
> > on...
> > 
> Have a look at http://server.roeck-us.net:8010/waterfall.
> 
> If everything works as intended, we should get automated builds
> for various platforms, plus automated qemu tests for some of them.
> 
> I have qemu boot tests running for mips (3.4 and 3.10), ppc (3.0, 3.4, 3.10),
> and x86 (3.0, 3.4, 3.10) working. x86_64 and mips64 should follow soon.
> 
> Unfortunately, arm tests don't work yet because of a bug in the arm
> kernel code.
> 
> Builds are started about 30 minutes after a change in the stable-queue
> repository has been detected, and complete after 3-4 hours unless
> the servers are busy doing real work. Which explains why I can annoy
> you with results pretty quickly lately :).

Very nice, thanks for doing this, I'll watch it and see what I can break
:)

greg k-h
