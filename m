Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbaGHM7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:59:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912AbaGHM7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:59:53 -0400
Date: Tue, 8 Jul 2014 14:59:50 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Chris Wilson <chris@chris-wilson.co.uk>
cc: Thomas Meyer <thomas@m3y3r.de>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Intel-gfx] Linux 3.16-rc2
In-Reply-To: <20140708125522.GL26405@nuc-i3427.alporthouse.com>
Message-ID: <alpine.LNX.2.00.1407081456560.1655@pobox.suse.cz>
References: <1403612670.3091.10.camel@localhost.localdomain> <20140624122737.GF17674@nuc-i3427.alporthouse.com> <20140630100220.GA4934@xo-6d-61-c0.localdomain> <20140630100925.GA18836@nuc-i3427.alporthouse.com> <1404317921.3910.3.camel@localhost.localdomain>
 <20140707151613.GG5821@phenom.ffwll.local> <20140707160402.GA26405@nuc-i3427.alporthouse.com> <alpine.LNX.2.00.1407080013030.1655@pobox.suse.cz> <20140708085901.GI26405@nuc-i3427.alporthouse.com> <alpine.LNX.2.00.1407081445310.1655@pobox.suse.cz>
 <20140708125522.GL26405@nuc-i3427.alporthouse.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2014, Chris Wilson wrote:

> > Tried on top of current Linus' tree, and no improvement. ring 
> > initialization failure upon resume, and window redrawing hosed.
> 
> Which error during ring-init are you hitting?

It's still the same I reported in 
bugs.freedesktop.org/show_bug.cgi?id=76554

[drm:init_ring_common] *ERROR* render ring initialization failed ctl 0001f001 (valid? 1) head 000f645c tail 00000000 start 000e4000 [expected 000e4000]
[drm:__i915_drm_thaw] *ERROR* failed to re-initialize GPU, declaring wedged!

-- 
Jiri Kosina
SUSE Labs
