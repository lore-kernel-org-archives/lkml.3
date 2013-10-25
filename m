Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab3JYRRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 13:17:31 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:39100 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab3JYRR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 13:17:29 -0400
Date: Fri, 25 Oct 2013 10:17:21 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Olof Johansson <olof@lixom.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Subject: Re: linux-next: Tree for Oct 24
Message-ID: <20131025171721.GB8091@roeck-us.net>
References: <1382632289-18523-1-git-send-email-treding@nvidia.com>
 <5269FB5E.6010901@roeck-us.net>
 <20131025083525.GF19622@ulmo.nvidia.com>
 <CAOesGMg+Xi3+MZrPbRiMGFe2cQFjN9qaif9u5gW_tDzK62EB7w@mail.gmail.com>
 <20131025133512.GA1551@ulmo.nvidia.com>
 <CAOesGMh=VLEuFgZuwrJnPsbxnr1Y528CVUdq313Ey5SVUb-jsw@mail.gmail.com>
 <20131025141707.GA27461@ulmo.nvidia.com>
 <20131025150228.GA5501@roeck-us.net>
 <20131025151717.GA3782@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131025151717.GA3782@ulmo.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 05:17:18PM +0200, Thierry Reding wrote:
> > > 
> > "Doesn't even build" is relative, though. After all, there still _are_
> > 18 build failures out of 106 in my test builds alone. Where do you draw
> > the line ? arm failures are bad, who cares about blackfin ?
> 
> Well, I've been doing x86, ARM and PowerPC builds and of those only 3
> are failing and I didn't fix them because I didn't really know how to.
> But you're right, I guess one has to draw the line somewhere, and if
> people prefer the tree to just be broken rather than with odd fixes on
> top, then that's the way it going to be.
> 
> For now I've settled on pushing a branch which has only the fixes that
> are required to make the trees work happily together and a separate tag
> which has the patches that unbreak subsystem trees.
> 
> The reason I usually want linux-next to build is because I know that
> various people rely on it for their daily work, so my reasoning was that
> if I fix it before they even start using it, then they get to spend
> their time with something more useful and only one person ends up fixing
> the build issues instead of everyone.
> 
Frankly, I don't even know what the best approach would be.
Ultimately you are stuck between a rock and a hard place: You want the tree
to build so people can use it, but each patch you apply yourself might 
result in it not getting fixed in the contributing repository.

I think one problem we have is how to report breakages. Any summary 
mail or web page doesn't help if no one looks at it. It does help lot
to send specific e-mail along the line of "Commit 'bla' caused build 'x'
to fail as follows" to the respective mailing list and patch authors,
but that takes a lot of time which at least I don't have. And people
might get annoyed by automated e-mails, so that might not be a good
idea either. 

Guenter
