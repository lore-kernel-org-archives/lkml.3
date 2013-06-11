Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab3FKIpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 04:45:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:60666 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab3FKIpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 04:45:50 -0400
Date: Tue, 11 Jun 2013 10:45:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        John Stultz <john.stultz@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Marvell Orion SoC irqchip and clocksource
In-Reply-To: <1370536034-23956-1-git-send-email-sebastian.hesselbarth@gmail.com>
Message-ID: <alpine.LFD.2.02.1306111043200.22970@ionos>
References: <1370536034-23956-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jun 2013, Sebastian Hesselbarth wrote:

> This patch set introduces DT-aware irqchip and clocksource drivers for
> Marvell Orion SoCs (Kirkwood, Dove, Orion5x, MV78x00) and corresponding
> patches for Dove and Kirkwood to enable them for DT-boards.
> 
> The irqchip driver, of course, depends on Thomas Gleixner's work on
> irqdomain support for generic chip (tip irq/core).
> 
> The ARM part of this patch set has a quite ridiculuous dependency havoc
> of mv643xx_eth DT support (current net-next) that will add to both irqchip
> and clocksource branches respectively. Therefore, I suggest that irq
> and clocksource maintainers take in the mere drivers (Patches 1+2) and
> Jason Cooper handles the remaining patches when all three drivers have
> surfaced on mainline linux.

I provided a tip branch irq/for-arm, which contains only these changes
and can be pulled by SoC/subarch maintainers so we don't end up with a
dependency nightmare. Just mention that you pulled it from me when
sending the pull request to Linus.
 
Thanks,

	tglx
