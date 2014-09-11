Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaIKDSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 23:18:11 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:56981 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaIKDSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 23:18:08 -0400
X-AuditID: cbfee68d-f79c46d000000b84-25-5411146cb81d
Message-id: <7AFBEAB40137492BBF4D80EBC3E6EBB3@sisodomain.com>
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Julius Werner <jwerner@google.com>, Felipe Balbi <balbi@ti.com>
Cc: Julius Werner <jwerner@chromium.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Greg KH <gregkh@linuxfoundation.org>, kishon <kishon@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jingoo Han <jg1.han@samsung.com>, abrestic@chromium.org
References: <CAFp+6iEyqmbwMLFrBKD7NVLDAC=b+h1hPKFS=BG4k9D69hn_dg@mail.gmail.com>
 <20140903144225.GD31855@saruman.home>
 <CAFp+6iETPJCWMMkjHrpDcdCv=K0PbefYLa4eBOwN=aUY2=EHLA@mail.gmail.com>
 <20140905175651.GK24449@saruman.home>
 <CAFp+6iGU86yL8Ry3ArJJjBy2Cs0Em2B49yssH3BK5fJwyaZbtA@mail.gmail.com>
 <20140908134454.GK22409@saruman.home>
 <CAFp+6iG+gmD_JseytYuVQcRK9ErOqQrUEWJoU1KUU7PqMd=aRw@mail.gmail.com>
 <20140909144225.GF6151@saruman.home>
 <CAFp+6iHJKmeothDM67WW60Sqqj8BQroBCzZ8zecKwM_GcYL8HA@mail.gmail.com>
 <CAFp+6iHRJ5oAA+K1Y0Y2uadPhsR6wmrd13DM39dqiL4jj+swHg@mail.gmail.com>
 <20140910045328.GA32475@saruman.home>
 <CAFp+6iHMhbi4V4LAkNsgzDc192ihT2a1mZHgLbia=K2U8+x=2w@mail.gmail.com>
 <CAFp+6iErXKpXgE0tRPB=tEqXxcXgQAeFJP1TpSwRN6fNu9a-qw@mail.gmail.com>
 <CAODwPW9QOD-7Wyc1Bh8QKfArSmsdqzYTOx6-gc8V5ace9-oPFQ@mail.gmail.com>
In-reply-to: <CAODwPW9QOD-7Wyc1Bh8QKfArSmsdqzYTOx6-gc8V5ace9-oPFQ@mail.gmail.com>
Subject: Re: [PATCH v6 4/4] phy: exynos5-usbdrd: Calibrate LOS levels for
 exynos5420/5800
Date: Thu, 11 Sep 2014 08:50:30 +0530
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=UTF-8; reply-type=original
Content-transfer-encoding: 7bit
X-Priority: 3
X-MSMail-priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MIMEOLE: Produced By Microsoft MimeOLE V14.0.8117.416
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsWyRsSkVjdHRDDEYMImJYuV7/8yWhy8X2/R
	vHg9m0XX6p0sFpcXXmK16Dj0mMli/+7l7Ba9C66yWVx42sNmsenxNVaLy7vmsFnMOL+PyWLR
	slZmi+ZNU1gtzqy6xW4x4fcFNgcBj9kNF1k8Hkz9z+SxYFOpx+I9L5k85p0M9Ng/dw27x+Yl
	9R6z7/5g9OjbsorR4/iN7UwenzfJBXBHcdmkpOZklqUW6dslcGVsfr+BueCqSMXi/k7GBsYL
	Al2MnBwSAiYSK2f/YoewxSQu3FvP1sXIxSEksJRRYv6OZiaYooddL9ghEtMZJdafP80M4Xxn
	lJiz5TkrSBWvgK3EocNnGEFsNgFdiaa3u8BsEQFnieMrZ4DVMAusYpF41x4N0XyRTWLOs/dg
	KzgFgiU+X/kNdoewQLRE88+fLCA2i4CqxOUrX6EWCEr8mHyPBWKQt8Ta41/ZIGx5ic1r3jJD
	nMorMaP9KQuELSmxuucWO8R8IYmOq52sEHFjiSn/lkLVm0tc3L4Z6s0HHBJvG/Ug9gpIfJt8
	CGgOB1BcVmLTAWaYkQdX3GCZwCg1C8lFs5BcNAvJRQsYmVcxiqYWJBcUJ6UXGeoVJ+YWl+al
	6yXn525iBKaZ0/+e9e5gvH3A+hCjAAejEg9vBYtgiBBrYllxZe4hRlOgKyYyS4km5wOTWV5J
	vKGxmZGFqYmpsZG5pZmSOK+i1M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxrPOdY7a7e
	7BtZ5nif+YbMwp+sCre+axaKyayLdE66cl9ChjGcsaywb0OsxDsTnaclicf5XSTWV/U1nH/H
	90RNeL2zN8/njP55UlNqqtqX9097e//vt9Bspq2nxVb/2dLg5dC0ccXOBWXP02y5OIzUdPzn
	ahx6qXkqSnB5QsqUj2yHNmbuElZiKc5INNRiLipOBACuuefULgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGKsWRmVeSWpSXmKPExsVy+t9jQd0cEcEQg2dPxS1Wvv/LaHHwfr1F
	8+L1bBZdq3eyWFxeeInVouPQYyaL/buXs1v0LrjKZnHhaQ+bxabH11gtLu+aw2Yx4/w+JotF
	y1qZLZo3TWG1OLPqFrvFhN8X2BwEPGY3XGTxeDD1P5PHgk2lHov3vGTymHcy0GP/3DXsHpuX
	1HvMvvuD0aNvyypGj+M3tjN5fN4kF8Ad1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCo
	a2hpYa6kkJeYm2qr5OIToOuWmQP0jpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4j
	AzSQsIYxY/P7DcwFV0UqFvd3MjYwXhDoYuTkkBAwkXjY9YIdwhaTuHBvPVsXIxeHkMB0Ron1
	508zQzjfGSXmbHnOClLFK2ArcejwGUYQm01AV6Lp7S4wW0TAWeL4yhlgNcwCq1gk3rVHQzRf
	ZJOY8+w9E0iCUyBY4vOV32DrhAWiJZp//mQBsVkEVCUuX/kKtUBQ4sfkeywQg7wl1h7/ygZh
	y0tsXvOWGeJUXokZ7U9ZIGxJidU9t9gh5gtJdFztZIWIG0tM+bcUqt5c4uL2zUwTGEVmIVkx
	C8mKWUhWLGBkXsUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnMaeSe9gXNVgcYhRgINRiYe3
	kkUwRIg1say4MvcQowQHs5IIb8IDgRAh3pTEyqrUovz4otKc1OJDjKZAn05klhJNzgem2LyS
	eENjE3NTY1NLEwsTM0slcd6DrdaBQgLpiSWp2ampBalFMH1MHJxSDYwp2s1JKzLfzuZx3h8m
	3zah6IrjXkfOwsofv117lIxXHd3bJKMrUc765MfWudfu+tWnWchve6YcuGn3HgN+Ad0XxzZy
	3tm6SPxgHrfhtijN50nZf296rxQVU7mjwc3woW/eq5md+pPfmVw+VCjlufVix8oMtQkqB881
	9qfr/Oj+d/De7L2rlm9XYinOSDTUYi4qTgQAn4l2AnkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,


On Thursday, September 11, 2014 1:52 AM, "Julius Werner" 
<jwerner@google.com> wrote


>>> right, use that to call phy_init() at the right time, then you need to
>>> add a new ->calibrate() method which, likely, will only be used by you
>>> ;-)
>
>> so you mean, the xhci should itself call phy_init() at a time suitable,
>> so that ->calibrate() is not required at all ?
>
> I'm not sure if that's a good idea because it would require phy_init()
> and calibrate() to always mean the same thing. The calibrate() for
> Exynos5420 needs to be called both during boot and after system
> resume, but there might be other platforms that don't want to
> completely shutdown and reinit their PHYs during suspend/resume with
> the same functions used for boot. For example, Tegra5 (proposed driver
> at http://www.spinics.net/lists/linux-usb/msg113093.html) can
> power-gate the PHY during suspend, but that's not running the same
> code as in the phy_init()/phy_shutdown() methods (the posted patch
> doesn't contain all power-gating code yet, but you can get an idea
> about how it has to work from
> https://chromium.googlesource.com/chromiumos/third_party/kernel-next/+/chromeos-3.10/drivers/usb/host/xhci-tegra.c).
> It would also mean that the initial phy_init() call must always come
> after the XHCI reset, and I am not sure if that would fit nicely with
> all platforms.
>
>> right, and what's more generic than adding the support for PHYs straight 
>> into xHCI ?
>
> Well, if we are going to have a calibrate() method (as in "stuff the
> PHY does after every controller reset if it needs to"), we have to add
> it either to the XHCI stack or the USB core.
> I thought the USB core would be more generic, because in theory it's 
> possible that e.g. an
> EHCI controller might have a similar requirement.

Atleast on Exynos systems I can see that unless PHY is initialized the 
controller
fails to reset. So taking a path wherein we initialize the PHYs after 
controller resets
is not going to help us generically across all controllers.
With XHCI though things are OK while resetting, and we can initialize the 
PHYs
after controller reset happens but here too DWC3 is already initializing the 
PHYs
for exynos systems too, so it may not be very wise to do that initialization 
stuff
once again. Plus the PHY core prevents multiple initialization anyways.

> (Also, we have the gen_phy pointer in a USB core structure (struct 
> usb_hcd), so I thought
> making this feature generic to the USB core and thus available to all
> kinds of host controllers would be more natural.) 

