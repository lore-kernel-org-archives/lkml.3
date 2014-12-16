Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbaLPQjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:39:54 -0500
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:46288 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaLPQjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:39:53 -0500
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Tue, 16 Dec 2014 11:39:51 -0500
To: Nishanth Menon <nm@ti.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: omap5/dra7xx: Fix frequency typos.
Message-ID: <20141216163951.GM24110@csclub.uwaterloo.ca>
References: <cover.1418421100.git.lsorense@csclub.uwaterloo.ca>
 <5f7d841d41f6485022e07a22c332d3c8ea985bfa.1418421100.git.lsorense@csclub.uwaterloo.ca>
 <54903C6A.5070807@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54903C6A.5070807@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 08:06:34AM -0600, Nishanth Menon wrote:
> On 12/12/2014 04:08 PM, Lennart Sorensen wrote:
> > The switch statement of the possible list of SYSCLK1 frequencies is
> > missing a 0 in 4 out of the 7 frequencies.
> > 
> > Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
> > ---
> >  arch/arm/mach-omap2/timer.c |    8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
> > index 4f61148..fb0cb2b 100644
> > --- a/arch/arm/mach-omap2/timer.c
> > +++ b/arch/arm/mach-omap2/timer.c
> > @@ -513,11 +513,11 @@ static void __init realtime_counter_init(void)
> >  	rate = clk_get_rate(sys_clk);
> >  	/* Numerator/denumerator values refer TRM Realtime Counter section */
> >  	switch (rate) {
> > -	case 1200000:
> > +	case 12000000:
> >  		num = 64;
> >  		den = 125;
> >  		break;
> > -	case 1300000:
> > +	case 13000000:
> >  		num = 768;
> >  		den = 1625;
> >  		break;
> > @@ -529,11 +529,11 @@ static void __init realtime_counter_init(void)
> >  		num = 192;
> >  		den = 625;
> >  		break;
> > -	case 2600000:
> > +	case 26000000:
> >  		num = 384;
> >  		den = 1625;
> >  		break;
> > -	case 2700000:
> > +	case 27000000:
> >  		num = 256;
> >  		den = 1125;
> >  		break;
> > 
> 
> 
> Also please add:
> Fixes: fa6d79d27614 ("ARM: OMAP: Add initialisation for the real-time
> counter")
> 
> With that,
> 
> Acked-by: Nishanth Menon <nm@ti.com>

Should I send a new version with that added, or will someone else handle
doing that bit?

-- 
Len Sorensen
