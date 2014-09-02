Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaIBBXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 21:23:16 -0400
Received: from netrider.rowland.org ([192.131.102.5]:41940 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751802AbaIBBXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 21:23:15 -0400
Date: Mon, 1 Sep 2014 21:23:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Damien Lespiau <damien.lespiau@intel.com>
cc: Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] Regression in drm-intel caused by d91a2cb8e510
In-Reply-To: <20140901221344.GA22902@strange.ger.corp.intel.com>
Message-ID: <Pine.LNX.4.44L0.1409012122220.18553-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2014, Damien Lespiau wrote:

> On Mon, Sep 01, 2014 at 04:19:23PM -0400, Alan Stern wrote:
> > Daniel:
> > 
> > I'm encountering a problem with the drm-intel-nightly branch in your
> > drm-intel repository.  The symptom is that when I boot my laptop, at
> > some point during the start-up procedure the screen goes totally blank,
> > as though the backlight were turned off, and it remains that way.  I
> > can't tell if the backlight really is off -- it may be that there's
> > just nothing being displayed -- and playing with the screen-brightness
> > function keys doesn't help.
> > 
> > Git bisect located the source of the problem as commit d91a2cb8e510
> > (drm/i915: Add 180 degree primary plane rotation support).  The problem
> > occurs when I boot a kernel built from that commit, and it doesn't
> > occur when I boot a kernel built from the preceding commit
> > (19ac737dc3c3).
> > 
> > If necessary, I can get debugging info by logging in over a network 
> > connection.  Tell me what you need.
> 
> It seems like Ville and Mika already caught a similar bug today, could
> you give Ville's patch a go (available on the intel-gfx):
> 
>   drm/i915: Don't call intel_plane_restore() when the prop value didn't change

Yes, that patch fixed the problem.  Thank you.

Tested-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

