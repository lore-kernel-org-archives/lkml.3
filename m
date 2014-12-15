Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaLOHbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 02:31:24 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:50738 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaLOHbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 02:31:22 -0500
Date: Mon, 15 Dec 2014 08:31:56 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Emmanuel Benisty <benisty.e@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [Regression] 83f45fc turns machine's screen off
Message-ID: <20141215073156.GK27182@phenom.ffwll.local>
Mail-Followup-To: Emmanuel Benisty <benisty.e@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Dave Airlie <airlied@linux.ie>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	dri-devel <dri-devel@lists.freedesktop.org>
References: <CA+i8gKK0sj55s-Gk8Y36KM4yBFLvLotffbSodjH5Gsd_yxd5Sg@mail.gmail.com>
 <CAKMK7uGa_dHnie8EACcX0mQvc-uGpsgQHjWGN_obxPa3O6SJbw@mail.gmail.com>
 <CA+i8gKKGBviLBaS8b=swqv2OWgh2Uc+m-TT8LVYcPehcYd903A@mail.gmail.com>
 <CA+i8gKJPPPUXrxY5q+81xZG91azygoUb27R_Wid3GTpb3-1-rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+i8gKJPPPUXrxY5q+81xZG91azygoUb27R_Wid3GTpb3-1-rw@mail.gmail.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 02:07:19AM +0100, Emmanuel Benisty wrote:
> Hi Daniel,
> 
> > On Mon, Nov 10, 2014 at 10:19 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> >> Adding relevant mailing lists.
> >>
> >>
> >> On Sat, Nov 8, 2014 at 7:34 PM, Emmanuel Benisty <benisty.e@gmail.com> wrote:
> >>> Hi,
> >>>
> >>> The following commit permanently turns my screen off when x server is
> >>> started (i3 330M Ironlake):
> >>>
> >>>     [83f45fc360c8e16a330474860ebda872d1384c8c] drm: Don't grab an fb
> >>> reference for the idr
> >>>
> >>> Reverting this commit fixed the issue.
> >>
> >> This is definitely unexpected. I think we need a bit more data to
> >> figure out what's going on here:
> >> - Please boot with drm.debug=0xe added to your kernel cmdline and grab
> >> the dmesg right after boot-up for both a working or broken kernel.
> >
> > Please see attached files.
> >
> >> - Are you using any special i915 cmdline options?
> >
> > Nope.
> 
> Is there anything else I could provide to help fixing this issue? It's
> still in Linus' tree.

Sorry for the delay. Absolutely no difference in the relevant parts of the
log. There could be the chance that something is hidden somewhere, so can
please grab a new set of logs but this time with drm.debug=0xe?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
