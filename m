Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750910AbaLPNF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 08:05:26 -0500
Received: from www.linutronix.de ([62.245.132.108]:49943 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaLPNFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 08:05:23 -0500
Date: Tue, 16 Dec 2014 14:04:42 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marc Zyngier <marc.zyngier@arm.com>
cc: Stefan Agner <stefan@agner.ch>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] irqchip: vf610-mscm: add support for MSCM interrupt
 router
In-Reply-To: <5490094D.6090300@arm.com>
Message-ID: <alpine.DEB.2.11.1412161404010.17382@nanos>
References: <1418594998-2361-1-git-send-email-stefan@agner.ch> <1418594998-2361-2-git-send-email-stefan@agner.ch> <548EB0FD.3030206@arm.com> <41a603b345dbee4f2507e80ea0f8bb96@agner.ch> <5490094D.6090300@arm.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2014, Marc Zyngier wrote:
> On 15/12/14 20:58, Stefan Agner wrote:
> > The same line adjustment will break the 80 character border... But I
> > agree, it's ugly the way it is now. Will put them in the same line.
> 
> Never mind what checkpatch says. Readability trumps it anytime.

If you want to obey checkpatch then move that stuff into a seperate
inline function.

Thanks,

	tglx
