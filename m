Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaHaRcy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 13:32:54 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:39485 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaHaRcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 13:32:52 -0400
Date: Sun, 31 Aug 2014 10:23:46 -0700
From: Olof Johansson <olof@lixom.net>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Alex Shi <alex.shi@linaro.org>, arm@kernel.org,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mark.brown@linaro.org" <mark.brown@linaro.org>,
        "tixy@linaro.org" <tixy@linaro.org>
Subject: Re: [PATCH] vexpress/spc: fix a build warning on array bounds
Message-ID: <20140831172346.GA3464@localhost>
References: <1405509716-19591-1-git-send-email-alex.shi@linaro.org>
 <53C661CB.7040306@arm.com>
 <53FFDB50.3060904@linaro.org>
 <1409284859.25020.3.camel@rojo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409284859.25020.3.camel@rojo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 09:00:59PM -0700, Pawel Moll wrote:
> On pi??, 2014-08-29 at 02:45 +0100, Alex Shi wrote:
> > On 07/16/2014 07:28 PM, Sudeep Holla wrote:
> > > 
> > > 
> > > On 16/07/14 12:21, Alex Shi wrote:
> > >> With ARCH_VEXPRESS_SPC option, kernel build has the following
> > >> warning:
> > >>
> > >> arch/arm/mach-vexpress/spc.c: In function ???ve_spc_clk_init???:
> > >> arch/arm/mach-vexpress/spc.c:431:38: warning: array subscript is below
> > >> array bounds [-Warray-bounds]
> > >>    struct ve_spc_opp *opps = info->opps[cluster];
> > >>                                        ^
> > >> since 'cluster' maybe '-1' in UP system. This patch does a active
> > >> checking to fix this issue.
> > >>
> > > 
> > > Good catch, looks fine to me.
> > > 
> > > Acked-by: Sudeep Holla <sudeep.holla@arm.com>
> > 
> > Anyone like to pick up this build warning fix? Or comments are appreciated!
> 
> My fault, sorry, forgot about it...
> 
> Acked-by: Pawel Moll <pawel.moll@arm.com>
> 
> Arnd, Olof, could you please queue it as a fix? Happy to push a branch
> if you wish.

Applied. In the future, please feel free to just resend the patch
with the acked-bys added, no need to send a pull request for a single
patch. It's slightly more convenient to get a fresh copy of the patch
into arm@kernel.org folders, since now I had to go hunt it down on the
list it was originally posted.


-Olof
