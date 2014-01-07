Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbaAGLDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 06:03:12 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:64352 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaAGLDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 06:03:08 -0500
MIME-Version: 1.0
In-Reply-To: <52CBCDB2.9080301@ti.com>
References: <1383205544-32244-1-git-send-email-gautam.vivek@samsung.com>
	<1383205544-32244-2-git-send-email-gautam.vivek@samsung.com>
	<527744B2.4090303@ti.com>
	<030d01ced946$d6e23490$84a69db0$%debski@samsung.com>
	<52779D28.9000905@ti.com>
	<CAFp+6iH7vQ-OtMFL4pyr4tFDRchH4oh1Z0753WNgrHiUzj+kzw@mail.gmail.com>
	<00fe01ceda0a$941957a0$bc4c06e0$%debski@samsung.com>
	<000001ceda17$f41c2030$dc546090$%han@samsung.com>
	<000101ceda1f$04ca6f20$0e5f4d60$%han@samsung.com>
	<CAFp+6iFAZab35F-MOOZHcHpzSEOL=51gWBK2KZbOJS+0731GJQ@mail.gmail.com>
	<000301ceda84$1d648bf0$582da3d0$%han@samsung.com>
	<5280BB65.5040305@ti.com>
	<CAFp+6iGKpzOHjwnSMvSgTehzPLQMB8madoYqMk5JPSAZfSGSTg@mail.gmail.com>
	<528C7B0E.3080401@ti.com>
	<CAFp+6iF3UnV-w2pYQE2THQZBGma8xpp6pqSuwXzjUN3emJnftQ@mail.gmail.com>
	<528CD8EC.9050403@ti.com>
	<529F3C1C.2050509@ti.com>
	<CAFp+6iF+N+eMOd=B-J3oS_u0TEse+5V2gHkcNxN0OS+YbV_Y9g@mail.gmail.com>
	<52B9C83E.6070502@ti.com>
	<CAFp+6iGkNjCDHJSPd76V7SzOkma1q7CiOKg7oK7ws77Rh022Jg@mail.gmail.com>
	<52CBCDB2.9080301@ti.com>
Date: Tue, 7 Jan 2014 16:33:04 +0530
Message-ID: <CAFp+6iGYapTX0tfTLaoiF02n+hNdXN2OEphOCkb3dAYvqA4N5g@mail.gmail.com>
Subject: Re: [PATCH RFC 1/4] phy: Add new Exynos5 USB 3.0 PHY driver
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Jingoo Han <jg1.han@samsung.com>, Kamil Debski <k.debski@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-doc@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Julius Werner <jwerner@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Kishon


On Tue, Jan 7, 2014 at 3:19 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> Hi,
>
> On Monday 30 December 2013 03:13 PM, Vivek Gautam wrote:
>> Hi Kishon,
>>
>>
>> On Tue, Dec 24, 2013 at 11:15 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>>> Hi,
>>>
>>>
>>> On Thursday 05 December 2013 01:44 PM, Vivek Gautam wrote:
>>>>
>>>> Hi Kishon,
>>>>
>>>>
>>>> On Wed, Dec 4, 2013 at 7:58 PM, Kishon Vijay Abraham I <kishon@ti.com>
>>>> wrote:
>>>>>
>>>>> Hi Vivek,
>>>>>
>>>>> On Wednesday 20 November 2013 09:14 PM, Kishon Vijay Abraham I wrote:
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> On Wednesday 20 November 2013 03:02 PM, Vivek Gautam wrote:
>>>>>>>
>>>>>>> On Wed, Nov 20, 2013 at 2:34 PM, Kishon Vijay Abraham I <kishon@ti.com>
>>>>>>> wrote:
>>>>>>>>
>>>>>>>> On Wednesday 20 November 2013 02:27 PM, Vivek Gautam wrote:
>>>>>>>>>
>>>>>>>>> Hi Kishon,
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> On Mon, Nov 11, 2013 at 4:41 PM, Kishon Vijay Abraham I
>>>>>>>>> <kishon@ti.com> wrote:
>>>>>>>>>>
>>>>>>>>>> Hi,
>>>>>>>>>
>>>>>>>>> sorry for the delayed response.
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> On Wednesday 06 November 2013 05:37 AM, Jingoo Han wrote:
>>>>>>>>>>>
>>>>>>>>>>> On Wednesday, November 06, 2013 2:58 AM, Vivek Gautam wrote:
>>>>>>>>>>>>
>>>>>>>>>>>> On Tue, Nov 5, 2013 at 5:33 PM, Jingoo Han <jg1.han@samsung.com>
>>>>>>>>>>>> wrote:
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> [.....]
>>>>>>>>>>>
>>>>>>>>>>>>> USB3.0 PHY consists of two blocks such as 3.0 block and 2.0
>>>>>>>>>>>>> block.
>>>>>>>>>>>>> This USB3.0 PHY can support UTMI+ and PIPE3 interface for 3.0
>>>>>>>>>>>>> block
>>>>>>>>>>>>> and 2.0 block, respectively.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Conclusion:
>>>>>>>>>>>>>
>>>>>>>>>>>>>     1) USB2.0 PHY: USB2.0 HOST, USB2.0 Device
>>>>>>>>>>>>>                         Base address: 0x1213 0000
>>>>>>>>>>>>>
>>>>>>>>>>>>>     2) USB3.0 PHY: USB3.0 DRD (3.0 HOST & 3.0 Device)
>>>>>>>>>>>>>                         Base address: 0x1210 0000
>>>>>>>>>>>>>                         2.0 block(UTMI+) & 3.0 block(PIPE3)
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> And this is of course the PHY used by DWC3 controller, which works
>>>>>>>>>>>> at
>>>>>>>>>>>> both High speed as well as Super Speed.
>>>>>>>>>>>> Right ?
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> Right.
>>>>>>>>>>>
>>>>>>>>>>> While 3.0 block(PIPE3) can be used for Super Speed, 2.0
>>>>>>>>>>> block(UTMI+)
>>>>>>>>>>> can be used for High speed.
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> It should then come under *single IP muliple PHY* category similar
>>>>>>>>>> to what
>>>>>>>>>> Sylwester has done.
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Do you mean that i should be including PHY IDs for UTMI+ phy and
>>>>>>>>> PIPE3
>>>>>>>>> phy present in this PHY block ?
>>>>>>>>> AFAICS the two phys (UTMI+ and PIPE3) do not really have separate
>>>>>>>>> registers to program, and that's the reason
>>>>>>>>> we program the entire PHY in a shot.
>>>>>>>>
>>>>>>>>
>>>>>>>> you mean you program the same set of bits for UTMI+ and PIPE3?
>>>>>>>
>>>>>>>
>>>>>>> No, looking closely into PHY datasheet as well as Exynos5250 manual, i
>>>>>>> can see that UTMI+ and PIPE3
>>>>>>> phys have separate bit settings. So i think we should be able to
>>>>>>> segregate the two PHYs (UTMI+ and PIPE3).
>>>>>>> Pardon me for my earlier observations.
>>>>>>
>>>>>>
>>>>>> no problem..
>>>>>>>
>>>>>>> Let me clarify more with our h/w team also on this and then i will
>>>>>>> confirm with this.
>>>>>
>>>>>
>>>>> Did you get more information on this?
>>>>
>>>>
>>>> Yes, i have been in contact with our hardware team.
>>>> The functionality of setting up UTMI+ and PIPE3 phys separately, and
>>>> thereby using only one functionality of the two
>>>> at some point of time (either high speed or super speed) hasn't been
>>>> tested so far.
>>>
>>>
>>> Irrespective of whether we are able to test the functionality separately or
>>> not, we should model it as multiple PHYs since you have separate bit
>>> settings for UTMI+ and PIPE3.
>>>
>>> (I'll review your next patch version shortly).
>>
>> Thanks Kishon, i know i am disturbing you in the holiday season. :-)
>> But there's one concern, on Exynos5 platforms we have only one bit to
>> power control
>> the entire PHY (irrespective of the two PHYs present in the USB 3.0
>> PHY controller).
>> So anyways we won't be able to save anything on the power front even
>> if we program only
>> one PHY (UTMI/PIPE3).
>> Although there are PHY settings register bits which seem separate for
>> the two phys.  r
>> What do you suggest in that case ?
>
> The idea is to model the driver as close to the hardware though I understand
> there won't be any advantages w.r.t power or performance. maybe in later
> versions of the IP we'll have separate bits to control usb3 and usb2.

Ok, i will prepare the next patchset for separating out the possible
code based on
the UTMI+ or PIPE3 phys. Though when experimenting with the PHY
settings i can see
there's little of such code  :-)

>
> I think for power control we should have both usb3 and usb2 power-on callback
> calling a single function that controls the power bit.
Right. I will do that.

-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
