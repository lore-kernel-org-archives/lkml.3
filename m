Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab3GJMUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 08:20:38 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:18084 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751173Ab3GJMUh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 08:20:37 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18mKA2Ok26lq57qKssYsiI9uTXyah1a2Mo=
Date: Wed, 10 Jul 2013 08:20:23 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Neil Zhang <zhangwm@marvell.com>
Cc: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V3 1/3] dts: change Marvell prefix to 'marvell'
Message-ID: <20130710122023.GN11908@titan.lakedaemon.net>
References: <1373352166-10064-1-git-send-email-zhangwm@marvell.com>
 <1373352166-10064-2-git-send-email-zhangwm@marvell.com>
 <20130709124900.GG11908@titan.lakedaemon.net>
 <175CCF5F49938B4D99B2E3EF7F558EBE3DBC97FA8F@SC-VEXCH4.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <175CCF5F49938B4D99B2E3EF7F558EBE3DBC97FA8F@SC-VEXCH4.marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil,

On Wed, Jul 10, 2013 at 12:25:17AM -0700, Neil Zhang wrote:
> Jason,
> 
> > -----Original Message-----
> > From: Jason Cooper [mailto:jason@lakedaemon.net]
> > Sent: 2013年7月9日 20:49
> > To: Neil Zhang
> > Cc: grant.likely@linaro.org; haojian.zhuang@gmail.com; arnd@arndb.de;
> > devicetree-discuss@lists.ozlabs.org; linux-kernel@vger.kernel.org;
> > linux-arm-kernel@lists.infradead.org
> > Subject: Re: [PATCH V3 1/3] dts: change Marvell prefix to 'marvell'
> >
> > Neil,
> >
> > On Tue, Jul 09, 2013 at 02:42:44PM +0800, Neil Zhang wrote:
> > > The documented vendor prefix for Marvell is 'marvell', not 'mrvl', so
> > > let's change it.
> > >
> > > Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> > > ---
> > >  .../devicetree/bindings/arm/mrvl/intc.txt          |   16 +++---
> > >  .../devicetree/bindings/arm/mrvl/mrvl.txt          |    6 +-
> > >  .../devicetree/bindings/arm/mrvl/timer.txt         |    4 +-
> > >  Documentation/devicetree/bindings/i2c/i2c-pxa.txt  |   14 +++---
> > >  .../devicetree/bindings/mmc/sdhci-pxa.txt          |    8 ++--
> > >  .../devicetree/bindings/rtc/sa1100-rtc.txt         |    4 +-
> > >  .../devicetree/bindings/serial/mrvl-serial.txt     |    2 +-
> > >  arch/arm/boot/dts/mmp2-brownstone.dts              |    2 +-
> > >  arch/arm/boot/dts/mmp2.dtsi                        |   56
> > ++++++++++----------
> > >  arch/arm/boot/dts/pxa168-aspenite.dts              |    2 +-
> > >  arch/arm/boot/dts/pxa168.dtsi                      |   24
> > ++++----
> > >  arch/arm/boot/dts/pxa2xx.dtsi                      |   16 +++---
> > >  arch/arm/boot/dts/pxa3xx.dtsi                      |    2 +-
> > >  arch/arm/boot/dts/pxa910-dkb.dts                   |    2 +-
> > >  arch/arm/boot/dts/pxa910.dtsi                      |   27
> > +++++-----
> > >  arch/arm/mach-mmp/irq.c                            |   16
> > +++---
> > >  arch/arm/mach-mmp/mmp-dt.c                         |   28
> > +++++-----
> > >  arch/arm/mach-mmp/mmp2-dt.c                        |   16
> > +++---
> > >  arch/arm/mach-mmp/time.c                           |    2 +-
> > >  arch/arm/mach-pxa/pxa-dt.c                         |   14
> > +++---
> > >  drivers/i2c/busses/i2c-pxa.c                       |   10 ++--
> > >  drivers/mmc/host/sdhci-pxav2.c                     |    4 +-
> > >  drivers/mmc/host/sdhci-pxav3.c                     |    4 +-
> > >  drivers/rtc/rtc-sa1100.c                           |    4 +-
> > >  drivers/tty/serial/pxa.c                           |    4 +-
> > >  25 files changed, 144 insertions(+), 143 deletions(-)
> >
> > I agree with the need to change, however, this has been in the binding
> > documentation since v3.5.  I wish we had caught this when we decided
> > against using stock ticker symbols (not all stock markets use alphabetical
> > abbreviated names, not all companies are listed on any stock exchange).
> >
> > To do this properly, the drivers are going to have to be compatible with the
> > old and the new names, and the binding docs updated to reflect the legacy
> > name and the preferred name.
> >
> Do you mean it's better to support both legacy and preferred name at the same time?

Please keep in mind that the DT is supposed to be tied to the hardware,
*not* the kernel.  iow, a dtb comes with a board, and the user/OS
upgrades the kernel as needed w/o upgrading or changing the dtb.

So the question you need to ask yourself is: Are there any users (since
v3.5) that are doing this?  If so, they have "mrvl,..." compatible
strings in their dtbs.  You don't want to break their systems on kernel
upgrade, right?

So you can change the binding to say the correct string is
"marvell,...", but that driver X must have an extra compatible entry for
"mrvl,..." so as not to break dtbs generated from v3.5 to v3.10.

You might even be able to get away with just adding a comment beside the
"mrvl,..." string in the driver.

Does that make sense?

thx,

Jason.
