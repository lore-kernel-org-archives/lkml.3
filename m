Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab3FMRck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 13:32:40 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:60608 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab3FMRcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 13:32:39 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: Re: [PATCH] MAINTAINERS: Add Samsung pinctrl entries
Date: Thu, 13 Jun 2013 19:32:36 +0200
Message-ID: <1552010.DOo3aEBKyJ@flatron>
User-Agent: KMail/4.10.4 (Linux/3.9.5-gentoo; KDE/4.10.4; x86_64; ; )
In-Reply-To: <CAD=FV=Un+Ti8atZLUbK+5w=dB7vX7HoxVacEGkjvCboVo4mNpA@mail.gmail.com>
References: <1371143144-31764-1-git-send-email-dianders@chromium.org> <9948950.GZ51yJYkxQ@flatron> <CAD=FV=Un+Ti8atZLUbK+5w=dB7vX7HoxVacEGkjvCboVo4mNpA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 of June 2013 10:25:02 Doug Anderson wrote:
> Tomasz,
> 
> On Thu, Jun 13, 2013 at 10:13 AM, Tomasz Figa <tomasz.figa@gmail.com> 
wrote:
> > On Thursday 13 of June 2013 10:05:44 Doug Anderson wrote:
> >> It's convenient if get_maintainer suggests sending samsung/exynos
> >> pinctrl changes to linux-samsung-soc and to Kukjin.  Add an entry for
> >> that.
> > 
> > Well, if we are already at it, we could list the actual maintainers of
> > the driver.
> > 
> > The original maintainer was Thomas Abraham <thomas.abraham@linaro.org>
> > (added to CC) and after joining to development of this driver last
> > year I have become a de facto maintainer as well, so...
> > 
> >> Signed-off-by: Doug Anderson <dianders@chromium.org>
> >> ---
> >> 
> >>  MAINTAINERS | 10 ++++++++++
> >>  1 file changed, 10 insertions(+)
> >> 
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> index 8d97b3e..d026e38 100644
> >> --- a/MAINTAINERS
> >> +++ b/MAINTAINERS
> >> @@ -6284,6 +6284,16 @@ L:     linux-arm-kernel@lists.infradead.org
> >> (moderated for non-subscribers) S:    Maintained
> >> 
> >>  F:   drivers/pinctrl/pinctrl-at91.c
> >> 
> >> +PIN CONTROLLER - SAMSUNG
> >> +M:   Linus Walleij <linus.walleij@linaro.org>
> >> +M:   Kukjin Kim <kgene.kim@samsung.com>
> > 
> > So actually this would be:
> > M:      Thomas Abraham <thomas.abraham@linaro.org>
> > M:      Tomasz Figa <t.figa@samsung.com>
> > 
> > Thomas, do you agree on this?
> 
> Ah.  Wasn't sure where the official maintainership should lie.  ;)  If
> Thomas is happy with this then I'll spin and re-send.  Shall I remove
> Kukjin and Linus, then?  It's convenient to have Linus on the list
> since he tends to be the one applying the patches...

>From my understanding how it works, there is no need to list Linus in 
particular drivers, because he's already listed as a maintainer of the 
whole pinctrl subsystem and get-maintainer accounts for this.

Similarly for Kukjin, he's listed as the main Samsung maintainer already, 
but AFAIK in this case the script can't infer this based on directory 
structure. Let's see how it's done for other Samsung drivers:

DRM DRIVERS FOR EXYNOS
M:      Inki Dae <inki.dae@samsung.com>
M:      Joonyoung Shim <jy0922.shim@samsung.com>
M:      Seung-Woo Kim <sw0312.kim@samsung.com>
M:      Kyungmin Park <kyungmin.park@samsung.com>
L:      dri-devel@lists.freedesktop.org
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/daeinki/drm-
exynos.git
S:      Supported
F:      drivers/gpu/drm/exynos
F:      include/drm/exynos*
F:      include/uapi/drm/exynos*

EXYNOS DP DRIVER
M:      Jingoo Han <jg1.han@samsung.com>
L:      linux-fbdev@vger.kernel.org
S:      Maintained
F:      drivers/video/exynos/exynos_dp*
F:      include/video/exynos_dp*

EXYNOS MIPI DISPLAY DRIVERS
M:      Inki Dae <inki.dae@samsung.com>
M:      Donghwa Lee <dh09.lee@samsung.com>
M:      Kyungmin Park <kyungmin.park@samsung.com>
L:      linux-fbdev@vger.kernel.org
S:      Maintained
F:      drivers/video/exynos/exynos_mipi*
F:      include/video/exynos_mipi*

ARM/SAMSUNG S5P SERIES 2D GRAPHICS ACCELERATION (G2D) SUPPORT
M:      Kyungmin Park <kyungmin.park@samsung.com>
M:      Kamil Debski <k.debski@samsung.com>
L:      linux-arm-kernel@lists.infradead.org
L:      linux-media@vger.kernel.org
S:      Maintained
F:      drivers/media/platform/s5p-g2d/

and so on.

So I think, based on this precedent, we can do the same for pinctrl. Let's 
wait to see Thomas' view on this.

Best regards,
Tomasz

