Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab3KEJhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 04:37:08 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60698 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132Ab3KEJhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 04:37:03 -0500
X-AuditID: cbfec7f4-b7f0a6d000007b1b-74-5278bc3dd55e
From: Kamil Debski <k.debski@samsung.com>
To: "'Vivek Gautam'" <gautamvivek1987@gmail.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Linux USB Mailing List'" <linux-usb@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, "'Greg KH'" <gregkh@linuxfoundation.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, "'Felipe Balbi'" <balbi@ti.com>,
        "'Julius Werner'" <jwerner@chromium.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1383205544-32244-1-git-send-email-gautam.vivek@samsung.com>
 <1383205544-32244-2-git-send-email-gautam.vivek@samsung.com>
 <527744B2.4090303@ti.com> <030d01ced946$d6e23490$84a69db0$%debski@samsung.com>
 <52779D28.9000905@ti.com>
 <CAFp+6iH7vQ-OtMFL4pyr4tFDRchH4oh1Z0753WNgrHiUzj+kzw@mail.gmail.com>
In-reply-to: <CAFp+6iH7vQ-OtMFL4pyr4tFDRchH4oh1Z0753WNgrHiUzj+kzw@mail.gmail.com>
Subject: RE: [PATCH RFC 1/4] phy: Add new Exynos5 USB 3.0 PHY driver
Date: Tue, 05 Nov 2013 10:36:59 +0100
Message-id: <00fe01ceda0a$941957a0$bc4c06e0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7Z94C3HLaVZLM8ToO0AWrZx8HMmwACIfqg
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t/xK7q2eyqCDBYuYLU4eL/eYv6Rc6wW
	bVcOslu8/b6F3aJ58Xo2i8sLL7FadBx6zGTRu+Aqm8WFpz1sFpseX2O1WNi2hMXi8q45bBYz
	zu9jsli0rJXZ4vCbdlaL9TNeszgIeMxuuMjisXPWXXaP/XPXsHtsXlLv0bdlFaPH8RvbmTw+
	b5ILYI/isklJzcksSy3St0vgytj85RBbwRfhioutX9gaGI/xdzFyckgImEisOv2dFcIWk7hw
	bz1bFyMXh5DAUkaJuz1/2EESQgINTBLzrth1MXJwsAloSqy65wESFhGIklh+oo8RpJ5ZYCaL
	xKNVu5ggmnczSTzafhFsKqdAsMSfhgNMILawgIvE7YaLYDaLgKrExMYFYDW8Ag4SE2bcZoew
	BSV+TL7HAmIzC2hJbN7WxAphy0tsXvOWGeQICQF1iUd/dSGOMJJo/vKMEaJEROJuw3PWCYxC
	s5BMmoVk0iwkk2YhaVnAyLKKUTS1NLmgOCk911CvODG3uDQvXS85P3cTIyQuv+xgXHzM6hCj
	AAejEg/vg7PlQUKsiWXFlbmHGCU4mJVEeDl2VwQJ8aYkVlalFuXHF5XmpBYfYmTi4JRqYFyx
	4/gcw2w+lwf2oemZym/z+M3FNrx+x+Te+Y3xOed6mfJdaSamR1SmvnCc1mHx58bXIO5Op62r
	2OpZah/P6T8YvyepM3gG/0nlmnU9x6o9yk6stw/+lqPvsDPhsKKDJJf81rnNfSHSNeItHMc/
	J4Q9YV/57nIBg22pTOXeG9Ns5xwQNf0lo8RSnJFoqMVcVJwIAG18iI6pAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> From: Vivek Gautam [mailto:gautamvivek1987@gmail.com]
> Sent: Tuesday, November 05, 2013 8:20 AM
> To: Kishon Vijay Abraham I
> Cc: Kamil Debski; Vivek Gautam; Linux USB Mailing List; linux-samsung-
> soc@vger.kernel.org; linux-kernel@vger.kernel.org;
> devicetree@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> linux-doc@vger.kernel.org; Greg KH; Kukjin Kim; Sylwester Nawrocki;
> Tomasz Figa; Felipe Balbi; Julius Werner; Jingoo Han
> Subject: Re: [PATCH RFC 1/4] phy: Add new Exynos5 USB 3.0 PHY driver
> 
> Hi Kishon,
> 
> 
> 
> On Mon, Nov 4, 2013 at 6:42 PM, Kishon Vijay Abraham I <kishon@ti.com>
> wrote:
> > Hi,
> >
> >
> > On Monday 04 November 2013 03:45 PM, Kamil Debski wrote:
> >>
> >> Hi Kishon,
> >>
> >>> From: Kishon Vijay Abraham I [mailto:kishon@ti.com]
> >>> Sent: Monday, November 04, 2013 7:55 AM
> >>>
> >>> Hi Vivek,
> >>>
> >>> On Thursday 31 October 2013 01:15 PM, Vivek Gautam wrote:
> >>>>
> >>>> Add a new driver for the USB 3.0 PHY on Exynos5 series of SoCs.
> >>>> The new driver uses the generic PHY framework and will interact
> >>>> with
> >>>> DWC3 controller present on Exynos5 series of SoCs.
> >>>
> >>>
> >>> In Exynos, you have a single IP that supports both USB3 and USB2
> PHY
> >>> right? I think that needs to be mentioned here.
> >>
> >>
> >> As far as I know the IP is different.
> >
> >
> > Ok. Sometime back Vivek was mentioning about a single IP for both
> USB3
> > and USB2. Thought it should be this driver. Anyway thanks for the
> clarification.
> 
> Right Kishon, I had mentioned that Exynos5's dwc3 controller have a
> single IP for USB2 and USB3 phy.
> From what i see, on exynos5 systems the dwc3 controller uses a combo of
> usb 2 (utmi+) and usb 3 (pipe 3) phy (with base address starting
> 0x12100000).
> 
> Kamil, Tomasz,
> 
> Please correct me if i am wrong.

I have the Exynos 5250 documentation and I found two phy register ranges:
1) USB 2.0 PHY having the base address of 0x1213 0000
	Chapter 33. USB 2.0 Host Controller
	Subchapter 33.5.2 Phy Control Register p. 1696
	First register's description is
	"USB2.0 phy control register"
2) USB 3.0 PHY (I guess) with the base address 0x1210 0000
	Chapter 35. USB 3.0 DRD Controller
	Subchapter 35.4.6 PHY Control Register p. 1872

Jingoo, could you comment on the above? You may know more than we do :)

In addition, I have a question to you Vivek - does your USB 3.0
PHY support both host and device?

[snip]

Best wishes,
Kamil Debski

