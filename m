Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806Ab3HJU3Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 16:29:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758783Ab3HJU3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 16:29:23 -0400
Date: Sat, 10 Aug 2013 22:29:17 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Pavel Machek <pavel@ucw.cz>, Belisko Marek <marek.belisko@gmail.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@osdl.org>,
        Tony Lindgren <tony@atomide.com>, b-cousson@ti.com,
        pali.rohar@gmail.com, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2] N900: add device tree
In-Reply-To: <CAAfyv34w1e+sAuB==-+Pj2gOO1auVNQgawcNC1Z4QfeqchRh3g@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1308102226220.32627@pobox.suse.cz>
References: <20130614212816.GA31768@atrey.karlin.mff.cuni.cz> <20130617111031.GQ20992@atomide.com> <20130701211753.GC15318@amd.pavel.ucw.cz> <20130704171939.GA27374@blackmetal.musicnaut.iki.fi> <20130704202145.GB10752@amd.pavel.ucw.cz>
 <20130704203256.GB27374@blackmetal.musicnaut.iki.fi> <20130713121709.GC16473@amd.pavel.ucw.cz> <20130714222819.GB3296@blackmetal.musicnaut.iki.fi> <20130728134409.GB5382@amd.pavel.ucw.cz> <20130801234355.GA15611@amd.pavel.ucw.cz> <20130810110955.GA11437@amd.pavel.ucw.cz>
 <CAAfyv34w1e+sAuB==-+Pj2gOO1auVNQgawcNC1Z4QfeqchRh3g@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Aug 2013, Pavel Machek wrote:

> [I wonder if this is clean-enough cause for "trivial in resubmit
> mode?]

On Sat, 10 Aug 2013, Belisko Marek wrote:

> Same for gta04 (omap3 based device) [1].
> It was send upstream 2 times and second time there is no reply from 1.3.2013.

Hi guys,

once I am able to match signoffs in the patches to MAINTAINERS, I can take 
those through trivial.git in "re-transmission mode" (or feeeding those 
thgough akpm si an option as well).

Please just send the patches to me in a new thread properly with all the 
Acks/Signoffs, and mark those appropriately (i.e. maintainer that would 
normally push this upstream desurfaced).

-- 
Jiri Kosina
SUSE Labs
