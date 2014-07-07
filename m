Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaGGPcm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:32:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34778 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbaGGPcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:32:25 -0400
Date: Mon, 7 Jul 2014 17:32:23 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Daniel Vetter <daniel@ffwll.ch>
cc: Thomas Meyer <thomas@m3y3r.de>, Chris Wilson <chris@chris-wilson.co.uk>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Intel-gfx] Linux 3.16-rc2
In-Reply-To: <20140707151613.GG5821@phenom.ffwll.local>
Message-ID: <alpine.LNX.2.00.1407071731150.1655@pobox.suse.cz>
References: <CA+55aFxdAhp-esuGiY4VEugiiwcMJgg1r6fPiR9Fb+HOz_5tLg@mail.gmail.com> <1403564870.3091.6.camel@localhost.localdomain> <871tuea7nz.fsf@intel.com> <20140624115753.GD17674@nuc-i3427.alporthouse.com> <1403612670.3091.10.camel@localhost.localdomain>
 <20140624122737.GF17674@nuc-i3427.alporthouse.com> <20140630100220.GA4934@xo-6d-61-c0.localdomain> <20140630100925.GA18836@nuc-i3427.alporthouse.com> <1404317921.3910.3.camel@localhost.localdomain> <20140707151613.GG5821@phenom.ffwll.local>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2014, Daniel Vetter wrote:

> > this patch on top of v3.16-rc3-62-gd92a333 makes the resume from ram
> > regression go away on my machine:
> 
> Hm, we could conditionalize this hack on IS_G4X ... Chris, thoughts?

For the record, commenting out the code in stop_ring() the way Thomas did 
doesn't fix my problem (the one reported in [1]).

[1] https://bugs.freedesktop.org/show_bug.cgi?id=76554

-- 
Jiri Kosina
SUSE Labs
