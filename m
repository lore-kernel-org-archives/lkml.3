Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbaLHOOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 09:14:37 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:60501 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621AbaLHOOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 09:14:34 -0500
Date: Mon, 8 Dec 2014 15:15:06 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        Daniel Vetter <daniel.vetter@intel.com>,
        kernel-janitors@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux@rasmusvillemoes.dk, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, joe@perches.com
Subject: Re: [PATCH 7/20] drm/i915: fix misspelling of current function in
 string
Message-ID: <20141208141506.GQ20350@phenom.ffwll.local>
Mail-Followup-To: Jani Nikula <jani.nikula@linux.intel.com>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	Daniel Vetter <daniel.vetter@intel.com>,
	kernel-janitors@vger.kernel.org, intel-gfx@lists.freedesktop.org,
	linux@rasmusvillemoes.dk, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, joe@perches.com
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
 <1417980062-25151-8-git-send-email-Julia.Lawall@lip6.fr>
 <87fvcqo2w4.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fvcqo2w4.fsf@intel.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 12:24:27PM +0200, Jani Nikula wrote:
> On Sun, 07 Dec 2014, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> > Replace a misspelled function name by %s and then __func__.
> >
> > This was done using Coccinelle, including the use of Levenshtein distance,
> > as proposed by Rasmus Villemoes.
> >
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > ---
> > The semantic patch is difficult to summarize, but is available in the cover
> > letter of this patch series.
> >
> > The message is sort of ambiguous, but I assume that it is intended to refer
> > to the function in which the problem is detected.
> 
> Hmm, DRM_DEBUG prints __func__ too.

We've killed the pin ioctl for 3.20 hence didn't even bother to come up
with an opinion ;-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
