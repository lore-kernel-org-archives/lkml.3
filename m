Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177Ab3EGTGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 15:06:42 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:36591 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab3EGTGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 15:06:39 -0400
Date: Tue, 7 May 2013 22:06:28 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [RESEND][PATCH 1/3] arm: dts: introduce config HAS_BANDGAP
Message-ID: <20130507190628.GI5634@blackmetal.musicnaut.iki.fi>
References: <1367874058-2378-1-git-send-email-eduardo.valentin@ti.com>
 <1367874058-2378-2-git-send-email-eduardo.valentin@ti.com>
 <20130506213413.GH5634@blackmetal.musicnaut.iki.fi>
 <20130506223653.GA12089@obsidianresearch.com>
 <51884971.9050508@ti.com>
 <20130507003651.GA26035@obsidianresearch.com>
 <5188FE54.6050200@ti.com>
 <20130507182711.GB28628@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130507182711.GB28628@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 12:27:11PM -0600, Jason Gunthorpe wrote:
> On Tue, May 07, 2013 at 09:15:00AM -0400, Eduardo Valentin wrote:
> > > But broadly the direction seems that drivers should have minimal
> > > dependencies so, eg, the thermal maintainer compiling for x86 should
> > > be able to compile test/static analyze your driver..
> 
> > Well, I do not see much of this attempt actually. Do you have some link
> > / evidene that shows someone who actually cares about compiling drivers
> > for targets that they are not used for? On this specific driver, I
> > actually have  had exactly the opposite advice [1]. I am not convinced
> > people actually want to do that.
> 
> There was a discussion a bit ago, but I can't find a link.. The
> context was subsystem maintainers are being asked to look after more
> code with the DT transition moving things out of arch/arm and at least
> one complained they couldn't even compile test on x86... But again, I
> can't find a link and you are right, there are lots and lots of
> 'depends ARCH..' style things in kConfig already.
> 
> Lets just call it something to think about.

Tomi started a thread related to this recently:

	http://marc.info/?l=linux-kernel&m=136731558332265&w=2

I think there's some good reasons listed there, but I guess up to the
subsystem maintainers to decide what they prefer.

A.
