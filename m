Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaKBC3U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 22:29:20 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:39615 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaKBC3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 22:29:16 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/GpzC6kgsRg0so6Qg6u1kR3+cCKYarUnY=
X-DKIM: OpenDKIM Filter v2.0.1 titan 2B1CD60F56E
Date: Sat, 1 Nov 2014 22:29:05 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] irqchip: atmel-aic: add RTT irq fixup
Message-ID: <20141102022905.GT3698@titan.lakedaemon.net>
References: <1409735271-15353-1-git-send-email-boris.brezillon@free-electrons.com>
 <20140914054648.GJ21986@titan.lakedaemon.net>
 <20140915214907.3ec49158@bbrezillon>
 <20140915215356.4c332acd@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915215356.4c332acd@bbrezillon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 09:53:56PM +0200, Boris BREZILLON wrote:
> On Mon, 15 Sep 2014 21:49:07 +0200
> Boris BREZILLON <boris.brezillon@free-electrons.com> wrote:
> 
> > Hi,
> > 
> > On Sun, 14 Sep 2014 01:46:48 -0400
> > Jason Cooper <jason@lakedaemon.net> wrote:
> > 
> > > On Wed, Sep 03, 2014 at 11:07:46AM +0200, Boris BREZILLON wrote:
> > > > The series depends on the acceptation of the RTT DT bindings proposed here
> > > > [1].
> > > > 
> > > > Best Regards,
> > > > 
> > > > Boris
> > > > 
> > > > [1]https://lkml.org/lkml/2014/9/3/145
> > > 
> > > Hmm, the bindings, unfortunately, still seem to be in flux.  Any update?
> > 
> > Actually, all at91 developers seemed to agree on this binding [2], and
> > these changes do not impact the current series.
> > 
> > Anyway, I think it's safer to wait for an official approval before
> > taking this series into irqchip/next.

Care to resend against v3.18-rc1?

thx,

Jason.
