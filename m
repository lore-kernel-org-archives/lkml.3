Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965234Ab3DJR1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:27:31 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:57666 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965215Ab3DJR13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:27:29 -0400
Date: Wed, 10 Apr 2013 19:27:18 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>,
        Tomas Melin <tomas.melin@iki.fi>,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915: don't check inconsistent modeset state when
 force-restoring
Message-ID: <20130410172717.GA2480@netboy>
References: <20130409172820.GC27612@phenom.ffwll.local>
 <1365537090-11518-1-git-send-email-daniel.vetter@ffwll.ch>
 <20130410115901.GA4502@netboy>
 <20130410120724.GJ27612@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410120724.GJ27612@phenom.ffwll.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 02:07:24PM +0200, Daniel Vetter wrote:
> 
> It's written against drm-intel-next-queued at
> 
> http://cgit.freedesktop.org/~danvet/drm-intel
> 
> I've thought that it should apply pretty cleanly against older kernels,
> too. Apparently it conflicts a bit in intel_modeset_setup_hw_state, you
> can just do the s/intel_crtc_restore_mode/__intel_set_mode/ change
> manually.

I couldn't see right away how to fix it up, so I just compiled your
drm-intel-next-queued plus this patch. If I close the netbook's lid
and open it again, the screen is blank, no backlight, and the machine
seems to be frozen.

I think I can live with the warning.

Thanks anyhow,
Richard
