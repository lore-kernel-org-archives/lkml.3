Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab3FER0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 13:26:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50150 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab3FER0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:26:30 -0400
Date: Wed, 5 Jun 2013 19:25:47 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Will Deacon <will.deacon@arm.com>
cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "djbw@fb.com" <djbw@fb.com>
Subject: Re: [PATCH] dmatest: do not allow to interrupt ongoing tests
In-Reply-To: <20130605171001.GC26663@mudshark.cambridge.arm.com>
Message-ID: <Pine.LNX.4.64.1306051924190.19739@axis700.grange>
References: <1369308593-3723-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <Pine.LNX.4.64.1305242353210.7187@axis700.grange> <1369638667.29283.197.camel@smile>
 <20130605171001.GC26663@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:IoE/wudUYx27uabOSSorc6ejkYUwpR08dHHSIQTrIn0
 Ei0mah9sLqGmSOxVwAdC4vrKdJJbb4hWTVydMxx5UCQwnjLJzR
 sOnzzMXTCFHOzdevU1FlLJfGGLJpM//hUaUlvwKcdJ02I0NBwb
 8dApkvuHQJCbVRORAjQtfL0Zfvqap//YBUKaDDNRhk/XN3kpJD
 lK3oTbGYgirmOEmykpbvUiOmsFG57qkEvZAZRlTlcm0lWFr6mL
 4zbnX1zy2MseXnnV0z65GlOzgeiGqEURMu7ZHUfO/toUZ2l1kU
 J2+Ui48HSX7ksJiSiZhNCRIFq4rNkv0/d8s/SCNEMH5hd8rdk3
 hF3a1r5LEjFJ9WceRkfrTb+gov/FUZoJvK3cd4U7wEGdjj4Qff
 tPQHenKDMbYUQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Jun 2013, Will Deacon wrote:

> On Mon, May 27, 2013 at 08:11:07AM +0100, Andy Shevchenko wrote:
> > On Fri, 2013-05-24 at 23:55 +0200, Guennadi Liakhovetski wrote: 
> > > On Thu, 23 May 2013, Andy Shevchenko wrote:
> > > 
> > > > When user interrupts ongoing transfers the dmatest may end up with console
> > > > lockup, oops, or data mismatch. This patch prevents user to abort any ongoing
> > > > test.
> > > 
> > > Personally I would be against such a change. What about interrupting the 
> > > test with rmmod?
> > >  Is it still possible after this your patch or not? If not 
> > > - this doesn't seem like a good idea to me. Why don't we just fix those 
> > > bugs, that you're describing?
> > 
> > The behaviour of the module is returned to the same page by this patch
> > as it was before (w/o debugfs).
> > 
> > The user can interrupt tests by rmmod, but it will take time up to
> > timeout.
> > 
> > I appreciate if you can do a deeper analysis of what happened in
> > case Will reported.
> 
> Did this query hold up the application of this patch? I'd really like to see
> *something* in 3.10, otherwise dmatest will be broken.

Not from me, no. I just expressed a doubt, the author thinks there is no 
problem, and I have no capacity atm to try to verify it, so, my query 
shouldn't be considered a nak.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
