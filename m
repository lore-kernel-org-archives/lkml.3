Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab3GKXy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 19:54:28 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:58472 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246Ab3GKXy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:54:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130710215041.GR11908@titan.lakedaemon.net>
References: <1373352166-10064-1-git-send-email-zhangwm@marvell.com>
	<1373352166-10064-2-git-send-email-zhangwm@marvell.com>
	<20130709124900.GG11908@titan.lakedaemon.net>
	<CAN1soZxiOh6TpbUOCUzK8gNwmvjbT3ihkUWaw8tuZ7md+NVA2g@mail.gmail.com>
	<20130710122433.GO11908@titan.lakedaemon.net>
	<CAN1soZzMvront1-jcBW6-uRKNs0OZNGnmiOjKGZSM28bViB_8A@mail.gmail.com>
	<20130710215041.GR11908@titan.lakedaemon.net>
Date: Fri, 12 Jul 2013 07:54:25 +0800
Message-ID: <CAN1soZzuiukY9qASFNcH0k=zH8=uT=71bKejPss44FCzNy=X-A@mail.gmail.com>
Subject: Re: [PATCH V3 1/3] dts: change Marvell prefix to 'marvell'
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Neil Zhang <zhangwm@marvell.com>, Grant Likely <grant.likely@linaro.org>,
        Bergmann Arnd <arnd@arndb.de>, devicetree-discuss@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 5:50 AM, Jason Cooper <jason@lakedaemon.net> wrote:
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
>
> thx,
>
> Jason.
>

We don't know they used DT on Marvell MMP2/MMP3. So they don't have DTS file
in kernel, we could use both old name & new name in driver.

Regards
Haojian
