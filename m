Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab3JGWGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 18:06:37 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:57620 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3JGWGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 18:06:31 -0400
Date: Mon, 7 Oct 2013 18:06:27 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Dave Martin <Dave.Martin@arm.com>
cc: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        linux-samsung-soc@vger.kernel.org,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Rob Landley <rob@landley.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Tarek Dakhran <t.dakhran@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Naour Romain <romain.naour@openwide.fr>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH 3/6] ARM: EXYNOS: add Exynos Dual Cluster Support
In-Reply-To: <20131007140343.GA12030@localhost.localdomain>
Message-ID: <alpine.LFD.2.03.1310071804030.3023@syhkavp.arg>
References: <20131007140343.GA12030@localhost.localdomain>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Oct 2013, Dave Martin wrote:

> On Fri, Oct 04, 2013 at 03:51:31PM -0400, Nicolas Pitre wrote:
> > No FIQs are supposed to ever race with this code.
> 
> There is an anomaly though: FIQ and external abort don't seem to get
> explicitly masked anywhere, either on the suspend or powerdown paths.
> Sometimes either or both remains unmasked (I tried some trace in the
> TC2 MCPM backend to confirm this.)
> 
> Looks like a possible omission in the arch/arm/ suspend and shutdown
> code, rather than a problem specific to MCPM.

Possibly, yes.

Feel free to post a patch.


Nicolas
