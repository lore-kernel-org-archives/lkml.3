Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbaETUBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 16:01:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34278 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaETUBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 16:01:15 -0400
Date: Wed, 21 May 2014 05:01:04 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 0/6] soc: ti: Add Keystone Navigator drivers
Message-ID: <20140520200104.GA27786@kroah.com>
References: <1398296783-1176-1-git-send-email-santosh.shilimkar@ti.com>
 <537B5F5E.9080703@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537B5F5E.9080703@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 09:57:50AM -0400, Santosh Shilimkar wrote:
> Greg,
> 
> On Wednesday 23 April 2014 07:46 PM, Santosh Shilimkar wrote:
> > Here is an updated version of the Keystone Navigator drivers after
> > addressing comments from earlier version [1].
> > 
> > The QMSS found on Keystone SOCs is one of the main hardware sub
> > system which forms the backbone of the Keystone Multi-core Navigator.
> > QMSS consist of queue managers, packed-data structure processors(PDSP),
> > linking RAM, descriptor pools and infrastructure DMA.
> > 
> > After the discussion and alignment [2] on Navigator DMA, now we pair
> > this driver along with QMSS. Initially this driver was proposed as DMA
> > engine driver but since the hardware is not typical DMA engine and doesn't
> > comply with typical DMA engine driver needs, that approach was naked.
> > 
> > These two drivers works as infrastructure drivers for subsystems like
> > Ethernet subsystem, SRIO subsystem, Crypto Engines etc on Keystone
> > SOC families. Testing is done with NetCP(ethernet) subsystem drivers.
> > 
> > I would like to get these drivers merged in upcoming(3.16) window, so
> > any help in terms of review is appreciated. Thanks
> > 
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Kumar Gala <galak@codeaurora.org>
> > Cc: Olof Johansson <olof@lixom.net>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Grant Likely <grant.likely@linaro.org>
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > 
> I plan to respin v3 of the series for the few device tree related
> comments I received from Rob H (thanks Rob). Can you please have a
> look and gsee if you have any comments so that I can include them
> in next version.

I am so far behind in patch review, please just redo them based on
other's comments and resend, don't wait for me.

greg k-h
