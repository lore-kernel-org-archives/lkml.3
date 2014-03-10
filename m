Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbaCJOGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:06:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:50575 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbaCJOGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:06:04 -0400
Date: Mon, 10 Mar 2014 15:06:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Paul Bolle <pebolle@tiscali.nl>
cc: Julian Wollrath <jwollrath@web.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
In-Reply-To: <1394447253.2979.12.camel@x220>
Message-ID: <alpine.DEB.2.02.1403101504590.18573@ionos.tec.linutronix.de>
References: <20140310110410.5b2218f6@ilfaris> <1394447253.2979.12.camel@x220>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2014, Paul Bolle wrote:

> On Mon, 2014-03-10 at 11:04 +0100, Julian Wollrath wrote:
> > on a Thinkpad x121e (AMD E-450 APU) with version 3.13.5 and earlier of
> > the kernel I get:
> > [...]
> > [    0.000000] tsc: Fast TSC calibration using PIT
> > [    0.001000] tsc: Detected 1646.619 MHz processor
> > [    0.000004] Calibrating delay loop (skipped), value calculated using
> > timer frequency.. 3293.23 BogoMIPS (lpj=1646619)
> > [...]
> > 
> > 
> > but starting with v3.14-rc1 the fast TSC calibration fails:
> > [...]
> > [    0.000000] tsc: Fast TSC calibration failed
> > [    0.000000] tsc: PIT calibration matches HPET. 1 loops
> > [    0.000000] tsc: Detected 1646.490 MHz processor
> > [...]
> > 
> > If you need more information, please do not hesitate to ask.
> 
> I submitted a patch to downgrade the "Fast TSC calibration failed"
> message to KERN_INFO level, see https://lkml.org/lkml/2012/9/26/131 .
> That patch was basically ignored. I've carried it locally ever since.

And how is this related to Julians observation, that fast calibration
works in 3.13, but stopped to work in 3.14-rc ?

Thanks,

	tglx
