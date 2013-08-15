Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab3HOWcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 18:32:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41784 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab3HOWcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 18:32:32 -0400
Date: Thu, 15 Aug 2013 23:32:11 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Darren Etheridge <detheridge@ti.com>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] Several NXP TDA998x patches
Message-ID: <20130815223211.GG23006@n2100.arm.linux.org.uk>
References: <1376509413-1462-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376509413-1462-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 09:43:25PM +0200, Sebastian Hesselbarth wrote:
> This patch set picks up several patches sent during the past months
> related with NXP TDA998x HDMI transmitter driver. The patches have
> been tested on Marvell Dove (Armada DRM) on several HDMI and DVI modes
> with audio playing on S/PDIF.
> 
> I bumped all patches to v2, although only patches 2, 5, and 6 have
> changed. I also fixed a typo in commit line of patch 8. As Darren
> Etheridge already gave his Tested-by and tilcdc related patches have
> not changed, I added it to all patches for v2, too.
> 
> I have not added Russell King's Tested-by, as I hope he will have a
> close look at what I changed after his review comments.
> 
> Darren Etheridge (1):
>   drm/tilcdc fixup mode to workaround sync for tda998x
> 
> Russell King (5):
>   drm/i2c: tda998x: fix EDID reading on TDA19988 devices
>   drm/i2c: tda998x: ensure VIP output mux is properly set
>   drm/i2c: tda998x: fix npix/nline programming
>   drm/i2c: tda998x: prepare for video input configuration
>   drm/i2c: tda998x: add video and audio input configuration
> 
> Sebastian Hesselbarth (2):
>   drm/i2c: tda998x: fix sync generation and calculation
>   drm/i2c: tda998x: prepare for broken sync workaround
> 
>  drivers/gpu/drm/i2c/tda998x_drv.c     |  481 +++++++++++++++++++++++++++------
>  drivers/gpu/drm/tilcdc/tilcdc_crtc.c  |    7 +-
>  drivers/gpu/drm/tilcdc/tilcdc_slave.c |   27 +-
>  include/drm/i2c/tda998x.h             |   30 ++
>  4 files changed, 467 insertions(+), 78 deletions(-)
>  create mode 100644 include/drm/i2c/tda998x.h
> 
> ---
> Cc: David Airlie <airlied@linux.ie>
> Cc: Darren Etheridge <detheridge@ti.com>
> Cc: Rob Clark <robdclark@gmail.com>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-kernel@vger.kernel.org

Okay, I'm happy with this set.  Patches 1-7 can get a:

Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>

Thanks.
