Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbaFSQJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:09:55 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36226 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757478AbaFSQJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:09:54 -0400
Date: Thu, 19 Jun 2014 18:09:46 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: Re: [Intel-gfx] Display glitching (and possibly related lockup) in
 3.16-rc1?
Message-ID: <20140619160946.GX5821@phenom.ffwll.local>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
References: <nsxppi6tcsg.fsf@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nsxppi6tcsg.fsf@closure.thunk.org>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 12:14:55PM -0400, Theodore Ts'o wrote:
> Is this a known problem?
> 
> On my T540p, occasionally the display will go black and then be
> completely locked.  One time when this happened, the display started
> glitching and tearing (like what you might see if an analog display had
> a loose connector and it was being wiggled) when the system locked up,
> but the at least 75% of the time when the bug manifests, the screen goes
> black instead.
> 
> This appears to only happen when the system is running on battery --- it
> doesn't seem to manifest if I'm plugged into the AC mains.  And I've
> been typing an e-mail message when the system locks up, so I don't think
> it's related to DPMS or the screen saver kicking in.
> 
> I can try to bisect this regression (3.15 didn't have this problem), but
> I thought I would ask first if this was a known problem.   I don't know
> for certain that it's an i915 bug, but the symptoms do somewhat point in
> that direction, especially the display glitches.

Doesn't ring a bell, but can you please boot with drm.debug=0xe and attach
dmesg here so we know what kind of hardware you have? Also any dying
breadths over netconsole or similar? Can't hurt to check that before doing
the bisect.

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
