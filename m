Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab3BFJS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 04:18:59 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:65507 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab3BFJS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 04:18:56 -0500
Date: Wed, 6 Feb 2013 10:21:08 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 1/3] PM: make VT switching to the suspend
 console optional v3
Message-ID: <20130206092108.GI5813@phenom.ffwll.local>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org
References: <1359985042-2610-1-git-send-email-jbarnes@virtuousgeek.org>
 <1452100.EKe1it2LWl@vostro.rjw.lan>
 <20130205135544.6adab270@jbarnes-t420>
 <2155667.rslrpFmW0n@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2155667.rslrpFmW0n@vostro.rjw.lan>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 11:02:17PM +0100, Rafael J. Wysocki wrote:
> On Tuesday, February 05, 2013 01:55:44 PM Jesse Barnes wrote:
> > On Mon, 04 Feb 2013 21:26:26 +0100
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > On Monday, February 04, 2013 01:37:20 PM Jesse Barnes wrote:
> > > > KMS drivers can potentially restore the display configuration without
> > > > userspace help.  Such drivers can can call a new funciton,
> > > > pm_vt_switch_required(false) if they support this feature.  In that
> > > > case, the PM layer won't VT switch to the suspend console at suspend
> > > > time and then back to the original VT on resume, but rather leave things
> > > > alone for a nicer looking suspend and resume sequence.
> > > > 
> > > > v2: make a function so we can handle multiple drivers (Alan)
> > > > v3: use a list to track device requests (Rafael)
> > > > 
> > > > Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> > > 
> > > Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > 
> > > for all [1-3/3].
> > 
> > Any chance for an r-b on the PM one at least?  Then Daniel could
> > probably push this through drm-intel-next.
> 
> Done.

Thanks, I've merged the first two patches to drm-intel-next, the i915 one
still needs a bit of care imo.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
