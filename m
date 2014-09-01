Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaIAHwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 03:52:54 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:38126 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbaIAHwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 03:52:53 -0400
Message-ID: <1409557969.5049.14.camel@marge.simpson.net>
Subject: Re: [drm/i915/3.17] panic in i915_digport_work_func
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>
Date: Mon, 01 Sep 2014 09:52:49 +0200
In-Reply-To: <CAPM=9txZ5mS3u-7FrjCMF6T3sATfAU2Y+fpyXi-REPWXExBajA@mail.gmail.com>
References: <1409382202.5141.36.camel@marge.simpson.net>
	 <1409486735.4991.19.camel@marge.simpson.net>
	 <CAPM=9txZ5mS3u-7FrjCMF6T3sATfAU2Y+fpyXi-REPWXExBajA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-01 at 17:02 +1000, Dave Airlie wrote: 
> >     drm/i915: add DP 1.2 MST support (v0.7)
> >
> >     This adds DP 1.2 MST support on Haswell systems.
> >
> I've attached a patch that might fix this, please test and let me know.

Lappy hasn't exploded in 20 boot cycles, which judging by previous
behavior should mean all is well (knocks anti-deterministic wood).
Thanks.

-Mike

