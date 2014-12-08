Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142AbaLHORW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 09:17:22 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34466 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaLHORT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 09:17:19 -0500
Date: Mon, 8 Dec 2014 15:17:50 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Paulo Zanoni <przanoni@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Damien Lespiau <damien.lespiau@gmail.com>
Subject: Re: [Intel-gfx] [PATCH] gpu: drm: i915: intel_display.c: Remove
 unused function
Message-ID: <20141208141750.GR20350@phenom.ffwll.local>
Mail-Followup-To: Paulo Zanoni <przanoni@gmail.com>,
	Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Daniel Vetter <daniel.vetter@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	Damien Lespiau <damien.lespiau@gmail.com>
References: <1417976957-15049-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20141208084228.GI20350@phenom.ffwll.local>
 <CA+gsUGSM43z6AXi0-evJni_fDX_=rjj6gBOCZmhLrqjyUhZeFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+gsUGSM43z6AXi0-evJni_fDX_=rjj6gBOCZmhLrqjyUhZeFg@mail.gmail.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 10:32:49AM -0200, Paulo Zanoni wrote:
> 2014-12-08 6:42 GMT-02:00 Daniel Vetter <daniel@ffwll.ch>:
> > On Sun, Dec 07, 2014 at 07:29:17PM +0100, Rickard Strandqvist wrote:
> >> Remove the function intel_output_name() that is not used anywhere.
> >>
> >> This was partially found by using a static code analysis program called cppcheck.
> >>
> >> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> >
> > Queued for 3.20, thanks for the patch.
> 
> This function was created for the "DDI personality" patches. We merged
> the function but never ended up merging the patch containing the
> callers...

Oops, I've thought this is a renmant from the very first days of kms that
somehow stuck around. That's what I get for once not using git blame
excessively :( Want me to drop the patch again?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
