Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbaDCPpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:45:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:58935 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbaDCPoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:44:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,787,1389772800"; 
   d="scan'208";a="506251548"
Date: Thu, 3 Apr 2014 16:44:09 +0100
From: Damien Lespiau <damien.lespiau@intel.com>
To: Randy Dunlap <rdunlap@infradead.org>, Jani Nikula <jani.nikula@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-next@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: fix command parser debug print
 format mismatches
Message-ID: <20140403154409.GD18079@strange.amr.corp.intel.com>
References: <533B106B.8090408@infradead.org>
 <1396427060-12539-1-git-send-email-jani.nikula@intel.com>
 <533C2C1F.5010303@infradead.org>
 <20140403093230.GB7225@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140403093230.GB7225@phenom.ffwll.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 11:32:30AM +0200, Daniel Vetter wrote:
> On Wed, Apr 02, 2014 at 08:26:23AM -0700, Randy Dunlap wrote:
> > On 04/02/2014 01:24 AM, Jani Nikula wrote:
> > > Drop the cast from the pointer diff to fix:
> > > 
> > > drivers/gpu/drm/i915/i915_cmd_parser.c:405:4: warning: format '%td' expects
> > > argument of type 'ptrdiff_t', but argument 5 has type 'long unsigned int'
> > > [-Wformat]
> > > 
> > > While at it, use %u for u32.
> > > 
> > > Reported-by: Randy Dunlap <rdunlap@infradead.org>
> > > Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> > > 
> > > ---
> > > 
> > > Randy, try as I might, I wasn't able to coerce gcc to spit out that
> > > warning. Please enlighten me! (Does this fix the warn?)
> > 
> > Yes, it does.  Thanks.
> > 
> > Acked-by: Randy Dunlap <rdunlap@infradead.org>
> 
> Maybe I'm blind, but I think the recent refactoring patch fixed this. Can
> someone please double-check? I always get confused with printf formats ;-)

I fixed it a couple of weeks back:
  http://lists.freedesktop.org/archives/intel-gfx/2014-March/041886.html

-- 
Damien
