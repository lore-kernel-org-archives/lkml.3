Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaGGQEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 12:04:14 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:54564 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751056AbaGGQEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 12:04:13 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Date: Mon, 7 Jul 2014 17:04:02 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Thomas Meyer <thomas@m3y3r.de>, jikos@suse.cz,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Intel-gfx] Linux 3.16-rc2
Message-ID: <20140707160402.GA26405@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Thomas Meyer <thomas@m3y3r.de>, jikos@suse.cz,
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Pavel Machek <pavel@ucw.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <CA+55aFxdAhp-esuGiY4VEugiiwcMJgg1r6fPiR9Fb+HOz_5tLg@mail.gmail.com>
 <1403564870.3091.6.camel@localhost.localdomain>
 <871tuea7nz.fsf@intel.com>
 <20140624115753.GD17674@nuc-i3427.alporthouse.com>
 <1403612670.3091.10.camel@localhost.localdomain>
 <20140624122737.GF17674@nuc-i3427.alporthouse.com>
 <20140630100220.GA4934@xo-6d-61-c0.localdomain>
 <20140630100925.GA18836@nuc-i3427.alporthouse.com>
 <1404317921.3910.3.camel@localhost.localdomain>
 <20140707151613.GG5821@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140707151613.GG5821@phenom.ffwll.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 05:16:13PM +0200, Daniel Vetter wrote:
> On Wed, Jul 02, 2014 at 06:18:41PM +0200, Thomas Meyer wrote:
> > Hi,
> > 
> > this patch on top of v3.16-rc3-62-gd92a333 makes the resume from ram
> > regression go away on my machine:
> 
> Hm, we could conditionalize this hack on IS_G4X ... Chris, thoughts?

As different machines favour different w/a, I think the issue is mostly
timing related. It could be sequence of register writes, but we tried
different orders early on. The next experiment I guess would be to
insert small delays between each write to see if that helps. Or to write
each register twice.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
