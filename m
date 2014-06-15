Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751286AbaFODdZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 23:33:25 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:59368 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaFODdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 23:33:23 -0400
Date: Sun, 15 Jun 2014 03:33:22 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Roger Quadros <rogerq@ti.com>
cc: tony@atomide.com, kishon@ti.com, george.cherian@ti.com, balbi@ti.com,
        balajitk@ti.com, hdegoede@redhat.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Nikhil Devshatwar <nikhil.nd@ti.com>,
        Benoit Cousson <bcousson@baylibre.com>
Subject: Re: [PATCH v4 3/4] ARM: DRA7: hwmod: Add ocp2scp3 and sata hwmods
In-Reply-To: <alpine.DEB.2.02.1406131901340.340@utopia.booyaka.com>
Message-ID: <alpine.DEB.2.02.1406150331530.659@utopia.booyaka.com>
References: <1398274237-24510-1-git-send-email-rogerq@ti.com> <1398274559-24777-1-git-send-email-rogerq@ti.com> <alpine.DEB.2.02.1406131901340.340@utopia.booyaka.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2014, Paul Walmsley wrote:

> Hi Roger,
> 
> On Wed, 23 Apr 2014, Roger Quadros wrote:
> 
> > From: Nikhil Devshatwar <nikhil.nd@ti.com>
> > 
> > Add hwmods for ocp2scp3 and sata modules.
> > 
> > [Roger Q] Clean up.
> 
> Sorry for the delay on this.  Have been corresponding with TI to figure 
> out what to do about these DRA7xx/AM43xx patches, since I don't have 
> boards or public documentation for these devices, so it's impossible for 
> me to meaningfully review the patches.  Looks like boards and/or public 
> docs won't be coming any time soon.
> 
> So for my part, here's what I'll need to merge any hwmod patches that 
> involve AM437x or DRA7xx:
> 
> 1. A Reviewed-by: from one of the following folks (which should come from 
> a different person than who is submitting the patches):
> 
> Roger Quadros
> Nishanth Menon
> Rajendra Nayak
> Kevin Hilman
> Tony Lindgren
> 
> 2. A Tested-by: from one of the following folks (who can be the same as 
> the person who is the same as the person who is submitting the patches):
> 
> Nishanth Menon
> Rajendra Nayak
> Kevin Hilman 
> Tony Lindgren
> 
> Once these are in place, I'd be happy to queue it for 3.16.

I've tried to clarify this a bit.  The update is below.


- Paul



For boards that I don't have access to, that I don't have 
documentation for, such as the AM43xx and DRA7xx), for me to merge or ack 
SoC infrastructure or PM-related patches, I want to have:

1. a Reviewed-by: from people who:

a. I think know something about SoC integration or PM in general, and 
about OMAP-style integration specifically; and

b. who have a track record of doing strong and detailed reviews of that 
code, or who have contributed significantly to that code in the past.

My initial list of those reviewers is listed above, and I am happy to 
consider extending it or modifying that list.


2. confidence that the patch or series has been tested against a mainline 
commit and isn't obviously breaking other things, like PM, and confidence 
that it's not adding new runtime warnings.

I've listed an initial set of people above who I feel have proven track 
records in testing who I'm happy to accept Tested-by:s without further 
explanation.  I'm sure I've missed some folks and if anyone who should be 
on that list is offended that I didn't mention them, please accept my 
apologies.  For other folks, like yourself, who aren't on that list (yet), 
please just specifically state:

a. what mainline commit they've tested the patch against,

b. what other prerequisite patches were needed for the patch to apply,

c. and a cut-and-paste of the serial console boot log from the boot 
portion of the test.

in such a way that myself or someone else can easily doublecheck it. 

And frankly, I'll probably be happy to merge it.

After someone has done these three things a few times, and I gain 
confidence that they're doing the right thing, I'm happy to add them to 
my list.

The testing doesn't have to be expressed via a Tested-by: tag in cases 
where you're testing as part of a Signed-off-by:.  Just be sure to state 
those three things above as part of the patch or series message.  The boot 
log can either be placed on a different page and linked to, or sent in 
another public E-mail.

If you can get two or three people to do the above, that's great - the 
more, the better.

...

These two steps do not apply to boards that I have in my testbed or which 
I have documentation for (although they would definitely be very welcome 
in those cases too).

