Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaAMUQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:16:46 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:34928 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751068AbaAMUQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:16:43 -0500
Date: Mon, 13 Jan 2014 15:16:42 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Daniel Vetter <daniel@ffwll.ch>
cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Excessive WARN()s in Intel 915 driver
In-Reply-To: <20140108202108.GV4770@phenom.ffwll.local>
Message-ID: <Pine.LNX.4.44L0.1401131512380.2032-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jan 2014, Daniel Vetter wrote:

> On Wed, Jan 08, 2014 at 01:34:02PM -0500, Alan Stern wrote:
> > On Wed, 8 Jan 2014, Daniel Vetter wrote:
> > 
> > > On Wed, Jan 08, 2014 at 11:08:08AM -0500, Alan Stern wrote:
> > > > On Tue, 7 Jan 2014, Daniel Vetter wrote:
> > > > 
> > > > > I really want users to report these issues, and excessive WARNs seems
> > > > > to be the only way to get those reports. Please boot with
> > > > > drm.debug=0xe added to your kernel cmdline and reproduce this issues.
> > > > > Also, which precise kernel are you running? Testing latest -rc is
> > > > > always recommended, this state checker code is fairly new and gets
> > > > > constantly extended and bugs fixed ...
> > > > 
> > > > Here you go.  This is the dmesg output after booting with
> > > > drm.debug=0xe.  Pay no attention to the "AS" suffix in the version
> > > > string; this is pristine 3.13-rc7.
> > > 
> > > That's strange, I've thought we've fixed the last struggling mismatch in
> > > the lvds borber bits stuff. Can you please try latest drm-intel-nightly
> > > from
> > > 
> > > http://cgit.freedesktop.org/~danvet/drm-intel/

I posted the output from the default branch in that repository last
week:

	http://marc.info/?l=linux-kernel&m=138922294308576&w=2

Have you had time to look at the results yet?

Alan Stern

