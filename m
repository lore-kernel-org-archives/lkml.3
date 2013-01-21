Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab3AUINw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 03:13:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36967 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752008Ab3AUINv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 03:13:51 -0500
Date: Mon, 21 Jan 2013 17:13:44 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, David Dajun Chen <dchen@diasemi.com>
Subject: Re: [patch v1 2/5] regulator: da9055 change irq state to default
Message-ID: <20130121081343.GB4598@opensource.wolfsonmicro.com>
References: <C3AE124F08223B42BC95AEB82F0F6CED4313C79B@KCHJEXMB03.kpit.com>
 <1358755458.11245.95.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358755458.11245.95.camel@dhruva>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 01:34:18PM +0530, Ashish Jangam wrote:
> > On Fri, Jan 18, 2013 at 10:52:45AM +0530, Ashish Jangam wrote:

> > > This patch changes the irq state from high to the now default low
> > > state.

> > > This patch is dependent on the DA9055 MFD.

> > Why is this change required and why is there a dependency here?

> It has been decided to have nIRQ therefore the main mfd IRQ state needs

Won't this break all existing systems?

> to be changed. And since mfd children follows mfd irq state therefore
> the dependency; though in case of mfd this may not affect.  

What makes you say that there is a dependency here?  It's really not at
all obvious why a change to the primary IRQ signalling mechanism would
affect the internal interrupts of the device.
