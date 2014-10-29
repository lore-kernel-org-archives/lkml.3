Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473AbaJ2JtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:49:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35484 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755889AbaJ2JtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:49:10 -0400
Date: Wed, 29 Oct 2014 10:49:08 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
cc: Andrew de los Reyes <andrew-vger@gizmolabs.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>
Subject: Re: [PATCH 00/13] HID: add support of Logitech touchpads and special
 devices
In-Reply-To: <CAN+gG=GET=FLmte9kQOtS+x=HPaTdgEu4HxuydHXBx1GZksNRw@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1410291048320.20256@pobox.suse.cz>
References: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com> <alpine.LNX.2.00.1410011016160.26311@pobox.suse.cz> <20141001131008.GB18756@mail.corp.redhat.com> <CAG_cf+fYGATBL9Sgvvp7CaScP112fiqiyuR0gBdkS-424S3Kog@mail.gmail.com>
 <alpine.LNX.2.00.1410031308360.14259@pobox.suse.cz> <CAN+gG=GET=FLmte9kQOtS+x=HPaTdgEu4HxuydHXBx1GZksNRw@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2014, Benjamin Tissoires wrote:

> >> I've tested these patches successfully on a Chromebook Pixel with the
> >> following devices:
> >>
> >> - T650 touchpad
> >> - TK820 keyboard/touchpad
> >> - Original WTP touchpad
> >>
> >> I also tested a touch mouse and as expected it continued to function
> >> as a plain USB mouse. The TK820 was indeed broken into two devices,
> >> with autorepeat enabled for the keyboard only. The other two devices
> >> behaved as expected with no perceived regressions.
> >>
> >> In short, from a functionality perspective I'm happy with these
> >> patches. I will let others discuss code structure.
> >
> > Thank you. Can I use
> >
> >         Tested-by: Andrew de los Reyes <andrew-vger@gizmolabs.org>
> >
> > once / if I am merging this patchset?
> >
> 
> I am pretty sure this is not required too, but I am raising this one
> again in Jiri's pile of things to review.
> Sorry Jiri, I did not forget about it :)

It absolutely hasn't been forgotten, I've been just a bit busy during past 
weeks.

I am almost done with the review, expect to hear from me in a 1-2 days 
timeframe regarding this series.

Thanks for patience,

-- 
Jiri Kosina
SUSE Labs
