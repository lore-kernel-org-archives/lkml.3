Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934418Ab3IDIbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 04:31:47 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:56969 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051Ab3IDIbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 04:31:44 -0400
Date: Wed, 4 Sep 2013 17:31:41 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, johnstultz@linaro.org,
        linux@arm.linux.org.uk, arnd@arndb.de, linux-sh@vger.kernel.org,
        sboyd@codeaurora.org, rob.herring@calxeda.com, olof@lixom.net,
        santosh.shilimkar@ti.com, grant.likely@linaro.org, tglx@linutronix.de
Subject: Re: [PATCH] clocksource: em_sti: Set cpu_possible_mask to fix SMP
 broadcast
Message-ID: <20130904083139.GD17329@verge.net.au>
References: <20130904080151.24562.91334.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130904080151.24562.91334.sendpatchset@w520>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 05:01:51PM +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Update the STI driver by setting cpu_possible_mask to make EMEV2
> SMP work as expected together with the ARM broadcast timer.
> 
> This breakage was introduced by:
> 
> f7db706 ARM: 7674/1: smp: Avoid dummy clockevent being preferred over real hardware clock-event
> 
> Without this fix SMP operation is broken on EMEV2 since no
> broadcast timer interrupts trigger on the secondary CPU cores.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
> 
>  Thanks to feedback from Stephen Boyd this is is a reworked version of:
>  [PATCH] clocksource: em_sti: Adjust clock event rating to fix SMP broadcast
> 
>  drivers/clocksource/em_sti.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Tested-by: Simon Horman <horms+renesas@verge.net.au>

I will let this sit for a few days to see if there is any further feedback.

