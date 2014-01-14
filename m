Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbaANOnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:43:45 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:49762 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751418AbaANOnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:43:42 -0500
Date: Tue, 14 Jan 2014 09:43:41 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Daniel Vetter <daniel@ffwll.ch>
cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Excessive WARN()s in Intel 915 driver
In-Reply-To: <20140114090519.GP4770@phenom.ffwll.local>
Message-ID: <Pine.LNX.4.44L0.1401140942520.1310-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014, Daniel Vetter wrote:

> On Mon, Jan 13, 2014 at 03:16:42PM -0500, Alan Stern wrote:
> > On Wed, 8 Jan 2014, Daniel Vetter wrote:
> > 
> > > On Wed, Jan 08, 2014 at 01:34:02PM -0500, Alan Stern wrote:
> > > > On Wed, 8 Jan 2014, Daniel Vetter wrote:
> > > > 
> > > > > On Wed, Jan 08, 2014 at 11:08:08AM -0500, Alan Stern wrote:
> > > > > > On Tue, 7 Jan 2014, Daniel Vetter wrote:
> > > > > > 
> > > > > > > I really want users to report these issues, and excessive WARNs seems
> > > > > > > to be the only way to get those reports. Please boot with
> > > > > > > drm.debug=0xe added to your kernel cmdline and reproduce this issues.
> > > > > > > Also, which precise kernel are you running? Testing latest -rc is
> > > > > > > always recommended, this state checker code is fairly new and gets
> > > > > > > constantly extended and bugs fixed ...
> > > > > > 
> > > > > > Here you go.  This is the dmesg output after booting with
> > > > > > drm.debug=0xe.  Pay no attention to the "AS" suffix in the version
> > > > > > string; this is pristine 3.13-rc7.
> > > > > 
> > > > > That's strange, I've thought we've fixed the last struggling mismatch in
> > > > > the lvds borber bits stuff. Can you please try latest drm-intel-nightly
> > > > > from
> > > > > 
> > > > > http://cgit.freedesktop.org/~danvet/drm-intel/
> > 
> > I posted the output from the default branch in that repository last
> > week:
> > 
> > 	http://marc.info/?l=linux-kernel&m=138922294308576&w=2
> 
> The default branch actually tends to be something stale, you need to
> explicitly check out drm-intel-nightly ...
> 
> > Have you had time to look at the results yet?
> 
> It's marked on my todo, but unfortunately haven't gotten around to write
> the patch yet (and analyze your log some more) ... I'll move it up the
> prio list a bit.

Don't bother.  I'll redo it using the drm-intel-nightly branch, but I 
won't have time for a few days.

Alan Stern

