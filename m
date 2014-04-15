Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbaDOTnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:43:14 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:58098 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaDOTnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:43:08 -0400
Date: Tue, 15 Apr 2014 21:43:03 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Steven Noonan <steven@uplinklabs.net>
Cc: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] REGRESSION 3.14 i915 warning & mouse cursor vanishing
Message-ID: <20140415194303.GH1023@phenom.ffwll.local>
Mail-Followup-To: Steven Noonan <steven@uplinklabs.net>,
	Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20140414164010.GA1019@falcon>
 <867g6ryd2e.fsf@hiro.keithp.com>
 <20140414185602.GA892@falcon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414185602.GA892@falcon>
X-Operating-System: Linux phenom 3.14.0+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 11:56:03AM -0700, Steven Noonan wrote:
> On Mon, Apr 14, 2014 at 11:35:05AM -0700, Keith Packard wrote:
> > Steven Noonan <steven@uplinklabs.net> writes:
> > 
> > > Was using my machine normally, then my mouse cursor vanished. After switching
> > > to a VT and back to X11, my cursor came back. But I did notice a nasty trace in
> > > dmesg (below).
> > 
> > I don't think the trace below is related to the cursor disappearing.
> 
> Any idea what the trace is all about then? Seems it has something to do
> with runtime power management (maybe my aggressive kernel command-line
> options are triggering it).

Please test without them. Currently runtime pm should be disabled still on
vlv (since it's incomplete in 3.14). If you've force-enabled that then you
get to keep all pieces ;-)

In general don't set any i915 options if you're not a developer or someone
else who _really_ knows what's going on.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
