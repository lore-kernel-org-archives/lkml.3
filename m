Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbaA3NEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 08:04:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaA3NEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 08:04:08 -0500
Date: Thu, 30 Jan 2014 05:05:15 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Satish Patel <satish.patel@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        rob@landley.net, tony@atomide.com, grant.likely@linaro.org,
        robh+dt@kernel.org
Subject: Re: [PATCH v2 0/5] Smart Card(SC) interface, TI USIM & NxP SC phy
 driver
Message-ID: <20140130130515.GC23970@kroah.com>
References: <1390192434-19386-1-git-send-email-satish.patel@ti.com>
 <52E9E8B0.2020000@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E9E8B0.2020000@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 11:22:48AM +0530, Satish Patel wrote:
> 
> On 1/20/2014 10:03 AM, Satish Patel wrote:
> > Changes from v1:
> > * RFC(v1) comments are fixed
> >
> > ** removed "gpio_to_irq" as GPIO controller process  cell from DT and
> > give it to DT node
> > ** comments on documentation
> > ** few other comments on null checks are resolved
> >
> > * BWT timing configuration is added to ti-usim driver
> >
> > v1 cover letter link#
> > https://lkml.org/lkml/2014/1/6/250
> >
> > Satish Patel (5):
> >   sc_phy:SmartCard(SC) PHY interface to SC controller
> >   misc: tda8026: Add NXP TDA8026 PHY driver
> >   char: ti-usim: Add driver for USIM module on AM43xx
> >   ARM: dts: AM43xx: DT entries added for ti-usim
> >   ARM: dts: AM43xx-epos-evm: DT entries  for ti-usim and phy
> >
> >  Documentation/devicetree/bindings/misc/tda8026.txt |   19 +
> >  .../devicetree/bindings/ti-usim/ti-usim.txt        |   31 +
> >  Documentation/sc_phy.txt                           |  171 ++
> >  arch/arm/boot/dts/am4372.dtsi                      |   10 +
> >  arch/arm/boot/dts/am43x-epos-evm.dts               |   43 +
> >  drivers/char/Kconfig                               |    7 +
> >  drivers/char/Makefile                              |    1 +
> >  drivers/char/ti-usim-hw.h                          |  863 +++++++++
> >  drivers/char/ti-usim.c                             | 1859 ++++++++++++++++++++
> >  drivers/misc/Kconfig                               |    7 +
> >  drivers/misc/Makefile                              |    1 +
> >  drivers/misc/tda8026.c                             | 1255 +++++++++++++
> >  include/linux/sc_phy.h                             |  132 ++
> >  include/linux/ti-usim.h                            |   98 +
> >  14 files changed, 4497 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/misc/tda8026.txt
> >  create mode 100644 Documentation/devicetree/bindings/ti-usim/ti-usim.txt
> >  create mode 100644 Documentation/sc_phy.txt
> >  create mode 100644 drivers/char/ti-usim-hw.h
> >  create mode 100644 drivers/char/ti-usim.c
> >  create mode 100644 drivers/misc/tda8026.c
> >  create mode 100644 include/linux/sc_phy.h
> >  create mode 100644 include/linux/ti-usim.h
> Any comments on this patch series ?
> 
> If not,
> Can you accept these patches for next merge window

It's the middle of this merge window, and I can't accept any patches
until after 3.14-rc1 is out, at which point I'll start to work on my
patch backlog.

thanks,

greg k-h
