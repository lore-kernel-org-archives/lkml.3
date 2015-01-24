Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbbAXU1e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 15:27:34 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:45679 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbbAXU1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 15:27:30 -0500
Date: Sat, 24 Jan 2015 12:27:26 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Matt Roper <matthew.d.roper@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        Ander Conselvan de Oliveira <conselvan2@gmail.com>,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [BUG, bisect] drm/i915: mouse pointer lags and
 overshoots
Message-ID: <20150124202726.GA1415@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Daniel Vetter <daniel.vetter@intel.com>,
	Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	David Airlie <airlied@linux.ie>,
	Alex Deucher <alexander.deucher@amd.com>,
	Dave Airlie <airlied@redhat.com>,
	Ander Conselvan de Oliveira <conselvan2@gmail.com>,
	linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org
References: <20150117100635.GA1281@hudson.localdomain>
 <20150119090847.GQ10649@intel.com>
 <54BCE1BF.5050808@intel.com>
 <20150119110404.GA26577@nuc-i3427.alporthouse.com>
 <20150119164024.GI22549@intel.com>
 <20150120054842.GN26519@phenom.ffwll.local>
 <20150124065732.GA17057@hudson.localdomain>
 <20150124112455.GE10113@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150124112455.GE10113@phenom.ffwll.local>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel, Matt,

On Sat, Jan 24, 2015 at 12:24:55PM +0100, Daniel Vetter wrote:
> On Fri, Jan 23, 2015 at 10:57:32PM -0800, Jeremiah Mahler wrote:
> > all,
> > 
> > On Tue, Jan 20, 2015 at 06:48:42AM +0100, Daniel Vetter wrote:
> > > On Mon, Jan 19, 2015 at 08:40:24AM -0800, Matt Roper wrote:
> > > > On Mon, Jan 19, 2015 at 11:04:04AM +0000, Chris Wilson wrote:
> > > > > On Mon, Jan 19, 2015 at 11:51:43AM +0100, Daniel Vetter wrote:
[...]
>     drm/plane-helper: Skip prepare_fb/cleanup_fb when newfb==oldfb
> 
> that should rectify the sluggish i915 cursor. But it's in a separate topic
> branch which isn't in linux-next. Should show up in drm-next next week
> though.
> -Daniel
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch

I found the patch and tried it out.  It does fix the mouse pointer
problem.  Thanks for the fix.

-- 
- Jeremiah Mahler
