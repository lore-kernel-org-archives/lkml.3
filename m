Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab3CGGv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 01:51:57 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36338 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab3CGGv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 01:51:56 -0500
Message-ID: <513838F2.60101@ti.com>
Date: Thu, 7 Mar 2013 07:51:30 +0100
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Anil Kumar <anilk4.v@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, Grant Likely <grant.likely@secretlab.ca>,
        Thomas Weber <thomas@tomweber.eu>
Subject: Re: [PATCH V4] ARM: dts: add minimal DT support for DevKit8000.
References: <F3DBB1B3EF102E4994C89758CFCA32412CC4E9@DBDE01.ent.ti.com> <CABYxbz5GyxYaHANgdpwBNaaR6tnu=6LJuUNSvL7DEzU=4CPHcA@mail.gmail.com> <F3DBB1B3EF102E4994C89758CFCA32412CC74F@DBDE01.ent.ti.com> <CABYxbz62JrMB95p5i9iu2G=B4ETXLrYbLsyFEFR5F+WVD6YNnQ@mail.gmail.com> <20130306175313.GQ11806@atomide.com>
In-Reply-To: <20130306175313.GQ11806@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/06/2013 06:53 PM, Tony Lindgren wrote:
> * Anil Kumar <anilk4.v@gmail.com> [130305 18:40]:
>> Hi Tony,
>>
>>>> From: linux-arm-kernel [mailto:linux-arm-kernel-
>>>> bounces@lists.infradead.org] On Behalf Of Anil Kumar
>>>> Sent: Wednesday, February 27, 2013 8:03 AM
>>>> To: devicetree-discuss@lists.ozlabs.org; linux-omap@vger.kernel.org;
>>>> linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
>>>> Cc: linux@arm.linux.org.uk; Cousson, Benoit; Tony Lindgren; Grant
>>>> Likely; Anil Kumar; thomas@tomweber.eu
>>>> Subject: Re: FW: [PATCH V4] ARM: dts: add minimal DT support for
>>>> DevKit8000.
>>>>
>>>> Hi,
>>>>>
>>>>> DevKit8000 is a beagle board clone from Timll, sold by
>>>>> armkits.com. The DevKit8000 has RS232 serial port, LCD, DVI-D,
>>>>> S-Video, Ethernet, SD/MMC, keyboard, camera, SPI, I2C, USB and
>>>>> JTAG interface.
>>>>>
>>>>> This patch adds the basic DT support for devkit8000. At this time,
>>>> Information
>>>>> of twl4030 (PMIC), MMC1, I2C1 and leds are added.
>>>>>
>>>>> Signed-off-by: Anil Kumar <anilk4.v@gmail.com>
>>>>> Tested-by: Thomas Weber <thomas@tomweber.eu>
>>>>
>>>> Gentle Ping. As there are no review comments on this patch,
>>>> Could you please pull this patch ?
>>
>> Gentle Ping.
>>
>> This patch also got Reviewed-by: Manish Badarkhe <badarkhe.manish@gmail.com>
>> and as patch "ARM: dts: omap3-devkit8000: Enable audio support"  has already got
>> "Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>" but it is on the
>> top of this patch.
>> So, Could you please pull this patch in one of your omap branch? or
>> you want me to
>> do rebase this patch on top of v3.9-rc1 ?
> 
> Let's wait for Benoit to queue it as he has a bunch of .dts changes already
> applied. Too bad we missed v3.9 merge window for those, but hopefully
> we can get them queued early for v3.10.

Yep, sorry for having missed 3.9, I was a little bit sick at the wrong
moment :-(

I'm starting queuing the pending patches, and should have enough to push
to you just after Linaro Connect.

Regards,
Benoit

