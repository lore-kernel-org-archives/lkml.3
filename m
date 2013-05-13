Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab3EMUNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 16:13:07 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:65156 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755244Ab3EMUNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 16:13:06 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/DAAF8bygMvv80fuLxbE2RHi4E5lpD/e0=
Date: Mon, 13 May 2013 16:12:34 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>,
        Ezequiel Garcia <elezegarcia@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Maen Suleiman <maen@marvell.com>, linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] drivers: memory: Introduce Marvell EBU Device Bus
 driver
Message-ID: <20130513201234.GB31290@titan.lakedaemon.net>
References: <1366744886-3019-1-git-send-email-elezegarcia@gmail.com>
 <20130423194822.GA7214@kroah.com>
 <20130423195556.GA3335@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130423195556.GA3335@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 04:55:58PM -0300, Ezequiel Garcia wrote:
> On Tue, Apr 23, 2013 at 12:48:22PM -0700, Greg KH wrote:
> > On Tue, Apr 23, 2013 at 04:21:26PM -0300, Ezequiel Garcia wrote:
> > > From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> > > 
> > > Marvell EBU SoCs such as Armada 370/XP, Orion5x (88f5xxx) and
> > > Discovery (mv78xx0) supports a Device Bus controller to access several
> > > kinds of memories and I/O devices (NOR, NAND, SRAM, FPGA).
> > > 
> > > This commit adds a driver to handle this controller. So far only
> > > Armada 370, Armada XP and Discovery SoCs are supported.
> > > 
> > > The driver must be registered through a device tree node;
> > > as explained in the binding document.
> > > 
> > > For each child node in the device tree, this driver will:
> > >   * set timing parameters
> > >   * register a child device
> > >   * setup an address decoding window, using the mbus driver
> > > 
> > > Keep in mind the address decoding window setup is only a temporary hack.
> > > This code will be removed from this devbus driver as soon as a proper device
> > > tree binding for the mbus driver is added.
> > > 
> > > Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> > > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > > ---
> > > Hi Greg,
> > > 
> > > This patch Applies on today linux-next.
> > > I don't know if we are still in time for you to take this
> > > and merge it into v3.10.
> > > 
> > > All of the DT related changes are in linux-next through arm-soc,
> > > but this driver was left out and, unless you take it, will
> > > get queued for v3.11. So it's up to you.
> > 
> > It's way too late for new drivers for 3.10, sorry.  I'll hold on to this
> > and merge it to my trees after 3.10-rc1 is out for inclusion in 3.11.
> > 
> 
> That's fine, no problem.

Ezequiel,

I'm dropping this from my tree as Greg has said he would take it.

thx,

Jason.
