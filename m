Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab3L0JsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 04:48:09 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60049 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399Ab3L0JsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 04:48:07 -0500
Date: Fri, 27 Dec 2013 10:48:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: tomi.valkeinen@ti.com, tony@atomide.com, linux@arm.linux.org.uk,
        pali.rohar@gmail.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH] ARM: omapfb: Add early framebuffer memory allocator
Message-ID: <20131227094801.GB17143@amd.pavel.ucw.cz>
References: <52A062A0.3070005@ti.com>
 <1388013159-3036-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388013159-3036-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2013-12-26 01:12:39, Ivaylo Dimitrov wrote:
> From: Ivaylo Dimitrov <freemangordon@abv.bg>
> 
> On memory limited devices, CMA fails easily when asked to allocate big
> chunks of memory like framebuffer memory needed for video playback.
> 
> Add boot parameter "omapfb_memsize" which allocates memory to be used
> as dma coherent memory, so dma_alloc_attrs won't hit CMA allocator when
> trying to allocate memory for the framebuffers
> 
> Signed-off-by: Ivaylo Dimitrov <freemangordon@abv.bg>

Hmm, would it make sense to add a parameter to reserve certain ammount
of memory for CMA? omapfb is probably not the only user hitting
this...?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
