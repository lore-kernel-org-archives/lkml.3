Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbaLONsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 08:48:25 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:56258 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaLONsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 08:48:24 -0500
Date: Mon, 15 Dec 2014 14:48:58 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Emmanuel Benisty <benisty.e@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@linux.ie>
Subject: Re: [Regression] 83f45fc turns machine's screen off
Message-ID: <20141215134858.GY27182@phenom.ffwll.local>
Mail-Followup-To: Emmanuel Benisty <benisty.e@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	Dave Airlie <airlied@linux.ie>
References: <CA+i8gKK0sj55s-Gk8Y36KM4yBFLvLotffbSodjH5Gsd_yxd5Sg@mail.gmail.com>
 <CAKMK7uGa_dHnie8EACcX0mQvc-uGpsgQHjWGN_obxPa3O6SJbw@mail.gmail.com>
 <CA+i8gKKGBviLBaS8b=swqv2OWgh2Uc+m-TT8LVYcPehcYd903A@mail.gmail.com>
 <CA+i8gKJPPPUXrxY5q+81xZG91azygoUb27R_Wid3GTpb3-1-rw@mail.gmail.com>
 <20141215073156.GK27182@phenom.ffwll.local>
 <CA+i8gKKKOjvawuL_Wfi454H=-ghMh727B_te7SVjCQgSrmt-rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+i8gKKKOjvawuL_Wfi454H=-ghMh727B_te7SVjCQgSrmt-rg@mail.gmail.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 12:46:09PM +0100, Emmanuel Benisty wrote:
> On Mon, Dec 15, 2014 at 8:31 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
> 
> [---snip---]
> 
> > Sorry for the delay. Absolutely no difference in the relevant parts of the
> > log. There could be the chance that something is hidden somewhere, so can
> > please grab a new set of logs but this time with drm.debug=0xe?
> 
> Thanks for your reply Daniel. However, former logs were already
> generated with drm.debug=0xe.

Argh, I've meant 0xf. That enables the super-verbose stuff which might
shed some light on what's happening differently here.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
