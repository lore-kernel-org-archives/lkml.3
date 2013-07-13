Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240Ab3GMT41 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 15:56:27 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:62109 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab3GMT40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 15:56:26 -0400
MIME-Version: 1.0
X-Originating-IP: [81.235.222.155]
In-Reply-To: <20130710215041.GR11908@titan.lakedaemon.net>
References: <1373352166-10064-1-git-send-email-zhangwm@marvell.com>
	<1373352166-10064-2-git-send-email-zhangwm@marvell.com>
	<20130709124900.GG11908@titan.lakedaemon.net>
	<CAN1soZxiOh6TpbUOCUzK8gNwmvjbT3ihkUWaw8tuZ7md+NVA2g@mail.gmail.com>
	<20130710122433.GO11908@titan.lakedaemon.net>
	<CAN1soZzMvront1-jcBW6-uRKNs0OZNGnmiOjKGZSM28bViB_8A@mail.gmail.com>
	<20130710215041.GR11908@titan.lakedaemon.net>
Date: Sat, 13 Jul 2013 12:56:25 -0700
Message-ID: <CAOesGMi-J5OE998umtyt7awP3nW7iEHFdSiks0aOotsozLJ5pw@mail.gmail.com>
Subject: Re: [PATCH V3 1/3] dts: change Marvell prefix to 'marvell'
From: Olof Johansson <olof@lixom.net>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Neil Zhang <zhangwm@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 2:50 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> On Wed, Jul 10, 2013 at 10:08:50PM +0800, Haojian Zhuang wrote:
>> On Wed, Jul 10, 2013 at 8:24 PM, Jason Cooper <jason@lakedaemon.net> wrote:
>> > On Wed, Jul 10, 2013 at 04:19:46PM +0800, Haojian Zhuang wrote:
>> >> On Tue, Jul 9, 2013 at 8:49 PM, Jason Cooper <jason@lakedaemon.net> wrote:
>> >> > Neil,
>> >> >
>> >> > On Tue, Jul 09, 2013 at 02:42:44PM +0800, Neil Zhang wrote:
>> >> >> The documented vendor prefix for Marvell is 'marvell', not 'mrvl', so
>> >> >> let's change it.
>> >> >>
>> >> >> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
>> >> >> ---
>> >> >>  .../devicetree/bindings/arm/mrvl/intc.txt          |   16 +++---
>> >> >>  .../devicetree/bindings/arm/mrvl/mrvl.txt          |    6 +-
>> >> >>  .../devicetree/bindings/arm/mrvl/timer.txt         |    4 +-
>> >> >>  Documentation/devicetree/bindings/i2c/i2c-pxa.txt  |   14 +++---
>> >> >>  .../devicetree/bindings/mmc/sdhci-pxa.txt          |    8 ++--
>> >> >>  .../devicetree/bindings/rtc/sa1100-rtc.txt         |    4 +-
>> >> >>  .../devicetree/bindings/serial/mrvl-serial.txt     |    2 +-
>> >> >>  arch/arm/boot/dts/mmp2-brownstone.dts              |    2 +-
>> >> >>  arch/arm/boot/dts/mmp2.dtsi                        |   56 ++++++++++----------
>> >> >>  arch/arm/boot/dts/pxa168-aspenite.dts              |    2 +-
>> >> >>  arch/arm/boot/dts/pxa168.dtsi                      |   24 ++++----
>> >> >>  arch/arm/boot/dts/pxa2xx.dtsi                      |   16 +++---
>> >> >>  arch/arm/boot/dts/pxa3xx.dtsi                      |    2 +-
>> >> >>  arch/arm/boot/dts/pxa910-dkb.dts                   |    2 +-
>> >> >>  arch/arm/boot/dts/pxa910.dtsi                      |   27 +++++-----
>> >> >>  arch/arm/mach-mmp/irq.c                            |   16 +++---
>> >> >>  arch/arm/mach-mmp/mmp-dt.c                         |   28 +++++-----
>> >> >>  arch/arm/mach-mmp/mmp2-dt.c                        |   16 +++---
>> >> >>  arch/arm/mach-mmp/time.c                           |    2 +-
>> >> >>  arch/arm/mach-pxa/pxa-dt.c                         |   14 +++---
>> >> >>  drivers/i2c/busses/i2c-pxa.c                       |   10 ++--
>> >> >>  drivers/mmc/host/sdhci-pxav2.c                     |    4 +-
>> >> >>  drivers/mmc/host/sdhci-pxav3.c                     |    4 +-
>> >> >>  drivers/rtc/rtc-sa1100.c                           |    4 +-
>> >> >>  drivers/tty/serial/pxa.c                           |    4 +-
>> >> >>  25 files changed, 144 insertions(+), 143 deletions(-)
>> >> >
>> >> > I agree with the need to change, however, this has been in the binding
>> >> > documentation since v3.5.  I wish we had caught this when we decided
>> >> > against using stock ticker symbols (not all stock markets use
>> >> > alphabetical abbreviated names, not all companies are listed on any
>> >> > stock exchange).
>> >> >
>> >> > To do this properly, the drivers are going to have to be compatible with
>> >> > the old and the new names, and the binding docs updated to reflect the
>> >> > legacy name and the preferred name.
>> >> >
>> >>
>> >> It's better to only use the new names.
>> >
>> > In the dts{i}, yes.  But we don't want to break systems in the field
>> > with "mrvl,..." compatible strings.  Therefore, at least the drivers
>> > need an extra compatible string to support "mrvl,...".
>> >
>> > If it had just been since v3.9, it'd be different/simpler.  However,
>> > several vendors have opted to use kernels newer than v3.5, which makes
>> > this scenario a real possibility.
>> >
>> > thx,
>> >
>> > Jason.
>>
>> Is there any vendor using DT for this Marvell chip? I think the answer is no.
>
> Well, Daniel Drake spoke up for OLPC.  Does that count?

There's stock ticker history for MRVL is available for at least as far
back as 2001, so it's been around for a while. I would argue that the
powerpc guys made a mistake by using the marvell prefix. Either way,
they are not likely to add any new driver or code anytime soon for
these platforms.

Given that we are using mrvl extensively already, I'd say the way
forward is to make the driver handle both compatible values, but only
use mrvl for new code and for all new device tree bindings/data on
ARM.

It's a known issue that we are still in an "in-flux" state when it
comes to bindings on ARM, where people have been free to change them
as needed. At Linaro Connect last week, a group of us got together to
discuss this and I hope that Grant (or maybe someone else) will be
able to post those notes. We have a proposal on how to start moving
away from _everything_ being unstable to a model where parts of the
bindings can be locked down over time to a state where they won't
change. But I won't preempt the proper proposal email by going into
details here.



-Olof
