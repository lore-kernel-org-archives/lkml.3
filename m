Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbaBQCUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 21:20:34 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:12088 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752322AbaBQCUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 21:20:32 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18vBolpioqzKefSfuo98lDMB3f2Fl1m38U=
X-DKIM: OpenDKIM Filter v2.0.1 titan 2A90D529816
Date: Sun, 16 Feb 2014 21:20:22 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Haklai <nadavh@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 0/6] Marvell Armada 375 and 38x clocks drivers
Message-ID: <20140217022022.GF7862@titan.lakedaemon.net>
References: <1392053569-28037-1-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392053569-28037-1-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 06:32:43PM +0100, Gregory CLEMENT wrote:
> Hi Mike,
> 
> Here are patches that add the clocks drivers for two new Marvell ARM
> SOCs that belong to the mach-mvebu family: the Armada 375 and the
> Armada 380/385. They are based on Cortex-A9 CPU cores, and share a
> number of peripherals with their predecessors in the mach-mvebu
> family.
> 
> The drivers added are similar to the one already used for the other
> SoCs of this family, as usual only the data are different the logic
> remains the same ans allow us to use the common part.
> 
> The core support (arch/arm/mach-mvebu) for these SOCs have just been
> posted, and we're aiming at having this merged for 3.15 if possible.
> 
> Thanks,
> 
> Gregory
> 
> Gregory CLEMENT (4):
>   clk: mvebu: add clock support for Armada 375
>   dt: Update binding information for mvebu core clocks with Armada 375
>   dt: Update binding information for mvebu gating clocks with Armada 375
>   clk: mvebu: add clock support for Armada 380/385
> 
> Thomas Petazzoni (2):
>   dt: Update binding information for mvebu core clocks with Armada
>     380/385
>   dt: Update binding information for mvebu gating clocks with Armada
>     380/385
> 
>  .../devicetree/bindings/clock/mvebu-core-clock.txt |  14 ++
>  .../bindings/clock/mvebu-gated-clock.txt           |  65 +++++++-
>  drivers/clk/mvebu/Kconfig                          |   8 +
>  drivers/clk/mvebu/Makefile                         |   2 +
>  drivers/clk/mvebu/armada-375.c                     | 184 +++++++++++++++++++++
>  drivers/clk/mvebu/armada-38x.c                     | 167 +++++++++++++++++++
>  6 files changed, 436 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/clk/mvebu/armada-375.c
>  create mode 100644 drivers/clk/mvebu/armada-38x.c

Hey guys,

I've tentatively applied this series to mvebu/clk-3xx.  I can't build
test it until I pull in the core support.  So I'll keep it separate from
the regular clock driver changes just in case.

thx,

Jason.
