Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab3GYRB5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:01:57 -0400
Received: from s16502780.onlinehome-server.info ([87.106.93.118]:58826 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755552Ab3GYRBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:01:52 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Thu, 25 Jul 2013 18:01:44 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        linux-next <linux-next@vger.kernel.org>
Subject: Re: [Intel-gfx] linux-next: Tree for Jul 25 [ call-trace: drm |
 drm-intel related? ]
Message-ID: <20130725170144.GE6493@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Sedat Dilek <sedat.dilek@gmail.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	DRI <dri-devel@lists.freedesktop.org>,
	linux-next <linux-next@vger.kernel.org>
References: <CA+icZUXhW_yAie25DPVXzhi2_pYQTjJpDqa7EzRfvtQ0gFYYHQ@mail.gmail.com>
 <20130725133651.GI5939@phenom.ffwll.local>
 <CA+icZUWxvBR6NX8JnqM1+4yVNfQ8ew5_7UCQ6yVpz8B4UibW7A@mail.gmail.com>
 <20130725142705.GM5939@phenom.ffwll.local>
 <CA+icZUU3+egkAVtSVEiOaqWK+7EFi572jGv2jUt=QDuGjbfZOw@mail.gmail.com>
 <CAKMK7uG-KCF5oU2XJ5UWPJn=V3i0jBLs5a=gU9UPuJxY0v=bNw@mail.gmail.com>
 <CA+icZUV-UM_9OSfGfYyb0-qZrFSuqeX-7BiPQ0NbyF7bADW-qA@mail.gmail.com>
 <CA+icZUWJDp6XQZs8hojVJOVyjC8NeV7QoQeFopNoUgwCaYHnSQ@mail.gmail.com>
 <20130725163150.GD6493@cantiga.alporthouse.com>
 <CA+icZUWmpZK0jO_G1ec446WftzXDvSdnHLcQrkmBSHA7fSAqcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUWmpZK0jO_G1ec446WftzXDvSdnHLcQrkmBSHA7fSAqcw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 78.156.73.22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 06:35:10PM +0200, Sedat Dilek wrote:
> On Thu, Jul 25, 2013 at 6:31 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > On Thu, Jul 25, 2013 at 06:11:18PM +0200, Sedat Dilek wrote:
> >> Might be OT, but I cannot use my X graphics stack containing
> >> libdrm-2.4.46, mesa-9.1.5 and intel-ddx 2.21.12-git (tried also
> >> v2.21.11).
> >> Switching back to the one from Ubuntu/precise lets my X start.
> >>
> >>
> >> [    40.379] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
> >> [    40.379] (II) AIGLX: enabled GLX_INTEL_swap_event
> >> [    40.380] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control
> >> [    40.380] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
> >> [    40.380] (II) AIGLX: Loaded and initialized i965
> >> [    40.380] (II) GLX: Initialized DRI2 GL provider for screen 0
> >> [    40.380]
> >> Fatal server error:
> >> [    40.380] failed to create screen resources
> >> [    40.380]
> >> Please consult the The X.Org Foundation support
> >>          at http://wiki.x.org
> >>  for help.
> >> [    40.380] Please also check the log file at "/var/log/Xorg.0.log"
> >> for additional information.
> >> [    40.380]
> >> [    40.380] (II) AIGLX: Suspending AIGLX clients for VT switch
> >> [    40.396]  ddxSigGiveUp: Closing log
> >> [    40.398] Server terminated with error (1). Closing log file.
> >
> > Please attach the full Xorg.0.log so that I can make a few guesses.
> 
> Linux-kernel: This happens with drm-intel-nightly pulled into next-20130725.

Basically boils down to either an object allocation failure or mmaping
failure. I think dmesg with drm.debug=7 is the next step.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
