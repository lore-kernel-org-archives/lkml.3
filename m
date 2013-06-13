Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448Ab3FMWW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:22:57 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:57447 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757899Ab3FMWWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:22:55 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-15-51ba463d3611
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Doug Anderson'" <dianders@chromium.org>
Cc: "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Mauro Carvalho Chehab'" <mchehab@redhat.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Cesar Eduardo Barros'" <cesarb@cesarb.net>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Hans Verkuil'" <hans.verkuil@cisco.com>,
        linux-kernel@vger.kernel.org,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>
References: <1371143144-31764-1-git-send-email-dianders@chromium.org>
 <9948950.GZ51yJYkxQ@flatron>
 <CAD=FV=Un+Ti8atZLUbK+5w=dB7vX7HoxVacEGkjvCboVo4mNpA@mail.gmail.com>
 <1552010.DOo3aEBKyJ@flatron>
In-reply-to: <1552010.DOo3aEBKyJ@flatron>
Subject: RE: [PATCH] MAINTAINERS: Add Samsung pinctrl entries
Date: Fri, 14 Jun 2013 07:22:53 +0900
Message-id: <15cf01ce6884$8c073f20$a415bd60$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5oXAH9O9ozD5i7QPKWiB7L/f0SbAAJ2/Eg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t8zfV1bt12BBgd+aFvMWb+GzWLWtSCL
	OedbWCzOLjvIZrHk5y4miyl/ljNZXN41h81ixvl9TBZ7jh5mtzh1/TObxda9V9ktjs1Ywmix
	atcfRgdej8YbN9g8jtyewewxu+Eii8eU3xtZPbasvMnksXPWXXaPO9f2sHmcmPGbxePKiSZW
	j/f7rrJ5fN4kF8AdxWWTkpqTWZZapG+XwJXx6fA35oIrChVNdyYyNzAukuxi5OSQEDCRuHl3
	KxOELSZx4d56ti5GLg4hgWWMEs93zmWDKep+84kJIjGdUaLpQQ8LhPOXUeL7xFmsIFVsAhoS
	h98/Y+9i5OAQEQiR6G9WBqlhFnjDLHGjZTPU2FOMEp3TzoPt4xTQlPiz5RcTSIOwgK3E271+
	IGEWAVWJ76uOsoDYvEDhz+3tjBC2oMSPyffA4swCWhLrdx5ngrDlJTavecsMMkZCQF3i0V9d
	kLCIgJHExKt/2SBKRCT2vXjHCHKChMAJDonOy5vZIHYJSHybfIgFoldWYtMBZoiHJSUOrrjB
	MoFRYhaSzbOQbJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAhJGr07GG8f
	sD7EmAy0fiKzlGhyPjDp5JXEGxqbGVmYmpgaG5lbmpEmrCTOq9ZiHSgkkJ5YkpqdmlqQWhRf
	VJqTWnyIkYmDU6qB8Sar2w+f9j8n2L+/DKu5vjHbn8s/7TLjteYXqWqLjgvPN7GV2jz9nL3w
	01dnV+ZxFMnck902IbSL45xLw9ZHPgu36PXqiLc8OH/VfaHgvYhJz/gnr29VuzzH8tYcHvaf
	Pu2H/q9muf3/mMqXLyoLaxZ8kw3cc8x1jrZ3NGPWAS3xSwcZb8tPs1BiKc5INNRiLipOBAAq
	9Cx1MAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFKsWRmVeSWpSXmKPExsVy+t9jQV1bt12BBr1PVC3mrF/DZjHrWpDF
	nPMtLBZnlx1ks1jycxeTxZQ/y5ksLu+aw2Yx4/w+Jos9Rw+zW5y6/pnNYuveq+wWx2YsYbRY
	tesPowOvR+ONG2weR27PYPaY3XCRxWPK742sHltW3mTy2DnrLrvHnWt72DxOzPjN4nHlRBOr
	x/t9V9k8Pm+SC+COamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVV
	cvEJ0HXLzAF6QUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8enwN+aC
	KwoVTXcmMjcwLpLsYuTkkBAwkeh+84kJwhaTuHBvPVsXIxeHkMB0RommBz0sEM5fRonvE2ex
	glSxCWhIHH7/jL2LkYNDRCBEor9ZGaSGWeANs8SNls1Q3acYJTqnnQcbyymgKfFnyy8mkAZh
	AVuJt3v9QMIsAqoS31cdZQGxeYHCn9vbGSFsQYkfk++BxZkFtCTW7zzOBGHLS2xe85YZZIyE
	gLrEo7+6IGERASOJiVf/skGUiEjse/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5K
	zzXSK07MLS7NS9dLzs/dxAhOSc+kdzCuarA4xCjAwajEw5twYWegEGtiWXFl7iFGCQ5mJRHe
	8L9AId6UxMqq1KL8+KLSnNTiQ4zJQI9OZJYSTc4Hpsu8knhDYxMzI0sjMwsjE3Nz0oSVxHkP
	tloHCgmkJ5akZqemFqQWwWxh4uCUamC0E/zcMLeX888eI5NH9+a3PvrkKMCy13X5ip/ilnuX
	ZvTa7+fZUPJFmOftJP2J817HvzkUeVjfaZvCJoUpHWyHBPp2Gs5OESp1MGLd8bj0z/RVLw+Z
	Xl8SlzIh3nvBYo0NIgzJB9d5e+/88c321lmWzUqrSu81ij+OMVMqvBa7Iralxoz3TGaAEktx
	RqKhFnNRcSIAGFkF+Y0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Figa wrote:
> 
> On Thursday 13 of June 2013 10:25:02 Doug Anderson wrote:
> > Tomasz,
> >
> > On Thu, Jun 13, 2013 at 10:13 AM, Tomasz Figa <tomasz.figa@gmail.com>
> wrote:
> > > On Thursday 13 of June 2013 10:05:44 Doug Anderson wrote:
> > >> It's convenient if get_maintainer suggests sending samsung/exynos
> > >> pinctrl changes to linux-samsung-soc and to Kukjin.  Add an entry for
> > >> that.
> > >
> > > Well, if we are already at it, we could list the actual maintainers of
> > > the driver.
> > >
> > > The original maintainer was Thomas Abraham <thomas.abraham@linaro.org>
> > > (added to CC) and after joining to development of this driver last
> > > year I have become a de facto maintainer as well, so...
> > >
> > >> Signed-off-by: Doug Anderson <dianders@chromium.org>
> > >> ---
> > >>
> > >>  MAINTAINERS | 10 ++++++++++
> > >>  1 file changed, 10 insertions(+)
> > >>
> > >> diff --git a/MAINTAINERS b/MAINTAINERS
> > >> index 8d97b3e..d026e38 100644
> > >> --- a/MAINTAINERS
> > >> +++ b/MAINTAINERS
> > >> @@ -6284,6 +6284,16 @@ L:     linux-arm-kernel@lists.infradead.org
> > >> (moderated for non-subscribers) S:    Maintained
> > >>
> > >>  F:   drivers/pinctrl/pinctrl-at91.c
> > >>
> > >> +PIN CONTROLLER - SAMSUNG
> > >> +M:   Linus Walleij <linus.walleij@linaro.org>
> > >> +M:   Kukjin Kim <kgene.kim@samsung.com>
> > >
> > > So actually this would be:
> > > M:      Thomas Abraham <thomas.abraham@linaro.org>
> > > M:      Tomasz Figa <t.figa@samsung.com>
> > >
> > > Thomas, do you agree on this?
> >
> > Ah.  Wasn't sure where the official maintainership should lie.  ;)  If
> > Thomas is happy with this then I'll spin and re-send.  Shall I remove
> > Kukjin and Linus, then?  It's convenient to have Linus on the list
> > since he tends to be the one applying the patches...
> 
> From my understanding how it works, there is no need to list Linus in
> particular drivers, because he's already listed as a maintainer of the
> whole pinctrl subsystem and get-maintainer accounts for this.
> 
> Similarly for Kukjin, he's listed as the main Samsung maintainer already,

If so, the directory like pinctrl should be added under Samsung ARM
Architectures like spi and sound for Samsung stuff...

> but AFAIK in this case the script can't infer this based on directory
> structure. Let's see how it's done for other Samsung drivers:
> 
Well, I don't think so, because pinctrl has the close relationship with
exynos arch part and it's little bit different with following. Just in my
understanding.

> DRM DRIVERS FOR EXYNOS
> M:      Inki Dae <inki.dae@samsung.com>
> M:      Joonyoung Shim <jy0922.shim@samsung.com>
> M:      Seung-Woo Kim <sw0312.kim@samsung.com>
> M:      Kyungmin Park <kyungmin.park@samsung.com>
> L:      dri-devel@lists.freedesktop.org
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/daeinki/drm-
> exynos.git
> S:      Supported
> F:      drivers/gpu/drm/exynos
> F:      include/drm/exynos*
> F:      include/uapi/drm/exynos*
> 
> EXYNOS DP DRIVER
> M:      Jingoo Han <jg1.han@samsung.com>
> L:      linux-fbdev@vger.kernel.org
> S:      Maintained
> F:      drivers/video/exynos/exynos_dp*
> F:      include/video/exynos_dp*
> 
> EXYNOS MIPI DISPLAY DRIVERS
> M:      Inki Dae <inki.dae@samsung.com>
> M:      Donghwa Lee <dh09.lee@samsung.com>
> M:      Kyungmin Park <kyungmin.park@samsung.com>
> L:      linux-fbdev@vger.kernel.org
> S:      Maintained
> F:      drivers/video/exynos/exynos_mipi*
> F:      include/video/exynos_mipi*
> 
> ARM/SAMSUNG S5P SERIES 2D GRAPHICS ACCELERATION (G2D) SUPPORT
> M:      Kyungmin Park <kyungmin.park@samsung.com>
> M:      Kamil Debski <k.debski@samsung.com>
> L:      linux-arm-kernel@lists.infradead.org
> L:      linux-media@vger.kernel.org
> S:      Maintained
> F:      drivers/media/platform/s5p-g2d/
> 
And I'm asking above all guys _really_ do review and maintaining the file or
directories? I don't think so.

> and so on.
> 
> So I think, based on this precedent, we can do the same for pinctrl. Let's
> wait to see Thomas' view on this.
> 

