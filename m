Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab3IYIRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 04:17:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab3IYIRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 04:17:02 -0400
Date: Wed, 25 Sep 2013 11:19:13 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Dave Airlie <airlied@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: Fwd: linux-next: Tree for Jul 1 [ drm-intel-next: Several
 call-traces ]
Message-ID: <20130925081913.GB5818@redhat.com>
References: <CA+icZUXyizuCR3YDfFXD5hCkgycFYGzMHaJxg=m9UackT7uzGQ@mail.gmail.com>
 <CAKMK7uFzwiztE8H1rvSDWQmw08JGoKdnTs5BYqxdrHwb=pK50A@mail.gmail.com>
 <CA+icZUXnHaT75NhhSx+AhcMEKybHugH9+hV_mS5h5-cimFdz6A@mail.gmail.com>
 <CA+icZUVQ_UO_VnN9+Q7B3hhuFmw4XPEw19rhO+T4jU5hLGWaTQ@mail.gmail.com>
 <CA+icZUW3K7RyUcfdos7aOkrEOd3To0kSns+G3GSfkPqqwo7z=w@mail.gmail.com>
 <20130826130511.GA21082@redhat.com>
 <20130922141410.GA1974@redhat.com>
 <CAPM=9ty_o7VZx+sfDRSwh7U9BC+gOLd7P-cc856+PDBXR-UMEA@mail.gmail.com>
 <20130925075652.GG12663@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925075652.GG12663@phenom.ffwll.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 09:56:52AM +0200, Daniel Vetter wrote:
> On Wed, Sep 25, 2013 at 01:17:52PM +1000, Dave Airlie wrote:
> > On Mon, Sep 23, 2013 at 12:14 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> > > On Mon, Aug 26, 2013 at 04:05:11PM +0300, Michael S. Tsirkin wrote:
> > >> On Wed, Aug 21, 2013 at 11:22:58AM +0200, Sedat Dilek wrote:
> > >> > [ Re: [Intel-gfx] i915 producing warnings with kernel 3.11-rc5 ]
> > >> >
> > >> > Hi,
> > >> >
> > >> > saw your posting in [1]... can you try the patches below?
> > >> > Not sure if they apply.
> > >> > Did you try v3.11-rc6(+)... or drm-intel-nightly?
> > >> >
> > >> > Regards,
> > >> > - Sedat -
> > >> >
> > >> > [1] http://lists.freedesktop.org/archives/intel-gfx/2013-August/032154.html
> > >>
> > >> Same thing observed with v3.11-rc7.
> > >
> > > I still see this with 3.11.
> > > Following this message, my VGA monitor goes blank and
> > > shows an error suggesting a wrong resolution or frequency are set.
> > > Anyone?
> > 
> > Daniel, Jesse?
> > 
> > still ongoing I think.
> 
> Yeah, I've dismissed it since the original issue in this thread is
> resolved. But it's something else.
> 
> Note to bug reporters: Please don't me-too, but start a new thread/report
> - almost every gfx bug is different, even if it superficially looks the
> same.
> 
> Michael, can you please boot with drm.debug=0xe, reproduce the problem and
> then attach the complete dmesg? Please make sure dmesg contains everything
> since boot-up, if not please increase the dmesg buffer size with
> log_buf_len=4M.
> 
> Also please test the latest drm-intel-fixes release to check that we
> haven't just forgotten to send the patch to stable (there's at least one
> flags mismatch fix already in-flight to 3.11 stable kernels).
> 
> Thanks, Daniel
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch


Will do. Holidays starting now so expect some reports
next week.
