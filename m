Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbaLHEIi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 23:08:38 -0500
Received: from imap.thunk.org ([74.207.234.97]:44575 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbaLHEIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 23:08:37 -0500
Date: Sun, 7 Dec 2014 23:08:29 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jani Nikula <jani.nikula@intel.com>
Subject: Re: WARNING:
 /usr/projects/linux/linux/drivers/gpu/drm/i915/intel_pm.c:6585
 intel_display_power_put+0x4b/0x116 [i915]()
Message-ID: <20141208040829.GA5142@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dave Airlie <airlied@gmail.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Jani Nikula <jani.nikula@intel.com>
References: <20140902040527.GA5508@thunk.org>
 <20141208003433.GA3353@thunk.org>
 <CAPM=9txGrrqYPg9EbpC+9OAB5VCt36vWFRMmoAOvJZV-RSQ2-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9txGrrqYPg9EbpC+9OAB5VCt36vWFRMmoAOvJZV-RSQ2-A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 12:32:01PM +1000, Dave Airlie wrote:
> 
> I suspect a lot of the problems are just that xfce isn't sufficiently handling
> randr events, and it is getting out of sync, it is like hotplug networking
> before NetworkManager etc.

Yes, I've seen this on XFCE 4.11 (in Ubuntu), although I haen't seen
it in XFCE 4.10 (in Debian).  In 4.11, when xfce gets out of sync,
xrandr --auto will allow me to enable the display, even when
xfce4-display-settings does not.

However, on my T540p with the monitors connected via the dock, which
is the problem I was describing here, xrandr --auto does *not* fix
things up.  So I think it's a different problem, since I can see this
problem even if I don't use xfce4-display-settings, and just use
xrandr directly.

						- Ted
