Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab3JQNrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 09:47:18 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48795 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755421Ab3JQNrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 09:47:16 -0400
Date: Thu, 17 Oct 2013 14:47:01 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Christian Daudt <bcm@fixthebug.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [RESEND PATCH v2 0/6] Update Kona drivers to use clocks
Message-ID: <20131017134701.GC24056@e106331-lin.cambridge.arm.com>
References: <1381960030-1640-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381960030-1640-1-git-send-email-tim.kryger@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 10:47:04PM +0100, Tim Kryger wrote:
> This series declares the clocks present on bcm11351 (aka bcm281xx) SoCs
> to be fixed at the rates configured by development bootloaders and then
> updates the Kona drivers to make use of clock calls where appropriate.
> 
> This patch series depends on the following three commits being present:
> 
> https://lkml.org/lkml/2013/9/18/409
> https://lkml.org/lkml/2013/9/20/305
> http://www.spinics.net/lists/arm-kernel/msg274973.html
> 
> Changes in v2:
>   - Renamed bsc4_clk to pmu_bsc_clk
> 
> Tim Kryger (6):
>   ARM: dts: Declare clocks as fixed on bcm11351
>   ARM: dts: Specify clocks for UARTs on bcm11351
>   ARM: dts: Specify clocks for SDHCIs on bcm11351
>   clocksource: kona: Add basic use of external clock
>   ARM: dts: Specify clocks for timer on bcm11351
>   mmc: sdhci-bcm-kona: Add basic use of clocks
> 
>  arch/arm/boot/dts/bcm11351.dtsi      | 111 +++++++++++++++++++++++++++++++++--
>  drivers/clocksource/bcm_kona_timer.c |  14 ++++-
>  drivers/mmc/host/sdhci-bcm-kona.c    |  30 +++++++++-

This requires a description in the binding documents, so we can figure
out which clocks we need to describe, and how to describe them.

Thanks,
Mark.
