Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbaJUPOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 11:14:30 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:16845 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715AbaJUPO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 11:14:28 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX193mIlQDRvoqRiip7BCJkZlfOZ3aoMgFXQ=
X-DKIM: OpenDKIM Filter v2.0.1 titan 201606044BF
Date: Tue, 21 Oct 2014 11:14:15 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Grzegorz Jaszczyk <jaz@semihalf.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tglx@linutronix.de,
        gregory.clement@free-electrons.com,
        thomas.petazzoni@free-electrons.com, alior@marvell.com,
        tawfik@marvell.com, mw@semihalf.com
Subject: Re: [PATCH 0/2] Marvell Armada 375/38x MPIC/MSI fixes
Message-ID: <20141021151415.GU17447@titan.lakedaemon.net>
References: <1411643839-64925-1-git-send-email-jaz@semihalf.com>
 <20141003135017.GH3895@titan.lakedaemon.net>
 <54466B73.3090704@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54466B73.3090704@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 11:19:31AM -0300, Ezequiel Garcia wrote:
> On 10/03/2014 10:50 AM, Jason Cooper wrote:
> > On Thu, Sep 25, 2014 at 01:17:17PM +0200, Grzegorz Jaszczyk wrote:
> >> This patchset contains a set of fixes for issues found while doing some test
> >> with different interrupts configuration on Armada 375 and Armada 38x Marvell
> >> SoCs. The patches were tested and apply on v3.17-rc6.
> >>
> >> Any feedback is welcome.
> >>
> >> Grzegorz Jaszczyk (2):
> >>   irqchip: armada-370-xp: fix MSI interrupt handling
> >>   irqchip: armada-370-xp: fix MPIC interrupt handling
> >>
> >>  drivers/irqchip/irq-armada-370-xp.c | 23 +++++++++++++++++------
> >>  1 file changed, 17 insertions(+), 6 deletions(-)
> > 
> > Ah crap.  This slipped off my plate.  Sorry about that.  I've now
> > applied these to irqchip/urgent with Ezequiel's Ack.  I'll get them into
> > -next and hopefully do a PR toward the end of next week.
> > 
> 
> Jason,
> 
> The patches don't seem to be in v3.18-rc1 for some reason.

Correct.

> I can't seem to find your PR (probably because I've switched to
> Thunderbird now
> and it's a pain to search mails properly).

Some folks seem to like Claws.  There hasn't been a PR yet, though.

> Since this is an important fix, maybe you can schedule it for -rc2?

I have.  For some reason I have yet to delve into, there were no
linux-next's during the merge window.  As a result, yesterday's -next
was the first for the two patches in question.  I'd like to get them
pushed for -rc2, so I'll probably send the PR tomorrow to get one more
day in -next.

thx,

Jason.
