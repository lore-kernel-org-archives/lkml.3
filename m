Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbaAHUTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:19:54 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:54929 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaAHUTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:19:52 -0500
Date: Wed, 8 Jan 2014 21:21:08 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Daniel Vetter <daniel@ffwll.ch>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Excessive WARN()s in Intel 915 driver
Message-ID: <20140108202108.GV4770@phenom.ffwll.local>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	Kernel development list <linux-kernel@vger.kernel.org>
References: <20140108161713.GT4770@phenom.ffwll.local>
 <Pine.LNX.4.44L0.1401081331140.1659-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1401081331140.1659-100000@iolanthe.rowland.org>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 01:34:02PM -0500, Alan Stern wrote:
> On Wed, 8 Jan 2014, Daniel Vetter wrote:
> 
> > On Wed, Jan 08, 2014 at 11:08:08AM -0500, Alan Stern wrote:
> > > On Tue, 7 Jan 2014, Daniel Vetter wrote:
> > > 
> > > > I really want users to report these issues, and excessive WARNs seems
> > > > to be the only way to get those reports. Please boot with
> > > > drm.debug=0xe added to your kernel cmdline and reproduce this issues.
> > > > Also, which precise kernel are you running? Testing latest -rc is
> > > > always recommended, this state checker code is fairly new and gets
> > > > constantly extended and bugs fixed ...
> > > 
> > > Here you go.  This is the dmesg output after booting with
> > > drm.debug=0xe.  Pay no attention to the "AS" suffix in the version
> > > string; this is pristine 3.13-rc7.
> > 
> > That's strange, I've thought we've fixed the last struggling mismatch in
> > the lvds borber bits stuff. Can you please try latest drm-intel-nightly
> > from
> > 
> > http://cgit.freedesktop.org/~danvet/drm-intel/
> 
> I prefer not to clone 1.7 GB of git data if at all possible.  Can you
> post (or send to me directly) a patch containing the differences with
> respect to 3.13-rc7?  It should end up being fairly small.

Shallow clones should reduce the data tremendously, see git help clone.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
