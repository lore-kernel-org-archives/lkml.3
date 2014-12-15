Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750905AbaLON0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 08:26:11 -0500
Received: from imap.thunk.org ([74.207.234.97]:56556 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbaLON0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 08:26:08 -0500
Date: Mon, 15 Dec 2014 08:26:02 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Airlie <airlied@gmail.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jani Nikula <jani.nikula@intel.com>
Subject: Re: WARNING:
 /usr/projects/linux/linux/drivers/gpu/drm/i915/intel_pm.c:6585
 intel_display_power_put+0x4b/0x116 [i915]()
Message-ID: <20141215132602.GI17575@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dave Airlie <airlied@gmail.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Jani Nikula <jani.nikula@intel.com>
References: <20140902040527.GA5508@thunk.org>
 <20141208003433.GA3353@thunk.org>
 <CAPM=9txGrrqYPg9EbpC+9OAB5VCt36vWFRMmoAOvJZV-RSQ2-A@mail.gmail.com>
 <20141208040829.GA5142@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141208040829.GA5142@thunk.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This morning, I was docked and using a Dell 30" monitor.  I
reconfigured the X server to stop sending video to the external
monitor, suspended the laptop, and after it was suspended undocked it
and took it to work.  Then I docked it at work, where it was connected
to a powered off Dell 24" monitor.

Since this time there was a note:

[drm] GPU hangs can indicate a bug anywhere in the entire gfx stack, including userspace.
[drm] Please file a _new_ bug report on bugs.freedesktop.org against DRI -> DRM/Intel
[drm] drm/i915 developers can then reassign to the right component if it's not a kernel issue.
[drm] The gpu crash dump is required to analyze gpu hangs, so please always attach it.
[drm] GPU crash dump saved to /sys/class/drm/card0/error

I've filed:

	https://bugs.freedesktop.org/show_bug.cgi?id=87327

I do want to note that this is only one of many different symptoms and
failures that I am seeing.

Basically, after suspending and resuming, if I use an external
monitor, I have to be prepared to restart the X server --- and
sometimes the kernel will sponaneously reboot, sometimes when I do
something as simple as accidentally brushing against the power switch
on the Dell montor.   :-(   :-(   :-(

					- Ted
