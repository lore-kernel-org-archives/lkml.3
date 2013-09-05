Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763426Ab3IEHdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 03:33:12 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:55493 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763402Ab3IEHdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 03:33:09 -0400
Date: Thu, 5 Sep 2013 16:33:07 +0900
From: Simon Horman <horms@verge.net.au>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, arnd@arndb.de, linux-sh@vger.kernel.org,
        rob.herring@calxeda.com, olof@lixom.net, santosh.shilimkar@ti.com,
        grant.likely@linaro.org, tglx@linutronix.de
Subject: Re: [PATCH] clocksource: em_sti: Set cpu_possible_mask to fix SMP
 broadcast
Message-ID: <20130905073307.GE8334@verge.net.au>
References: <20130904080151.24562.91334.sendpatchset@w520>
 <20130904083727.GE17329@verge.net.au>
 <5226F2E2.3070202@linaro.org>
 <52276001.8070801@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52276001.8070801@codeaurora.org>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 09:29:53AM -0700, Stephen Boyd wrote:
> On 09/04/13 01:44, Daniel Lezcano wrote:
> >
> >> On Wed, Sep 04, 2013 at 05:01:51PM +0900, Magnus Damm wrote:
> >>> From: Magnus Damm <damm@opensource.se>
> >>>
> >>> Update the STI driver by setting cpu_possible_mask to make EMEV2
> >>> SMP work as expected together with the ARM broadcast timer.
> >>>
> >>> This breakage was introduced by:
> >>>
> >>> f7db706 ARM: 7674/1: smp: Avoid dummy clockevent being preferred over real hardware clock-event
> >>>
> >>> Without this fix SMP operation is broken on EMEV2 since no
> >>> broadcast timer interrupts trigger on the secondary CPU cores.
> >>>
> >>> Signed-off-by: Magnus Damm <damm@opensource.se>
> >> Tested-by: Simon Horman <horms+renesas@verge.net.au>
> >>
> >> I will let this sit for a few days to see if there is any further feedback.
> 
> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

Thanks, I have queue this up.
I will let it sit in next for a little bit
and then forward it on to Daniel.
