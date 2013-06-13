Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310Ab3FMIWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 04:22:16 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:50868 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab3FMIWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 04:22:12 -0400
Date: Thu, 13 Jun 2013 10:22:05 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Jani Nikula <jani.nikula@intel.com>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        chris@chris-wilson.co.uk, daniel@ffwll.ch
Subject: Re: [PATCH 0/3]
Message-ID: <20130613082205.GL22870@phenom.ffwll.local>
Mail-Followup-To: Jani Nikula <jani.nikula@intel.com>,
	linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	chris@chris-wilson.co.uk
References: <cover.1370525922.git.jani.nikula@intel.com>
 <87d2rzl4qp.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2rzl4qp.fsf@intel.com>
X-Operating-System: Linux phenom 3.9.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 04:59:26PM +0300, Jani Nikula wrote:
> 
> With Greg's address fixed. Please drop the old one from any
> replies. Sorry for the noise.

Oops, replied with the old one still there.

Greg, Andrew: Imo it's best to merge all three patches through the same
tree, so:

Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>

on the i915 parts of it. If you want I can also slurp them in through the
intel tree, including the new dmi match code.

Thanks, Daniel

> 
> On Thu, 06 Jun 2013, Jani Nikula <jani.nikula@intel.com> wrote:
> > Hi Greg, Andrew -
> >
> > Patch 1 is for DMI, bugfixes in patches 2-3 for i915 and included for
> > completeness. After a tested-by they should be good for stable. I'll
> > leave it to Daniel to sort out how the last two get in.
> >
> > BR,
> > Jani.
> >
> > Chris Wilson (1):
> >   drm/i915: Quirk away phantom LVDS on Intel's D510MO mainboard
> >
> > Jani Nikula (2):
> >   dmi: add support for exact DMI matches in addition to substring
> >     matching
> >   drm/i915: Quirk away phantom LVDS on Intel's D525MW mainboard
> >
> >  drivers/firmware/dmi_scan.c       |   12 +++++++++---
> >  drivers/gpu/drm/i915/intel_lvds.c |   16 ++++++++++++++++
> >  include/linux/mod_devicetable.h   |    6 ++++--
> >  3 files changed, 29 insertions(+), 5 deletions(-)
> >
> > -- 
> > 1.7.9.5
> >
> 
> -- 
> Jani Nikula, Intel Open Source Technology Center

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
