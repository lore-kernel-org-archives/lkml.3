Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab3J3Mn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 08:43:27 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:48803 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab3J3Mn0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 08:43:26 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1310301057350.26235@skynet.skynet.ie>
References: <alpine.DEB.2.00.1310301057350.26235@skynet.skynet.ie>
Date: Wed, 30 Oct 2013 08:43:25 -0400
Message-ID: <CADnq5_Nn-5zoK-cNN6h6NJ3iOoZE-gKirpGANdRqkZULgUb6hw@mail.gmail.com>
Subject: Re: [git pull] drm intel fixes
From: Alex Deucher <alexdeucher@gmail.com>
To: Dave Airlie <airlied@linux.ie>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 6:58 AM, Dave Airlie <airlied@linux.ie> wrote:
>
> Hi Linus,
>
> mainly Intel regression fixes and quirks, along with a simple one liner to
> fix rendernodes ioctl access (off by default, but testers want to test
> it).
>
> Dave.

Hi Dave,

I think you missed my fixes pull for radeon from last week:
http://lists.freedesktop.org/archives/dri-devel/2013-October/047873.html

Can we get that pulled in as well?

Alex

>
> The following changes since commit 7314e613d5ff9f0934f7a0f74ed7973b903315d1:
>
>   Fix a few incorrectly checked [io_]remap_pfn_range() calls (2013-10-29 10:21:34 -0700)
>
> are available in the git repository at:
>
>   git://people.freedesktop.org/~airlied/linux drm-fixes
>
> for you to fetch changes up to 3d3b78c06c827bfc072a11056d7eb70aeb90e449:
>
>   drm: allow DRM_IOCTL_VERSION on render-nodes (2013-10-30 14:41:56 +1000)
>
> ----------------------------------------------------------------
> Daniel Vetter (1):
>       drm/i915: Fix the PPT fdi lane bifurcate state handling on ivb
>
> Dave Airlie (1):
>       Merge tag 'drm-intel-fixes-2013-10-29' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes
>
> David Herrmann (1):
>       drm: allow DRM_IOCTL_VERSION on render-nodes
>
> Jani Nikula (1):
>       drm/i915/dp: workaround BIOS eDP bpp clamping issue
>
> Rob Pearce (1):
>       drm/i915: No LVDS hardware on Intel D410PT and D425KT
>
> Ville Syrjälä (2):
>       drm/i915: Add support for pipe_bpp readout
>       drm/i915: Add HSW CRT output readout support
>
>  drivers/gpu/drm/drm_drv.c            |   2 +-
>  drivers/gpu/drm/i915/intel_crt.c     |  30 ++++++--
>  drivers/gpu/drm/i915/intel_ddi.c     |  21 +++++-
>  drivers/gpu/drm/i915/intel_display.c | 131 ++++++++++++++++++++++-------------
>  drivers/gpu/drm/i915/intel_dp.c      |  20 ++++++
>  drivers/gpu/drm/i915/intel_drv.h     |   2 +
>  drivers/gpu/drm/i915/intel_lvds.c    |  16 +++++
>  7 files changed, 168 insertions(+), 54 deletions(-)
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
