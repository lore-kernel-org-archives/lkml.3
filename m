Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbaCaQWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 12:22:06 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:47450 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbaCaQWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 12:22:04 -0400
Date: Mon, 31 Mar 2014 17:22:00 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jamie Iles <jamie@jamieiles.com>, Alan Tull <atull@altera.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>
Subject: Re: [PATCH 1/3] gpio: dwapb: drop irq_setup_generic_chip()
Message-ID: <20140331162200.GB2579@page.Home>
References: <1395345324-18299-1-git-send-email-bigeasy@linutronix.de>
 <1395345324-18299-2-git-send-email-bigeasy@linutronix.de>
 <CACRpkdY3ctcLNhpSWtuqj=d48_fqDyNzG9nGAorpAbwjAnOJUw@mail.gmail.com>
 <CACRpkdbu6LKLntP2J=ypLTrAYscvzf5WjPYb-E+RKH_vAPEYHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbu6LKLntP2J=ypLTrAYscvzf5WjPYb-E+RKH_vAPEYHg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 09:37:50PM +0100, Linus Walleij wrote:
> Aha Jamie not even on the original thread. Here.
> 
> On Tue, Mar 25, 2014 at 9:37 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Thu, Mar 20, 2014 at 8:55 PM, Sebastian Andrzej Siewior
> > <bigeasy@linutronix.de> wrote:
> >
> >> This looks kinda wrong I didn't manage to fully test it.
> >> The driver calls irq_alloc_domain_generic_chips() which creates a gc and
> >> adds it to gc_list. The driver later then calls irq_setup_generic_chip()
> >> which also initializes the gc and adds it to the gc_list() and this
> >> corrupts the list.
> >> I can't find a single chip in tree which uses both functions so I think
> >> that irq_setup_generic_chip() can be dropped.
> >>
> >> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> >
> > Jamie: comments?

I don't have anything to add to either yours or Alan's comments.  I'll 
be more than happy to review the versions with the generic helpers if 
I'm copied onto the review.

Thanks,

Jamie
