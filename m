Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbaDNS4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:56:39 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:41870 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068AbaDNS4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:56:09 -0400
Date: Mon, 14 Apr 2014 11:56:03 -0700
From: Steven Noonan <steven@uplinklabs.net>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>
Subject: Re: REGRESSION 3.14 i915 warning & mouse cursor vanishing
Message-ID: <20140414185602.GA892@falcon>
References: <20140414164010.GA1019@falcon>
 <867g6ryd2e.fsf@hiro.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <867g6ryd2e.fsf@hiro.keithp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 11:35:05AM -0700, Keith Packard wrote:
> Steven Noonan <steven@uplinklabs.net> writes:
> 
> > Was using my machine normally, then my mouse cursor vanished. After switching
> > to a VT and back to X11, my cursor came back. But I did notice a nasty trace in
> > dmesg (below).
> 
> I don't think the trace below is related to the cursor disappearing.

Any idea what the trace is all about then? Seems it has something to do
with runtime power management (maybe my aggressive kernel command-line
options are triggering it).

> I found a pair of bugs (one in the intel driver, one in the X server)
> which can cause cursor disappearances. I just sent an intel driver patch
> to the intel-gfx list with the subject:
> 
>         [PATCH] load_cursor_argb is supposed to return a Bool, not void
> 
> I've posted the X server patch once, and will respond to some review
> comments. Either is sufficient to get a cursor back, the intel driver
> one means you get a working hardware cursor again, rather than using a
> software cursor by mistake.

OK, good to know. Thanks for pointing those out!
