Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab3CQFXk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 01:23:40 -0400
Received: from mail-ia0-f179.google.com ([209.85.210.179]:63143 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab3CQFXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 01:23:37 -0400
MIME-Version: 1.0
In-Reply-To: <513838F2.60101@ti.com>
References: <F3DBB1B3EF102E4994C89758CFCA32412CC4E9@DBDE01.ent.ti.com>
	<CABYxbz5GyxYaHANgdpwBNaaR6tnu=6LJuUNSvL7DEzU=4CPHcA@mail.gmail.com>
	<F3DBB1B3EF102E4994C89758CFCA32412CC74F@DBDE01.ent.ti.com>
	<CABYxbz62JrMB95p5i9iu2G=B4ETXLrYbLsyFEFR5F+WVD6YNnQ@mail.gmail.com>
	<20130306175313.GQ11806@atomide.com>
	<513838F2.60101@ti.com>
Date: Sun, 17 Mar 2013 10:53:36 +0530
Message-ID: <CABYxbz7bLZxX-6U3O9nRsKxAXbg0nEta55eO-ERuotPnw=X5BQ@mail.gmail.com>
Subject: Re: [PATCH V4] ARM: dts: add minimal DT support for DevKit8000.
From: Anil Kumar <anilk4.v@gmail.com>
To: Benoit Cousson <b-cousson@ti.com>
Cc: Tony Lindgren <tony@atomide.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux@arm.linux.org.uk, Grant Likely <grant.likely@secretlab.ca>,
        Thomas Weber <thomas@tomweber.eu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On Thu, Mar 7, 2013 at 12:21 PM, Benoit Cousson <b-cousson@ti.com> wrote:
> Hi,
>
> On 03/06/2013 06:53 PM, Tony Lindgren wrote:
>> * Anil Kumar <anilk4.v@gmail.com> [130305 18:40]:
>>> Hi Tony,
>>>
>>>>> From: linux-arm-kernel [mailto:linux-arm-kernel-
>>>>> bounces@lists.infradead.org] On Behalf Of Anil Kumar
>>>>> Sent: Wednesday, February 27, 2013 8:03 AM
>>>>> To: devicetree-discuss@lists.ozlabs.org; linux-omap@vger.kernel.org;
>>>>> linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
>>>>> Cc: linux@arm.linux.org.uk; Cousson, Benoit; Tony Lindgren; Grant
>>>>> Likely; Anil Kumar; thomas@tomweber.eu
>>>>> Subject: Re: FW: [PATCH V4] ARM: dts: add minimal DT support for
>>>>> DevKit8000.
>>>>>
>>>>> Hi,
>>>>>>
>>>>>> DevKit8000 is a beagle board clone from Timll, sold by
>>>>>> armkits.com. The DevKit8000 has RS232 serial port, LCD, DVI-D,
>>>>>> S-Video, Ethernet, SD/MMC, keyboard, camera, SPI, I2C, USB and
>>>>>> JTAG interface.
>>>>>>
>>>>>> This patch adds the basic DT support for devkit8000. At this time,
>>>>> Information
>>>>>> of twl4030 (PMIC), MMC1, I2C1 and leds are added.
>>>>>>
>>>>>> Signed-off-by: Anil Kumar <anilk4.v@gmail.com>
>>>>>> Tested-by: Thomas Weber <thomas@tomweber.eu>
>>>>>
>>>>> Gentle Ping. As there are no review comments on this patch,
>>>>> Could you please pull this patch ?
>>>
>>> Gentle Ping.
>>>
>>> This patch also got Reviewed-by: Manish Badarkhe <badarkhe.manish@gmail.com>
>>> and as patch "ARM: dts: omap3-devkit8000: Enable audio support"  has already got
>>> "Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>" but it is on the
>>> top of this patch.
>>> So, Could you please pull this patch in one of your omap branch? or
>>> you want me to
>>> do rebase this patch on top of v3.9-rc1 ?
>>
>> Let's wait for Benoit to queue it as he has a bunch of .dts changes already
>> applied. Too bad we missed v3.9 merge window for those, but hopefully
>> we can get them queued early for v3.10.
>
> Yep, sorry for having missed 3.9, I was a little bit sick at the wrong
> moment :-(
>
> I'm starting queuing the pending patches, and should have enough to push
> to you just after Linaro Connect.

I think you missed below patch which is needed for gpmc nand to work fine.

Jon Hunter:-
  ARM: OMAP2+: Fix-up gpmc merge error

I have re based my changes on top of your repository to make pull
easier for you.
I hope you will pull these changes for 3.10.

The following changes since Commit a7f7881de9c0b58de3b3aea8f01a8aef906d4ade

are available in the git repository at:

git://gitorious.org/devkit8000-for_3-10/devkit8000-for_3-10.git
branch for_3.10/dts

for you to fetch changes up to Commit 975abc8b2e7ec4ff7324d726c9775958945ccc5e

Anil Kumar:
ARM: dts: add minimal DT support for DevKit8000
ARM: dts: omap3-devkit8000: Enable audio support
ARM: dts: omap3-devkit8000: add nand dt node

Thanks,
Anil
