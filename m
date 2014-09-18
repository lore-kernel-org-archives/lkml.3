Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbaIRK6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 06:58:49 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33968 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307AbaIRK6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 06:58:48 -0400
Date: Thu, 18 Sep 2014 12:03:29 +0100
From: "Carlos R. Mafra" <crmafra@gmail.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org
Subject: Re: [Intel-gfx] External monitor issues with 3.17-rc4 and i915	module
Message-ID: <20140918110329.GA4687@linux-g29b.site>
References: <20140909215430.GA3710@linux-g29b.site>
 <20140916095419.GA8548@linux-g29b.site>
 <87vbomvdwi.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vbomvdwi.fsf@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2014 at 11:39:57 +0300, Jani Nikula wrote:
> On Tue, 16 Sep 2014, "Carlos R. Mafra" <crmafra@gmail.com> wrote:
> > Hi, the same happens with 3.17-rc5. The kernel is unfortunately
> > unusable with my external monitor because after some plug, unplug
> > and suspend to RAM cycles the behaviour is not good (sometimes
> > it freezes, sometimes X needs a restart).
> >
> > Sorry to ask, but is there someone looking at this? I can provide
> > more information if necessary.
> 
> Please file a new bug against DRM/Intel at [1] so we don't lose track of
> it.

https://bugs.freedesktop.org/show_bug.cgi?id=84038

> Is this a regression? Which version worked? Can you do a bisect?

On v3.16.1 the warning is different and I get fewer. On v3.12.18 it works,
but the kernel has other issues there related to wireless so I don't use
it that often.

I could try to bisect the first appearance of any warning, but it would
require some time (this is my work laptop).

> Please attach full dmesg with drm.debug=0xe module parameter set from
> early boot to the problem.

It is attached in the bug report at freedesktop now.
