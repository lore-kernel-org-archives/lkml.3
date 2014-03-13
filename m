Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaCMJF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:05:58 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:58375 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753192AbaCMJFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:05:55 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Thu, 13 Mar 2014 09:05:49 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: daniel.vetter@ffwll.ch, jani.nikula@linux.intel.com,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: WARN_ON() and X session lost from i915 on 3.14-rc6
Message-ID: <20140313090549.GA8998@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Pavel Machek <pavel@ucw.cz>, daniel.vetter@ffwll.ch,
	jani.nikula@linux.intel.com, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	kernel list <linux-kernel@vger.kernel.org>
References: <20140312233039.GA5582@amd.pavel.ucw.cz>
 <20140312235209.GA4615@nuc-i3427.alporthouse.com>
 <20140313084002.GB8902@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140313084002.GB8902@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 09:40:02AM +0100, Pavel Machek wrote:
> On Wed 2014-03-12 23:52:09, Chris Wilson wrote:
> > On Thu, Mar 13, 2014 at 12:30:39AM +0100, Pavel Machek wrote:
> > > Hi!
> > > 
> > > This cost me two half-written mails...
> > > 
> > > So far it happened once, so it may be very infrequent; but I do not
> > > think I seen similar failure from i915 before, so it may be an
> > > regression. Well...
> > 
> > It's a userspace use-after-free bug. Please file a bug on
> > bugs.freedesktop.org.
> 
> Could we get some better messages from the kernel? Userspace should
> not be able to produce WARN_ON()s.

Indeed, we have already pruned those errors and WARNs, in favour of a
real error code, precisely because they are user triggerable.
 
> (This is debian 6.0.8; do you think it is worth reporting? I don't
> think I should go to bugs.freedesktop.org...)

I guess your userspace is roughly xf86-video-intel-2.17 and friends.
Quite a few changes since then, but I've forgotten if this bug was ever
addressed explicitly. Most likely it has been...
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
