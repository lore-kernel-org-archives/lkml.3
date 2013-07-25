Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab3GYHsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 03:48:05 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:53817 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab3GYHsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 03:48:00 -0400
Date: Thu, 25 Jul 2013 09:47:57 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 4/5] drm/i915: Add async page flip support for IVB
Message-ID: <20130725074757.GE5939@phenom.ffwll.local>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
	dri-devel@lists.freedesktop.org
References: <1374544202-15496-1-git-send-email-keithp@keithp.com>
 <1374544202-15496-5-git-send-email-keithp@keithp.com>
 <20130723052856.GD5939@phenom.ffwll.local>
 <86li4v3ds7.fsf@miki.keithp.com>
 <20130724212308.GZ5939@phenom.ffwll.local>
 <86siz3v2m7.fsf@miki.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86siz3v2m7.fsf@miki.keithp.com>
X-Operating-System: Linux phenom 3.11.0-rc2+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 06:40:16PM -0700, Keith Packard wrote:
> Daniel Vetter <daniel@ffwll.ch> writes:
> 
> > We could just unconditionally increase the alignement in
> > intel_pin_and_fence_fb_obj - we already have more strict requirements due
> > to a bunch of w/a in other places. So shouldn't hurt at all really.
> 
> That seems like a fine plan; 32kB isn't that onerous. Do you want the
> trivial patch to do this from me then?

Yes please, merging patches from other people is much easier than begging for
review for my own ;-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
