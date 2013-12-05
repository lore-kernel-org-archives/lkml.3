Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab3LESnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:43:31 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:31594 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757062Ab3LESna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:43:30 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ycZwIC2IagHl+zd+Ij6ql
Date: Thu, 5 Dec 2013 10:43:23 -0800
From: Tony Lindgren <tony@atomide.com>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Subject: Re: [PATCH] omap: twl-common: Fix musb-hdrc device name.
Message-ID: <20131205184323.GF26766@atomide.com>
References: <1386059589-4030-1-git-send-email-marek.belisko@open-nandra.com>
 <529D9D43.6040101@ti.com>
 <CAAfyv37Vie1vZK2XQ1cfVq6eVnSuaBLfykk6pU8fwEyqvPF4BA@mail.gmail.com>
 <CAAfyv35gVVNydrk8vifSyidpFjEXjGiT4-i2dgN5Un2=FuHaqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAfyv35gVVNydrk8vifSyidpFjEXjGiT4-i2dgN5Un2=FuHaqQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Belisko Marek <marek.belisko@gmail.com> [131203 01:21]:
> On Tue, Dec 3, 2013 at 10:08 AM, Belisko Marek <marek.belisko@gmail.com> wrote:
> > Hi,
> >
> > On Tue, Dec 3, 2013 at 9:58 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> >> Hi,
> >>
> >> On Tuesday 03 December 2013 02:03 PM, Marek Belisko wrote:
> >>> Without this change when booting omap3 device (gta04) with board file
> >>> leads to follwing errors:
> >>>
> >>> [    1.203308] musb-hdrc musb-hdrc.0.auto: unable to find phy
> >>> [    1.209075] HS USB OTG: no transceiver configured
> >>> [    1.214019] musb-hdrc musb-hdrc.0.auto: musb_init_controller failed with status -517
> >>>
> >>> and usb isn't working.
> >>>
> >>> This is probably regression caused by commit: 6c27f939
> >>
> >> I think a better fix would be to have this merged..
> >> https://lkml.org/lkml/2013/7/26/91
> > Yes I see but how this could help with current situation? Ho you then
> > specify device number?
> I was too fast with reply sorry. I can see whole series and it is of
> course correct solution. But as I said
> can we except to be merged to 3.13. If not Tony can you pick my patch.

If it's a regression, then let's get it merged for the -rc cycle.

So please try to follow up on getting the proper fix merged, meanwhile
I'll mark this thread as read. If you need this one merged for some
reason, then please report to get it back to my radar.

Regards,

Tony
