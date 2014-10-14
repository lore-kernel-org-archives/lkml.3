Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbaJNExk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 00:53:40 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:55793 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaJNExh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 00:53:37 -0400
MIME-Version: 1.0
In-Reply-To: <001801cfe74d$e4cb23d0$ae616b70$%tikhomirov@samsung.com>
References: <1412677176-3850-1-git-send-email-gautam.vivek@samsung.com>
	<1412677176-3850-2-git-send-email-gautam.vivek@samsung.com>
	<00f101cfe6a1$d772c5a0$865850e0$%tikhomirov@samsung.com>
	<543C575A.1030105@gmail.com>
	<001801cfe74d$e4cb23d0$ae616b70$%tikhomirov@samsung.com>
Date: Tue, 14 Oct 2014 10:23:36 +0530
X-Google-Sender-Auth: bV6N44aAo8shHIpVIeYXFlx-gM4
Message-ID: <CAFp+6iFs=UCE2xixCxpTkmiinO1hcZAw0Zy3uQ4G19LjenU7Vg@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] dwc3: exynos: Add support for SCLK present on Exynos7
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Anton Tikhomirov <av.tikhomirov@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        "robh+dt" <robh+dt@kernel.org>, kishon <kishon@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,


On Tue, Oct 14, 2014 at 6:56 AM, Anton Tikhomirov
<av.tikhomirov@samsung.com> wrote:
> Hello,
>
>> Hi Anton,
>>
>> On 13.10.2014 06:54, Anton Tikhomirov wrote:
>> > Hi Vivek,
>> >
>> >> Exynos7 also has a separate special gate clock going to the IP
>> >> apart from the usual AHB clock. So add support for the same.
>> >
>> > As we discussed before, Exynos7 SoCs have 7 clocks to be controlled
>> > by the driver. Adding only sclk is not enough.
>> >
>>
>> I'm quite interested in this discussion. Has it happened on mailing
>> lists?
>
> No, we used company messenger for the discussion.

Yea, we head a round of discussion at our end regarding this, and we are
going to get more clarity on this from our H/W team too, this week.

>
>>
>> In general, previous SoCs also gave the possibility of controlling all
>> the bus clocks separately, in addition to bulk gates, but there was no
>
> correct
>
>> real advantage in using those, while burdening the clock tree with
>> numerous clocks. Isn't Exynos7 similar in this aspect?
>
> Exynos7 doesn't have "Gating all clocks for USBDRD30" bit. The clocks
> should be controlled separately.

true, on Exynos7 we have separate gates for the available clocks going to
USB-DRD block. So we will have to add these basic required number of
clocks.





-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
