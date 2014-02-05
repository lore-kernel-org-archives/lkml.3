Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaBEJiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 04:38:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:26555 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbaBEJhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 04:37:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,785,1384329600"; 
   d="scan'208";a="470163510"
Date: Wed, 5 Feb 2014 17:37:26 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        "Jin, Gordon" <gordon.jin@intel.com>,
        yangguang <guang.a.yang@intel.com>
Subject: Re: [PATCH] MAINTAINERS: Update drm/i915 git repo
Message-ID: <20140205093726.GA18849@localhost>
References: <1391540451-24169-1-git-send-email-daniel.vetter@ffwll.ch>
 <CAKMK7uHe99TVmzf6jHe9C-qetUPvqgJ6kzQUK7BBmVFyDNTtiQ@mail.gmail.com>
 <CAKMK7uEJDcUbFE77X2yKLPMtLN=4_hkXpbgAnhDYQQdbbXQ9QA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uEJDcUbFE77X2yKLPMtLN=4_hkXpbgAnhDYQQdbbXQ9QA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 08:54:15AM +0100, Daniel Vetter wrote:
> On Tue, Feb 4, 2014 at 8:37 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > On Tue, Feb 4, 2014 at 8:00 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> >> Moved to a common location so that Jani also can push to it, to avoid
> >> moving it every time I go on vacation. Please update autobuilders and
> >> everything else pointing at the drm-intel.git repo, the old one won't
> >> be updated any more.
> >>
> >> Cc: Dave Airlie <airlied@gmail.com>
> >> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> >> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> >
> > Also forgotten to cc our QA people ...
> 
> And Wu Fengguang with his 0-day builder also needs to know about the
> new git repo!

Yeah updated, thank you for the info!

Fengguang

> -Daniel
> 
> >> ---
> >>  MAINTAINERS | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> index 31a046213274..e3aaf277cf58 100644
> >> --- a/MAINTAINERS
> >> +++ b/MAINTAINERS
> >> @@ -2832,7 +2832,7 @@ M:        Jani Nikula <jani.nikula@linux.intel.com>
> >>  L:     intel-gfx@lists.freedesktop.org
> >>  L:     dri-devel@lists.freedesktop.org
> >>  Q:     http://patchwork.freedesktop.org/project/intel-gfx/
> >> -T:     git git://people.freedesktop.org/~danvet/drm-intel
> >> +T:     git git://anongit.freedesktop.org/drm-intel
> >>  S:     Supported
> >>  F:     drivers/gpu/drm/i915/
> >>  F:     include/drm/i915*
> >> --
> >> 1.8.5.2
> >>
> >
> >
> >
> > --
> > Daniel Vetter
> > Software Engineer, Intel Corporation
> > +41 (0) 79 365 57 48 - http://blog.ffwll.ch
> 
> 
> 
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
