Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab3JGVDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 17:03:47 -0400
Received: from coloquinte.cristau.org ([91.121.16.100]:53501 "EHLO
	coloquinte.cristau.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab3JGVDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 17:03:45 -0400
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Oct 2013 17:03:45 EDT
Date: Mon, 7 Oct 2013 22:57:04 +0200
From: Julien Cristau <jcristau@debian.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.11-rc7: i915: stuck on render ring
Message-ID: <20131007205704.GC4002@betterave.cristau.org>
References: <20130903190646.GA9616@amd.pavel.ucw.cz>
 <20130904100814.GH24319@nuc-i3427.alporthouse.com>
 <20131003204205.GA18554@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003204205.GA18554@amd.pavel.ucw.cz>
X-Operating-System: Linux 3.10-3-amd64 x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct  3, 2013 at 22:42:06 +0200, Pavel Machek wrote:

> On Wed 2013-09-04 11:08:14, Chris Wilson wrote:
> > On Tue, Sep 03, 2013 at 09:06:47PM +0200, Pavel Machek wrote:
> > > Hi!
> > > 
> > > I was happily using X... and then screen froze. Mouse still
> > > moves. Switching to text console still worked, good. It is first time
> > > in a while, normally this machine works well.
> > > 
> > > i915_error_state is attached.
> > > 
> > > Any ideas?
> > 
> > It's a bug in the ddx, that was fixed in 2.14.902 (2011-03-29).
> 
> Aha, so I need to update X.... or rather debian should update the X
> server. Thanks for the info.
> 									Pavel
I don't know what version you're running, but stable has 2.19, and
unstable has 2.21.15.  Both are > 2.14.902.

Cheers,
Julien
