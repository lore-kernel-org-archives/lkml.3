Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab3CUUiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:38:22 -0400
Received: from londo.lunn.ch ([80.238.139.98]:51054 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057Ab3CUUiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:38:21 -0400
Date: Thu, 21 Mar 2013 21:37:51 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 5/5] arm: dts: Convert mvebu device tree files to 64 bits
Message-ID: <20130321203751.GP21478@lunn.ch>
References: <1363883179-1361-1-git-send-email-gregory.clement@free-electrons.com>
 <1363883179-1361-6-git-send-email-gregory.clement@free-electrons.com>
 <20130321201533.GN21478@lunn.ch>
 <20130321212236.1015295d@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321212236.1015295d@skate>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 09:22:36PM +0100, Thomas Petazzoni wrote:
> Dear Andrew Lunn,
> 
> On Thu, 21 Mar 2013 21:15:33 +0100, Andrew Lunn wrote:
> 
> > Could you recommend a document which introduces LPAE.
> > 
> > Only being able to address 7GB seems a bit odd to me. I kind of
> > expected you set up the translation tables to map a page in the 32 bit
> > address range to any arbitrary page in the 40 bit address range. So
> > leaving 0xC0000000 to 0xffffffff in the 32bit address range clear is
> > easy. But why do you loose space in the 40bit address range?
> 
> translation tables convert virtual addresses to physical addresses.
> Here, we are only talking about physical addresses. There is an overlap
> between the physical addresses used by the RAM, and the physical
> addresses at which I/O devices are visible.
> 
> And I'm not sure the SDRAM address decoding windows allows to split the
> first 4 GB of RAM into two areas, one that would be mapped starting at
> physical address 0x0, and another area that would be mapped at a
> different address (above 4 GB).

So why not map the whole SDRAM above 4GB physical address?

   Thanks
	Andrew
