Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbaCJJ3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:29:32 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:60135 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752120AbaCJJ3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:29:30 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Mon, 10 Mar 2014 09:29:19 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Sagar Arun Kamble <sagar.a.kamble@intel.com>
Cc: Alex Deucher <alexdeucher@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>
Subject: Re: [Intel-gfx] [PATCH v3 1/1] drm/i915: Enabling 128x128 and
 256x256 ARGB Cursor Support
Message-ID: <20140310092919.GG20302@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Sagar Arun Kamble <sagar.a.kamble@intel.com>,
	Alex Deucher <alexdeucher@gmail.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Maling list - DRI developers <dri-devel@lists.freedesktop.org>
References: <20140224160628.GU3852@intel.com>
 <1394304546-19433-1-git-send-email-sagar.a.kamble@intel.com>
 <CADnq5_P_j66y2j3v8r9jHOffhfz3L3_fQpnP-OFdfOeLEWqs8A@mail.gmail.com>
 <1394305472.18918.1.camel@sagar-desktop>
 <1394305669.18918.3.camel@sagar-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394305669.18918.3.camel@sagar-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 09, 2014 at 12:37:49AM +0530, Sagar Arun Kamble wrote:
> On Sun, 2014-03-09 at 00:34 +0530, Sagar Arun Kamble wrote:
> > On Sat, 2014-03-08 at 13:51 -0500, Alex Deucher wrote:
> > > On Sat, Mar 8, 2014 at 1:49 PM,  <sagar.a.kamble@intel.com> wrote:
> > > > From: Sagar Kamble <sagar.a.kamble@intel.com>
> > > >
> > > > With this patch we allow larger cursor planes of sizes 128x128
> > > > and 256x256.
> > > >
> > > > v2: Added more precise check on size while setting cursor plane.
> > > >
> > > > v3: Changes related to restructuring cursor size restrictions
> > > > and DRM_DEBUG usage.
> > > >
> > > 
> > > I'm not sure how useful it is since you appear to be able to
> > > selectively adjust the cursor size, but I recently added support for
> > > exposing the cursor size as a drm cap:
> > > http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=8716ed4e7bed4e4c7e3f37940e950ddc0362f450
> > > 
> > > Alex
> > Thanks Alex. This is useful for cursor test to enumerate sub-tests based
> > on these caps.
> Realized after sending mail that we just get to know current cursor
> width and height. Can we have capability that exposes all supported
> cursor sizes?

The cap exposes the max cursor size. Knowing our hardware we can infer
that pot sizes from 64 to max are supported, but it would be better if
we did expose that information through the cap as well.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
