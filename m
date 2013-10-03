Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab3JCUmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:42:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47977 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab3JCUmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:42:08 -0400
Date: Thu, 3 Oct 2013 22:42:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Chris Wilson <chris@chris-wilson.co.uk>, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.11-rc7: i915: stuck on render ring
Message-ID: <20131003204205.GA18554@amd.pavel.ucw.cz>
References: <20130903190646.GA9616@amd.pavel.ucw.cz>
 <20130904100814.GH24319@nuc-i3427.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130904100814.GH24319@nuc-i3427.alporthouse.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2013-09-04 11:08:14, Chris Wilson wrote:
> On Tue, Sep 03, 2013 at 09:06:47PM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > I was happily using X... and then screen froze. Mouse still
> > moves. Switching to text console still worked, good. It is first time
> > in a while, normally this machine works well.
> > 
> > i915_error_state is attached.
> > 
> > Any ideas?
> 
> It's a bug in the ddx, that was fixed in 2.14.902 (2011-03-29).

Aha, so I need to update X.... or rather debian should update the X
server. Thanks for the info.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
