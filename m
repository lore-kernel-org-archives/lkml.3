Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab3LCPSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:18:52 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:36387 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab3LCPSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:18:51 -0500
Date: Tue, 3 Dec 2013 16:19:35 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [i915] WARNING: [...] drivers/gpu/drm/i915/intel_display.c:9948
 intel_get_pipe_from_connector
Message-ID: <20131203151935.GD27344@phenom.ffwll.local>
Mail-Followup-To: Paul Bolle <pebolle@tiscali.nl>,
	Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
	David Airlie <airlied@linux.ie>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1385843936.10971.5.camel@x41.thuisdomein>
 <CAKMK7uHRW-1OiMY44s2G9dwbbQLMUxZ4fHf=Eaf9gJ_WASpvLQ@mail.gmail.com>
 <1385917025.7199.4.camel@x41.thuisdomein>
 <CAKMK7uE_L8cqyYk6mQ4paXeh2m7tmoMXRv_KxoAeBq9MEAnFqw@mail.gmail.com>
 <1385978027.2972.3.camel@x41.thuisdomein>
 <CAKMK7uE=Wr95XM85XVS1nT_8cV4e1Z_SubSVjQyP8BuLz-bTQg@mail.gmail.com>
 <1386007525.9830.4.camel@x41.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386007525.9830.4.camel@x41.thuisdomein>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 07:05:25PM +0100, Paul Bolle wrote:
> On Mon, 2013-12-02 at 15:23 +0100, Daniel Vetter wrote:
> > On Mon, Dec 2, 2013 at 10:53 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > > This generated quite a bit of debug messages so I only copied the
> > > WARNING and the drm (related) messages immediately preceding it. Please
> > > feel free to prod again if that's insufficient.
> > 
> > Yeah, the beginning of the drm message would are wanted since I need
> > to know what exactly your hardware claims to support ;-)
> > 
> > But the backtrace confirms my first hunch for now ... Just want to
> > confirm before sending out a patch with commit message.
> 
> It seems Ville's patch ( https://lkml.org/lkml/2013/12/2/77 ) does the
> trick. Do you still need the additional info?

I'd like to confirm the actual cause (I suspect that we switch
pipes&planes around) for why you see this but other machines don't show
this to augment the commit message. But I've merged the fix already.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
