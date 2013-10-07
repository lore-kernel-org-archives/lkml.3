Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab3JGQiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:38:00 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:60122 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab3JGQhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:37:55 -0400
Date: Mon, 7 Oct 2013 09:37:26 -0700
From: Olof Johansson <olof@lixom.net>
To: Simon Horman <horms@verge.net.au>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        khilman@linaro.org, arnd@arndb.de, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH/RFC] clocksource: Consolidate SH and ARM mach-shmobile
 Kconfig bits
Message-ID: <20131007163726.GC15413@quad.lixom.net>
References: <20130925233709.16540.66903.sendpatchset@w520>
 <20130927044323.GC16541@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130927044323.GC16541@verge.net.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 01:43:25PM +0900, Simon Horman wrote:
> On Thu, Sep 26, 2013 at 08:37:09AM +0900, Magnus Damm wrote:
> > From: Magnus Damm <damm@opensource.se>
> > 
> > Based on request from Olof Johansson, move ARM mach-shmobile
> > clocksource entries to drivers/clocksource/Kconfig, and at
> > the same time make the SH architecture use these entries.
> > 
> > Kconfig entries for CMT, MTU2, TMU and STI are with this patch
> > now kept in one place. The SH SYS_SUPPORTS_nnn bits are dropped
> > to simplye let the user select the appropriate ones using Kconfig
> > instead of trying to filter available timers based on SoC.
> > 
> > Known issues:
> >  1) Not yet wrappend in menu/endmenu, populates the root driver menu
> >  -> proposal: Create separate patch to wrap all the clocksource entries?
> 
> That seems reasonable to me.
> 
> >  2) Should the entries be sorted?
> >  -> proposal: Ignore cosmetic bits
> 
> I propose that you sort the entries are adding
> but leave the rest of the entries as is.
> 
> >  3) What is correct dependency for multiplatform and single platform?
> >  -> proposal: Perhaps we should simply default to no?
> 
> I'm not sure that I understand the issue here.
> 
> >  4) Is single patch across 2 architectures and drivers/clocksource OK?
> >  -> proposal: Keep it like this if possible
> 
> Olof, I would like your opinion on this but from my pov this seems
> reasonable. Especially as one of the architectures (sh) is seeing very little
> change at this time.

(Sorry for the delayed response, the renesas volume email can be large and
I don't always read it when it comes in).


Yeah, as long as you have appropriate acks and don't expect conflicts.


-Olof
