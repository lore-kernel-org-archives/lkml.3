Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab3HOLgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 07:36:17 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:34140 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab3HOLgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 07:36:16 -0400
Date: Thu, 15 Aug 2013 13:36:23 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Damien Lespiau <damien.lespiau@intel.com>
Cc: Josh Triplett <josh@joshtriplett.org>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [Intel-gfx] [PATCH] i915: Add a Kconfig option to turn on
 i915.preliminary_hw_support by default
Message-ID: <20130815113622.GB776@phenom.ffwll.local>
Mail-Followup-To: Damien Lespiau <damien.lespiau@intel.com>,
	Josh Triplett <josh@joshtriplett.org>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	intel-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>
References: <20130813232130.GA20895@jtriplet-mobl1>
 <20130815105533.GA4490@strange.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130815105533.GA4490@strange.amr.corp.intel.com>
X-Operating-System: Linux phenom 3.11.0-rc2+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 11:55:33AM +0100, Damien Lespiau wrote:
> On Tue, Aug 13, 2013 at 04:23:17PM -0700, Josh Triplett wrote:
> > When building kernels for a preliminary hardware target, having to add a
> > kernel command-line option can prove inconvenient.  Add a Kconfig option
> > that changes the default of this option to 1.
> 
> FWIW, I like it (and had something similar in mind for this on other
> little parameters/debug features). 
> 
> Reviewed-by: Damien Lespiau <damien.lespiau@intel.com>
> 
> It doesn't apply cleanly to drm-intel/drm-intel-nightly which is the
> preferred branch to base patches on. Daniel might fix this himself as
> this is rather trivial to solve.

Yeah, -nightly is the preferred branch for everything. Queued for -next,
thanks for the patch.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
