Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab3ILP76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:59:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50557 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab3ILP75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:59:57 -0400
Date: Thu, 12 Sep 2013 17:59:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] drm/i915: kill set_need_resched
Message-ID: <20130912155951.GC31370@twins.programming.kicks-ass.net>
References: <1379001449-17380-1-git-send-email-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379001449-17380-1-git-send-email-daniel.vetter@ffwll.ch>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 05:57:28PM +0200, Daniel Vetter wrote:
> This is just a remnant from the old days when our reset handling was
> horribly racy, suffered from terribly locking issues and often happily
> live-locked. Those days are now gone so we can drop the hacks and just
> rip the reschedule-point out.
> 
> Reported-by: Peter Zijlstra <peterz@infradead.org>

Thanks!

Acked-by: Peter Zijlstra <peterz@infradead.org>
