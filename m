Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbaCMIkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 04:40:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54602 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaCMIkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 04:40:03 -0400
Date: Thu, 13 Mar 2014 09:40:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Chris Wilson <chris@chris-wilson.co.uk>, daniel.vetter@ffwll.ch,
        jani.nikula@linux.intel.com, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: WARN_ON() and X session lost from i915 on 3.14-rc6
Message-ID: <20140313084002.GB8902@amd.pavel.ucw.cz>
References: <20140312233039.GA5582@amd.pavel.ucw.cz>
 <20140312235209.GA4615@nuc-i3427.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140312235209.GA4615@nuc-i3427.alporthouse.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-03-12 23:52:09, Chris Wilson wrote:
> On Thu, Mar 13, 2014 at 12:30:39AM +0100, Pavel Machek wrote:
> > Hi!
> > 
> > This cost me two half-written mails...
> > 
> > So far it happened once, so it may be very infrequent; but I do not
> > think I seen similar failure from i915 before, so it may be an
> > regression. Well...
> 
> It's a userspace use-after-free bug. Please file a bug on
> bugs.freedesktop.org.

Could we get some better messages from the kernel? Userspace should
not be able to produce WARN_ON()s.

(This is debian 6.0.8; do you think it is worth reporting? I don't
think I should go to bugs.freedesktop.org...)

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
