Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab3DWTzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 15:55:50 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:52816 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab3DWTzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 15:55:49 -0400
Date: Tue, 23 Apr 2013 16:55:58 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>,
        Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Maen Suleiman <maen@marvell.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH] drivers: memory: Introduce Marvell EBU Device Bus driver
Message-ID: <20130423195556.GA3335@localhost>
References: <1366744886-3019-1-git-send-email-elezegarcia@gmail.com>
 <20130423194822.GA7214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130423194822.GA7214@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 12:48:22PM -0700, Greg KH wrote:
> On Tue, Apr 23, 2013 at 04:21:26PM -0300, Ezequiel Garcia wrote:
> > From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> > 
> > Marvell EBU SoCs such as Armada 370/XP, Orion5x (88f5xxx) and
> > Discovery (mv78xx0) supports a Device Bus controller to access several
> > kinds of memories and I/O devices (NOR, NAND, SRAM, FPGA).
> > 
> > This commit adds a driver to handle this controller. So far only
> > Armada 370, Armada XP and Discovery SoCs are supported.
> > 
> > The driver must be registered through a device tree node;
> > as explained in the binding document.
> > 
> > For each child node in the device tree, this driver will:
> >   * set timing parameters
> >   * register a child device
> >   * setup an address decoding window, using the mbus driver
> > 
> > Keep in mind the address decoding window setup is only a temporary hack.
> > This code will be removed from this devbus driver as soon as a proper device
> > tree binding for the mbus driver is added.
> > 
> > Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> > Hi Greg,
> > 
> > This patch Applies on today linux-next.
> > I don't know if we are still in time for you to take this
> > and merge it into v3.10.
> > 
> > All of the DT related changes are in linux-next through arm-soc,
> > but this driver was left out and, unless you take it, will
> > get queued for v3.11. So it's up to you.
> 
> It's way too late for new drivers for 3.10, sorry.  I'll hold on to this
> and merge it to my trees after 3.10-rc1 is out for inclusion in 3.11.
> 

That's fine, no problem.

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
