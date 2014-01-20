Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaATNqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 08:46:04 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:37605 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaATNp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 08:45:59 -0500
MIME-Version: 1.0
In-Reply-To: <CAFp+6iGYapTX0tfTLaoiF02n+hNdXN2OEphOCkb3dAYvqA4N5g@mail.gmail.com>
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
	<CAFp+6iGYapTX0tfTLaoiF02n+hNdXN2OEphOCkb3dAYvqA4N5g@mail.gmail.com>
Date: Mon, 20 Jan 2014 19:15:57 +0530
Message-ID: <CAFp+6iGAKjxQEa8BK3NmbQemQ-=Vnrm=+TbKA3w5d0eRVKYFYQ@mail.gmail.com>
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

Hi Kishon,


[...]

>>>>>>>>>>>> Right.
>>>>>>>>>>>>
>>>>>>>>>>>> While 3.0 block(PIPE3) can be used for Super Speed, 2.0
>>>>>>>>>>>> block(UTMI+)
>>>>>>>>>>>> can be used for High speed.
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> It should then come under *single IP muliple PHY* category similar
>>>>>>>>>>> to what
>>>>>>>>>>> Sylwester has done.

[...]

>>
>> The idea is to model the driver as close to the hardware though I understand
>> there won't be any advantages w.r.t power or performance. maybe in later
>> versions of the IP we'll have separate bits to control usb3 and usb2.
>
> Ok, i will prepare the next patchset for separating out the possible
> code based on
> the UTMI+ or PIPE3 phys. Though when experimenting with the PHY
> settings i can see
> there's little of such code  :-)
>
>>
>> I think for power control we should have both usb3 and usb2 power-on callback
>> calling a single function that controls the power bit.
> Right. I will do that.

Have posted the next version of patch with functionality to support
multiple PHYs as suggested.
Please review the same.
Thanks !!


-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
