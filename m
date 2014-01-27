Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbaA0Qgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 11:36:49 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:49708 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbaA0Qgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 11:36:48 -0500
Date: Mon, 27 Jan 2014 17:36:43 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Excessive WARN()s in Intel 915 driver
Message-ID: <20140127163643.GF9772@phenom.ffwll.local>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	Kernel development list <linux-kernel@vger.kernel.org>
References: <20140127155640.GA9772@phenom.ffwll.local>
 <Pine.LNX.4.44L0.1401271105150.1207-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1401271105150.1207-100000@iolanthe.rowland.org>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 11:05:47AM -0500, Alan Stern wrote:
> On Mon, 27 Jan 2014, Daniel Vetter wrote:
> 
> > > By the way, I tried getting an up-to-date version of your 
> > > drm-intel-nightly branch, and ended up with the following:
> > > 
> > > $ git clone --depth 1 -b drm-intel-nightly http://cgit.freedesktop.org/~danvet/drm-intel/
> > > Cloning into 'drm-intel'...
> > > fatal: dumb http transport does not support --depth
> > > 
> > > (I can't remember what happened the first time I tried to clone your 
> > > repository).  So I will try running with this patch on top of 3.13.
> > 
> > Well, use the git:// link with --depth ...
> 
> $ git clone --depth 1 -b drm-intel-nightly git://cgit.freedesktop.org/~danvet/drm-intel/
> Cloning into 'drm-intel'...
> fatal: remote error: access denied or repository not exported: ~danvet/drm-intel/

Erhm, http://cgit.freedesktop.org/~danvet/drm-intel/ is the cgit web view,
the actual git repo is at http://cgit.freedesktop.org/~danvet/drm-intel/
...

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
