Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934127Ab3DJL7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 07:59:09 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:44805 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab3DJL7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 07:59:07 -0400
Date: Wed, 10 Apr 2013 13:59:02 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>,
        Tomas Melin <tomas.melin@iki.fi>,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915: don't check inconsistent modeset state when
 force-restoring
Message-ID: <20130410115901.GA4502@netboy>
References: <20130409172820.GC27612@phenom.ffwll.local>
 <1365537090-11518-1-git-send-email-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365537090-11518-1-git-send-email-daniel.vetter@ffwll.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 09:51:30PM +0200, Daniel Vetter wrote:
> It will be only consistent once we've restored all the crtcs. Since a
> bunch of other callers also want to just restore a single crtc, add a
> boolean to disable checking only where it doesn't make sense.
> 
> Note that intel_modeset_setup_hw_state already has a call to
> intel_modeset_check_state at the end, so we don't reduce the amount of
> checking.
> 
> v2: Try harder not to create a big patch (Chris).

To what does tree does this patch apply?

Tried v3.8.6 and master d02a9a89.

Thanks,
Richard
