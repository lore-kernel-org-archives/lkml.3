Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab3ILUli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:41:38 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:34019 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab3ILUld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:41:33 -0400
Date: Thu, 12 Sep 2013 22:41:45 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] drm/i915: kill set_need_resched
Message-ID: <20130912204145.GD5459@phenom.ffwll.local>
Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1379001449-17380-1-git-send-email-daniel.vetter@ffwll.ch>
 <20130912155951.GC31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912155951.GC31370@twins.programming.kicks-ass.net>
X-Operating-System: Linux phenom 3.10-2-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 05:59:51PM +0200, Peter Zijlstra wrote:
> On Thu, Sep 12, 2013 at 05:57:28PM +0200, Daniel Vetter wrote:
> > This is just a remnant from the old days when our reset handling was
> > horribly racy, suffered from terribly locking issues and often happily
> > live-locked. Those days are now gone so we can drop the hacks and just
> > rip the reschedule-point out.
> > 
> > Reported-by: Peter Zijlstra <peterz@infradead.org>
> 
> Thanks!
> 
> Acked-by: Peter Zijlstra <peterz@infradead.org>

Merged to drm-intel-fixes with Chris' irc-review that we indeed don't need
this any more to duct-tape over bugs.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
