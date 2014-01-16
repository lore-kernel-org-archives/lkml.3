Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaAPK7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 05:59:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:58760 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbaAPK6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 05:58:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,667,1384329600"; 
   d="scan'208";a="459773206"
Message-ID: <1389869908.1871.347.camel@smile>
Subject: Re: Baytrail problems (was Re: Linux 3.13-rc8)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        "Nyman, Mathias" <mathias.nyman@intel.com>,
        "Westerberg, Mika" <mika.westerberg@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Paul Drews <paul.drews@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 16 Jan 2014 12:58:28 +0200
In-Reply-To: <CACRpkdZqdaq7qqwhvfufa9BNUAeO4CFAr6g4uqXvbe5wsAYaQQ@mail.gmail.com>
References: <CA+55aFzcHCg1Azf0t4KrYx0N1z0xaeT8fNHJEW5og3VBd+UPOA@mail.gmail.com>
	 <CACRpkdZqdaq7qqwhvfufa9BNUAeO4CFAr6g4uqXvbe5wsAYaQQ@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-16 at 10:29 +0100, Linus Walleij wrote:
> On Thu, Jan 16, 2014 at 2:49 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > Adding in the appropriate people...
> >
> > On Tue, Jan 14, 2014 at 7:01 PM, One Thousand Gnomes
> > <gnomes@lxorguk.ukuu.org.uk> wrote:
> >>
> >> It seems to hate Baytrail/T
> >>
> >> My ASUS T100TA has gone from 3.11 'needs video=VGA-1:blah' to get the mode
> >> right but otherwise running nicely and playing 3D games to 3.13-rc8
> >>
> >> - crashes and burns during boot if the Baytrail pinctrl driver is compiled
> >>   in
> >
> > Andy, Paul? The changes to the pinctrl driver since 3.11 look trivial,
> > but I guess the GPIO and ACPI ID addition ends up also enabling all
> > the old code that Alan probably never ran in 3.11 because the driver
> > didn't trigger on his machine.
> 
> So that is commit f6308b36c411dc5
> "ACPI: Add BayTrail SoC GPIO and LPSS ACPI IDs"?
> 
> This seems to have been selected for -stable as well so the
> problem will be spreading as distros start pushing stable kernel
> updates :-(
> 
> That came in through the ACPI tree, Rafael do you want to
> revert it if there is no better quickfix?

It seems Mathias and Mika (Cc:ed) already heard about the issue and have
been working on the solution.

> 
> This adds an interesting twist to the general statement that
> new PCI/ACPI IDs should go into stable BTW, maybe they
> should not always do that.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

