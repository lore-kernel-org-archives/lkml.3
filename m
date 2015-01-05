Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbbAEBhU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 20:37:20 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:55627 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbbAEBhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 20:37:18 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+OlRafy7bIf1GV0ibJ1r5fFStNs/xE+Vw=
X-DKIM: OpenDKIM Filter v2.0.1 titan AD36B63CDA4
Date: Sun, 4 Jan 2015 20:36:56 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] irqchip: gic: Allow interrupt level to be set for
 PPIs.
Message-ID: <20150105013656.GA3486@titan.lakedaemon.net>
References: <1417437909-20923-1-git-send-email-Liviu.Dudau@arm.com>
 <20141209122919.GR821@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141209122919.GR821@e106497-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 12:29:19PM +0000, Liviu Dudau wrote:
> On Mon, Dec 01, 2014 at 12:45:09PM +0000, Liviu Dudau wrote:
> > During a recent cleanup of the arm64 DTs it has become clear that
> > the handling of PPIs in xxxx_set_type() is incorrect. The ARM TRMs
> > for GICv2 and later allow for "implementation defined" support for
> > setting the edge or level type of the PPI interrupts and don't restrict
> > the activation level of the signal. Current ARM implementations
> > do restrict the PPI level type to IRQ_TYPE_LEVEL_LOW, but licensees
> > of the IP can decide to shoot themselves in the foot at any time.
> > 
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > ---
> > 
> > Made a stupid mistake in v2 and got my bit test confused with logical test.
> 
> Gentle ping!
> 
> Any comments here? Russell, are you OK with this approach?

Now that the holidays are over, I'd like to get some feedback from Marc
at a minimum...

thx,

Jason.
