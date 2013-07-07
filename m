Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab3GGMdi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 08:33:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35964 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab3GGMdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 08:33:37 -0400
Date: Sun, 7 Jul 2013 13:32:40 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Olof Johansson <olof@lixom.net>, Mark Brown <broonie@kernel.org>,
        Jonathan Austin <jonathan.austin@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        LinusW <linus.walleij@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: amba-pl08x and 'get_signal' namespace collision/build error
Message-ID: <20130707123240.GO24642@n2100.arm.linux.org.uk>
References: <51C97F40.5030101@arm.com> <20130625184539.GB2718@n2100.arm.linux.org.uk> <20130626044842.GR23141@intel.com> <20130626081909.GD2718@n2100.arm.linux.org.uk> <20130626103930.GS23141@intel.com> <20130627094650.GC4283@n2100.arm.linux.org.uk> <CAOesGMgSPNggnBm=E3B774m7Ad_QMXdqvcGqRMxhap6dtpNtCg@mail.gmail.com> <20130705061802.GB10947@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130705061802.GB10947@intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 11:48:02AM +0530, Vinod Koul wrote:
> On Wed, Jul 03, 2013 at 11:27:12AM -0700, Olof Johansson wrote:
> > This has now hit the mainline kernel, and several defconfigs (nhk815,
> > lpc32xx and the spear ones) are broken there.
> > 
> > Vinod, when are you sending up your pull request with the fix? It'd be
> > good to see it go in soon.
> It should be on its way by the weekend

It still isn't in the tree.

Personally, I think that the fix should have come via my tree, because
the breakage was caused my the changes in my tree - and for the last week
or more I've not been able to build any of these ARM Ltd devel platforms
because of this bug.

It also means that I'm not able to build test a load of changes I'm
currently working on against a recent kernel (or indeed any v3.10 kernel.)
In other words, the lack of this patch being merged is stopping me from
doing my job properly.  (Consider from your perspective: if I were to
break something you relied upon for a couple of weeks, how would you
feel about it?)

Please get this fix into mainline ASAP - even if you have to send it as a
patch separately to Linus rather than putting it as part of your normal
pull request.

Thanks.
