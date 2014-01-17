Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaAQNb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 08:31:26 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60779 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751767AbaAQNbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 08:31:23 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Paul Drews <paul.drews@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Nyman, Mathias" <mathias.nyman@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Baytrail problems (was Re: Linux 3.13-rc8)
Date: Fri, 17 Jan 2014 14:45:25 +0100
Message-ID: <1982480.c0XMpSRGR2@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc8+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <99308060.pSzgvg98VT@vostro.rjw.lan>
References: <CA+55aFzcHCg1Azf0t4KrYx0N1z0xaeT8fNHJEW5og3VBd+UPOA@mail.gmail.com> <2029519.Z7OA0cinWM@vostro.rjw.lan> <99308060.pSzgvg98VT@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 17, 2014 02:38:32 PM Rafael J. Wysocki wrote:
> On Thursday, January 16, 2014 05:01:19 PM Rafael J. Wysocki wrote:
> > On Thursday, January 16, 2014 10:29:45 AM Linus Walleij wrote:
> > > On Thu, Jan 16, 2014 at 2:49 AM, Linus Torvalds
> > > <torvalds@linux-foundation.org> wrote:
> > > > Adding in the appropriate people...
> > > >
> > > > On Tue, Jan 14, 2014 at 7:01 PM, One Thousand Gnomes
> > > > <gnomes@lxorguk.ukuu.org.uk> wrote:
> > > >>
> > > >> It seems to hate Baytrail/T
> > > >>
> > > >> My ASUS T100TA has gone from 3.11 'needs video=VGA-1:blah' to get the mode
> > > >> right but otherwise running nicely and playing 3D games to 3.13-rc8
> > > >>
> > > >> - crashes and burns during boot if the Baytrail pinctrl driver is compiled
> > > >>   in
> > > >
> > > > Andy, Paul? The changes to the pinctrl driver since 3.11 look trivial,
> > > > but I guess the GPIO and ACPI ID addition ends up also enabling all
> > > > the old code that Alan probably never ran in 3.11 because the driver
> > > > didn't trigger on his machine.
> > > 
> > > So that is commit f6308b36c411dc5
> > > "ACPI: Add BayTrail SoC GPIO and LPSS ACPI IDs"?
> > > 
> > > This seems to have been selected for -stable as well so the
> > > problem will be spreading as distros start pushing stable kernel
> > > updates :-(
> > > 
> > > That came in through the ACPI tree, Rafael do you want to
> > > revert it if there is no better quickfix?
> > 
> > Yes, I'll push either a revert or a fix before the weekend.
> 
> OK, I haven't seen any fixes for this so far, so I'm queing up a revert of
> commit f6308b36c411dc5 to be pushed later today.

BTW, I haven't tagged it for stable, so I'm not sure who has requested
stable to include it and why.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
