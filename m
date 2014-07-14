Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbaGNR6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:58:43 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62024 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751334AbaGNR6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:58:37 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jenny Tc <jenny.tc@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Sebastian Reichel <sre@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Belisko Marek <marek.belisko@gmail.com>
Subject: Re: Power Supply Subsystem Maintainer
Date: Mon, 14 Jul 2014 20:16:50 +0200
Message-ID: <1575662.I3Mx6rb0oJ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CALT56yPehFRfZu-PpPR9UeJV9b9f6azVa3QouAzwY726x-v=+g@mail.gmail.com>
References: <20140630111640.GA13774@jenny-desktop> <20140707112000.028524371bb7e234fcf79205@linux-foundation.org> <CALT56yPehFRfZu-PpPR9UeJV9b9f6azVa3QouAzwY726x-v=+g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 12, 2014 09:21:35 PM Dmitry Eremin-Solenikov wrote:
> Hello,
> 
> On Mon, Jul 7, 2014 at 10:20 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Wed, 2 Jul 2014 08:41:19 +0530 Jenny Tc <jenny.tc@intel.com> wrote:
> >
> >> Andrew Morton,
> >>
> >> Appreciate your help to sort out the power supply maintainer issue. The
> >> subsystem is not active after February 2014. No response from maintainer and the
> >> last commit on git://git.infradead.org/battery-2.6 was on 2014-02-01. Appreciate
> >> your help.
> >
> > Well, two weeks ago Dmitry did say that he'd been busy at work and
> > planned to pick things up again soon.
> >
> > Dmitry, could you please make a firm and realistic decision one way or
> > the other?  If it isn't truly going to happen then that's OK - these
> > things happen.  But please tell us so other arrangements can be put in
> > place if that's the way we'll be proceeding.
> 
> Well, I am sorry. I promised that I will have time for this, but it
> seems things did not go
> the way I expected. Sebastian volunteered  to pick up power/reset
> maintainership,
> so if he still is willing to work on that topic, I'll ack a patch
> transferring maintainership
> to him.
> 
> As a side note, I'd suggest to also open a mailing list either on
> infradead.org (David, I
> made several requests, to n/a) or on vger.kernel.org.

linu-pm can be used for that I suppose?

Rafael

