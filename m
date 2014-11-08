Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbaKHJhe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 04:37:34 -0500
Received: from down.free-electrons.com ([37.187.137.238]:35086 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753478AbaKHJhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 04:37:32 -0500
Date: Sat, 8 Nov 2014 10:37:28 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] irqchip: atmel-aic: add RTT irq fixup
Message-ID: <20141108103728.32341ce5@bbrezillon>
In-Reply-To: <20141102022905.GT3698@titan.lakedaemon.net>
References: <1409735271-15353-1-git-send-email-boris.brezillon@free-electrons.com>
	<20140914054648.GJ21986@titan.lakedaemon.net>
	<20140915214907.3ec49158@bbrezillon>
	<20140915215356.4c332acd@bbrezillon>
	<20141102022905.GT3698@titan.lakedaemon.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Sat, 1 Nov 2014 22:29:05 -0400
Jason Cooper <jason@lakedaemon.net> wrote:

> On Mon, Sep 15, 2014 at 09:53:56PM +0200, Boris BREZILLON wrote:
> > On Mon, 15 Sep 2014 21:49:07 +0200
> > Boris BREZILLON <boris.brezillon@free-electrons.com> wrote:
> > 
> > > Hi,
> > > 
> > > On Sun, 14 Sep 2014 01:46:48 -0400
> > > Jason Cooper <jason@lakedaemon.net> wrote:
> > > 
> > > > On Wed, Sep 03, 2014 at 11:07:46AM +0200, Boris BREZILLON wrote:
> > > > > The series depends on the acceptation of the RTT DT bindings proposed here
> > > > > [1].
> > > > > 
> > > > > Best Regards,
> > > > > 
> > > > > Boris
> > > > > 
> > > > > [1]https://lkml.org/lkml/2014/9/3/145
> > > > 
> > > > Hmm, the bindings, unfortunately, still seem to be in flux.  Any update?
> > > 
> > > Actually, all at91 developers seemed to agree on this binding [2], and
> > > these changes do not impact the current series.
> > > 
> > > Anyway, I think it's safer to wait for an official approval before
> > > taking this series into irqchip/next.
> 
> Care to resend against v3.18-rc1?

Not sure if you noticed, but I have resent this series after rebasing it
on 3.18-rc3:

http://comments.gmane.org/gmane.linux.kernel/1819609

Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
