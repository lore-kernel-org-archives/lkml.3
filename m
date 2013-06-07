Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3FGOaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 10:30:23 -0400
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:41264 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab3FGOaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 10:30:22 -0400
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Fri, 7 Jun 2013 10:30:14 -0400
To: "luke.leighton" <luke.leighton@gmail.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, linux-arm-kernel@lists.infradead.org,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        debian-kernel@lists.debian.org
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
Message-ID: <20130607143014.GB11182@csclub.uwaterloo.ca>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
 <1851164.HnXhGSdttW@flatron>
 <CAPweEDxWW4LUeBaHLb+wHuAMq=63p88zsx4tumVb2PdP_+ohAw@mail.gmail.com>
 <1622862.fXQWv0YWGV@flatron>
 <CAPweEDx_1fvAv9sROtPreoyyj_yDAuYb040fM2zPc+tf22d=YA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPweEDx_1fvAv9sROtPreoyyj_yDAuYb040fM2zPc+tf22d=YA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 08:52:43AM +0100, luke.leighton wrote:
>  coming back to what you said earlier: i'm formulating what to say to
> allwinner [and need to pre-send something by monday so that they can
> consider it before the meeting].  so far, it consists of:
> 
> * device-tree is what the linux kernel community has come up with, it
> is equivalent to FEX.

>From what I have seem looking at FEX, devicetree is vastly more powerful
and scalable than FEX.  It is also a standard (IEEE1275) that has been
around for many years (given devicetree is using part of openfirmware).

> * the linux kernel community would like to apologise for not
> consulting with you (allwinner) on the decision to only accept device
> tree

I would consider that an enourmous lie.  Devicetree was around long
before their company had ever started doing the allwinner.  It might
not have been used in ARM yet, but it was used in a number of other
architectures, making it the obvious choice for doing the same thing on
more architectures.

> [bear in mind that if this kind of thing isn't said, they risk just
> continuing to make the sunxi community's life absolute hell by
> continuing to work in isolation and continuing to duplicate drivers
> etc. etc. ]

That is their problem (and their customers).

> * work is being done by the free software community, they are
> beginning to integrate allwinner's work into the upstream kernel, and
> you (allwinner) will begin to see this when you get round to doing
> linux kernel 3.9

If something is popular enough, people will work on getting it supported,
where supported means done properly.

> * allwinner and the linux and sunxi community therefore need to work
> closer together, we propose:
> 
> * {insert proposals here}

How about allwinner simply tries to help with the activity already taking
place for getting everything working with devicetree.  That probably
means doing work to their tools to generate devicetree files from their
FEX files, if they really like FEX (and think their customers like FEX).

> 3 days left on the clock.

Who cares what your deadline is.  That's not how good choices are made.

-- 
Len Sorensen
