Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbaJNEzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 00:55:06 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:54886 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaJNEzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 00:55:03 -0400
MIME-Version: 1.0
In-Reply-To: <20141013224409.GB1496@saruman>
References: <1412677176-3850-1-git-send-email-gautam.vivek@samsung.com>
	<1412677176-3850-2-git-send-email-gautam.vivek@samsung.com>
	<00f101cfe6a1$d772c5a0$865850e0$%tikhomirov@samsung.com>
	<20141013224409.GB1496@saruman>
Date: Tue, 14 Oct 2014 10:25:00 +0530
X-Google-Sender-Auth: 3Ce_qYjPVqdoq16LGpLcgR2beFg
Message-ID: <CAFp+6iEKkHxJNzkf+LOWJHtOhtZMe7HG_Vg97_NLfhJw11SQpA@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] dwc3: exynos: Add support for SCLK present on Exynos7
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Anton Tikhomirov <av.tikhomirov@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        "robh+dt" <robh+dt@kernel.org>, kishon <kishon@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,


On Tue, Oct 14, 2014 at 4:14 AM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Mon, Oct 13, 2014 at 01:54:59PM +0900, Anton Tikhomirov wrote:
>> Hi Vivek,
>>
>> > Exynos7 also has a separate special gate clock going to the IP
>> > apart from the usual AHB clock. So add support for the same.
>>
>> As we discussed before, Exynos7 SoCs have 7 clocks to be controlled
>> by the driver. Adding only sclk is not enough.
>>
>> >
>> > Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> > ---
>> >  drivers/usb/dwc3/dwc3-exynos.c |   16 ++++++++++++++++
>> >  1 file changed, 16 insertions(+)
>> >
>> > diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-
>> > exynos.c
>> > index 3951a65..7dc6a98 100644
>> > --- a/drivers/usb/dwc3/dwc3-exynos.c
>> > +++ b/drivers/usb/dwc3/dwc3-exynos.c
>> > @@ -35,6 +35,7 @@ struct dwc3_exynos {
>> >     struct device           *dev;
>> >
>> >     struct clk              *clk;
>>
>> The clock "clk" in Exynos5 just gated all that above 7 clocks, which
>> we should control separately now in Exynos7.
>>
>
> should I drop this patch for now ?

Yes, better to hold this for some time till we get more clarity
from our h/w team.


-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
