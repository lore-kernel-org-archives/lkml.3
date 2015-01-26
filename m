Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbbAZNlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:41:22 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:43156 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbbAZNlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:41:19 -0500
Date: Mon, 26 Jan 2015 13:40:53 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Stefan Agner <stefan@agner.ch>
Cc: Thomas Gleixner <tglx@linutronix.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND v3 0/3] irqchip: vf610-mscm: add support for MSCM
 interrupt router
Message-ID: <20150126134053.GH23313@leverpostej>
References: <1421309046-22452-1-git-send-email-stefan@agner.ch>
 <alpine.DEB.2.11.1501261115300.5526@nanos>
 <36990c90fa3d2ee0849227f31cbafb54@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36990c90fa3d2ee0849227f31cbafb54@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

> > What about the DT bindings? I'm relucant to pick that up w/o acks from
> > the DT folks.
> 
> The bindings are straight forward interrupt-controller bindings, since
> it uses the hierarchic irq domain stuff. The only uncommon thing is that
> I also added "syscon" as compatible, since the module has functionality
> which might be required by other drivers (e.g. register to generate
> CPU2CPU interrupt or processor personality information).

I'd expect the CPU2CPU interrupt handling to be part of the interrupt
controller driver, so I don't see why that would require "syscon".

What exactly do you mean by "processor personality information"?

Mark.
