Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab3ILQAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 12:00:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50655 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab3ILQAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 12:00:44 -0400
Date: Thu, 12 Sep 2013 18:00:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>
Subject: Re: [PATCH 2/2] drm/udl: rip out set_need_resched
Message-ID: <20130912160025.GD31370@twins.programming.kicks-ass.net>
References: <1379001449-17380-1-git-send-email-daniel.vetter@ffwll.ch>
 <1379001449-17380-2-git-send-email-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379001449-17380-2-git-send-email-daniel.vetter@ffwll.ch>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 05:57:29PM +0200, Daniel Vetter wrote:
> This very much looks like copypasta from drm/i915's fault handler.
> It was used there to duct-tape over issues around gpu reset handling.
> 
> Since that can't ever happen for udl and there's seemingly no other
> reason for this just drop it.
> 
> Reported-by: Peter Zijlstra <peterz@infradead.org>

Thanks!

Acked-by: Peter Zijlstra <peterz@infradead.org>
