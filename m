Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbaGNRnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:43:10 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57034 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752174AbaGNRnD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:43:03 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [BISECTED 3.16-rc REGREGRESSION] backlight control stopped working
Date: Mon, 14 Jul 2014 20:01:14 +0200
Message-ID: <3905689.dLVXZ99cEJ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CA+55aFxYYKApOC+1TQkoxSzi-zTSB8OmkU=ypvNb_Gc2+K6Hmw@mail.gmail.com>
References: <87pph8kse7.fsf@nemi.mork.no> <53C3D7C3.7090505@redhat.com> <CA+55aFxYYKApOC+1TQkoxSzi-zTSB8OmkU=ypvNb_Gc2+K6Hmw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 14, 2014 09:24:16 AM Linus Torvalds wrote:
> On Mon, Jul 14, 2014 at 6:14 AM, Hans de Goede <hdegoede@redhat.com> wrote:
> >
> > This *not* a regression, it is an intended behavior change [..]
> 
> That counts as a regression.
> 
> If things used to work, and they don't work, it's a regression. If
> it's intentional, that just makes it worse.
> 
> > Yes this may break existing configurations for some users, most likely
> > users running some custom setup, who thus should be able to fix things
> > by adding one more customization to there setup.
> 
> .. and apparently this whole paragraph is completely bogus. It *does*
> break things, and for normal people. That's what the bug report is all
> about. So don't waffle about it.
> 
> Bjørn, what's your setup? Is this perhaps solvable some other way?
> 
> > TL;DR: This change really is for the better and is here to stay.
> 
> Wrong. We don't break existing setups, and your attitude needs fixing.
> 
> Rafael, please get it reverted, or I will have to revert it.

I've queued up a revert already.  I'll include it into my next pull
request later this week.

Rafael

