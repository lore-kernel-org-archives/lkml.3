Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab3GOEjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 00:39:52 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:44665 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751784Ab3GOEjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 00:39:51 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18im25MJ439Nzo6Z7K+fJtrfW8E59tD4Ao=
Date: Mon, 15 Jul 2013 00:39:41 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Olof Johansson <olof@lixom.net>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Neil Zhang <zhangwm@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V3 1/3] dts: change Marvell prefix to 'marvell'
Message-ID: <20130715043922.GB9817@titan.lakedaemon.net>
References: <1373352166-10064-1-git-send-email-zhangwm@marvell.com>
 <1373352166-10064-2-git-send-email-zhangwm@marvell.com>
 <20130709124900.GG11908@titan.lakedaemon.net>
 <CAN1soZxiOh6TpbUOCUzK8gNwmvjbT3ihkUWaw8tuZ7md+NVA2g@mail.gmail.com>
 <20130710122433.GO11908@titan.lakedaemon.net>
 <CAN1soZzMvront1-jcBW6-uRKNs0OZNGnmiOjKGZSM28bViB_8A@mail.gmail.com>
 <20130710215041.GR11908@titan.lakedaemon.net>
 <CAOesGMi-J5OE998umtyt7awP3nW7iEHFdSiks0aOotsozLJ5pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMi-J5OE998umtyt7awP3nW7iEHFdSiks0aOotsozLJ5pw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 13, 2013 at 12:56:25PM -0700, Olof Johansson wrote:
> On Wed, Jul 10, 2013 at 2:50 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> > On Wed, Jul 10, 2013 at 10:08:50PM +0800, Haojian Zhuang wrote:
> >> On Wed, Jul 10, 2013 at 8:24 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> >> > On Wed, Jul 10, 2013 at 04:19:46PM +0800, Haojian Zhuang wrote:
> >> >> On Tue, Jul 9, 2013 at 8:49 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> >> >> > Neil,
> >> >> >
> >> >> > On Tue, Jul 09, 2013 at 02:42:44PM +0800, Neil Zhang wrote:
> >> >> >> The documented vendor prefix for Marvell is 'marvell', not 'mrvl', so
> >> >> >> let's change it.
> >> >> >>
> >> >> >> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> >> >> >> ---
> >> >> >>  .../devicetree/bindings/arm/mrvl/intc.txt          |   16 +++---
> >> >> >>  .../devicetree/bindings/arm/mrvl/mrvl.txt          |    6 +-
> >> >> >>  .../devicetree/bindings/arm/mrvl/timer.txt         |    4 +-
> >> >> >>  Documentation/devicetree/bindings/i2c/i2c-pxa.txt  |   14 +++---
> >> >> >>  .../devicetree/bindings/mmc/sdhci-pxa.txt          |    8 ++--
> >> >> >>  .../devicetree/bindings/rtc/sa1100-rtc.txt         |    4 +-
> >> >> >>  .../devicetree/bindings/serial/mrvl-serial.txt     |    2 +-
> >> >> >>  arch/arm/boot/dts/mmp2-brownstone.dts              |    2 +-
> >> >> >>  arch/arm/boot/dts/mmp2.dtsi                        |   56 ++++++++++----------
> >> >> >>  arch/arm/boot/dts/pxa168-aspenite.dts              |    2 +-
> >> >> >>  arch/arm/boot/dts/pxa168.dtsi                      |   24 ++++----
> >> >> >>  arch/arm/boot/dts/pxa2xx.dtsi                      |   16 +++---
> >> >> >>  arch/arm/boot/dts/pxa3xx.dtsi                      |    2 +-
> >> >> >>  arch/arm/boot/dts/pxa910-dkb.dts                   |    2 +-
> >> >> >>  arch/arm/boot/dts/pxa910.dtsi                      |   27 +++++-----
> >> >> >>  arch/arm/mach-mmp/irq.c                            |   16 +++---
> >> >> >>  arch/arm/mach-mmp/mmp-dt.c                         |   28 +++++-----
> >> >> >>  arch/arm/mach-mmp/mmp2-dt.c                        |   16 +++---
> >> >> >>  arch/arm/mach-mmp/time.c                           |    2 +-
> >> >> >>  arch/arm/mach-pxa/pxa-dt.c                         |   14 +++---
> >> >> >>  drivers/i2c/busses/i2c-pxa.c                       |   10 ++--
> >> >> >>  drivers/mmc/host/sdhci-pxav2.c                     |    4 +-
> >> >> >>  drivers/mmc/host/sdhci-pxav3.c                     |    4 +-
> >> >> >>  drivers/rtc/rtc-sa1100.c                           |    4 +-
> >> >> >>  drivers/tty/serial/pxa.c                           |    4 +-
> >> >> >>  25 files changed, 144 insertions(+), 143 deletions(-)
> >> >> >
> >> >> > I agree with the need to change, however, this has been in the binding
> >> >> > documentation since v3.5.  I wish we had caught this when we decided
> >> >> > against using stock ticker symbols (not all stock markets use
> >> >> > alphabetical abbreviated names, not all companies are listed on any
> >> >> > stock exchange).
> >> >> >
> >> >> > To do this properly, the drivers are going to have to be compatible with
> >> >> > the old and the new names, and the binding docs updated to reflect the
> >> >> > legacy name and the preferred name.
> >> >> >
> >> >>
> >> >> It's better to only use the new names.
> >> >
> >> > In the dts{i}, yes.  But we don't want to break systems in the field
> >> > with "mrvl,..." compatible strings.  Therefore, at least the drivers
> >> > need an extra compatible string to support "mrvl,...".
> >> >
> >> > If it had just been since v3.9, it'd be different/simpler.  However,
> >> > several vendors have opted to use kernels newer than v3.5, which makes
> >> > this scenario a real possibility.
> >> >
> >> > thx,
> >> >
> >> > Jason.
> >>
> >> Is there any vendor using DT for this Marvell chip? I think the answer is no.
> >
> > Well, Daniel Drake spoke up for OLPC.  Does that count?
> 
> There's stock ticker history for MRVL is available for at least as far
> back as 2001, so it's been around for a while. I would argue that the
> powerpc guys made a mistake by using the marvell prefix. Either way,
> they are not likely to add any new driver or code anytime soon for
> these platforms.

I think this boils down to which is more important, adhering to stock
tickers, or adhering to what's actually in the kernel before we (arm-soc
dt effort) got here?

I don't mind if the answer is either way, but back when we started
converting kirkwood to DT we had this discussion, and settled on
"marvell,..." because of powerpc/mv643xx_eth.  Now, it appears we're
flip-flopping.

> Given that we are using mrvl extensively already,

?!  Only -mmp and -pxa have used mrvl.  _everything_ for -kirkwood,
-dove, -orion5x, and -mvebu has used marvell.

$ git grep 'compatible\b.*\bmrvl,' -- drivers/ | wc -l
9
$ git grep 'compatible\b.*\bmarvell,' -- drivers/ | wc -l
54

This is from mvebu/for-next, and does _not_ include Sebastian's patches
going though DaveM's tree adding proper bindings to mv643xx_eth (for
v3.11) which also uses marvell.

> I'd say the way forward is to make the driver handle both compatible
> values,

Agreed, but only where necessary.

> but only use mrvl for new code and for all new device tree
> bindings/data on ARM.

If that's what you want, then no problem.  I just wish this had been
brought up sooner.  We're damn near finished converting -kirkwood to DT.

> It's a known issue that we are still in an "in-flux" state when it
> comes to bindings on ARM, where people have been free to change them
> as needed.

True, but we're doing a pretty good job of thinking them through
carefully and not messing with them once applied.  It's only going to
become more stringent (by necessity of popularity).

> At Linaro Connect last week, a group of us got together to
> discuss this and I hope that Grant (or maybe someone else) will be
> able to post those notes. We have a proposal on how to start moving
> away from _everything_ being unstable to a model where parts of the
> bindings can be locked down over time to a state where they won't
> change. But I won't preempt the proper proposal email by going into
> details here.

Documentation/devicetree/bindings/staging/ ?  :-P

thx,

Jason.
