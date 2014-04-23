Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbaDWMby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:31:54 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48543 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781AbaDWMbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:31:50 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-c8-5357b2b3b5fa
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>
Cc: "'Anton Tikhomirov'" <av.tikhomirov@samsung.com>,
        "'Linux USB Mailing List'" <linux-usb@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "'Greg KH'" <gregkh@linuxfoundation.org>,
        "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1398082604-3013-1-git-send-email-gautam.vivek@samsung.com>
 <1398082604-3013-3-git-send-email-gautam.vivek@samsung.com>
 <00bf01cf5ed6$28de18d0$7a9a4a70$%tikhomirov@samsung.com>
 <CAFp+6iE2eWJPMmxSF9gbfwMmeO7k0bo=geo5SKmdgBRjiFq7mA@mail.gmail.com>
 <00d201cf5ee2$d55c4e90$8014ebb0$%tikhomirov@samsung.com>
 <CAFp+6iGBz-0LjkUU8A4var5frEqaumF85scZfHPEVwk62mTe8g@mail.gmail.com>
In-reply-to: <CAFp+6iGBz-0LjkUU8A4var5frEqaumF85scZfHPEVwk62mTe8g@mail.gmail.com>
Subject: Re: [PATCH 3/3] usb: dwc3-exynos: Make provision for vdd regulators
Date: Wed, 23 Apr 2014 21:31:47 +0900
Message-id: <000901cf5eef$fe79e5f0$fb6db1d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9e5dkb3YBqQHxNSDeCXspB2ivhfAACUszQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t8zQ93Nm8KDDfommFss2X2D1eLg/XqL
	tisH2S2aF69ns7i88BKrRe+Cq2wWmx5fY7W4vGsOm8XsJf0sFjPO72OyWLSsldliwu8LbA48
	HvvnrmH32Lyk3mP23R+MHn1bVjF6HL+xncnj8ya5ALYoLpuU1JzMstQifbsEroy7q0+yF3yV
	qfh+dQd7A+MUsS5GDg4JAROJS1eMuxg5gUwxiQv31rN1MXJxCAksY5T4u+Q9O0TCRGLemR/M
	EInpjBJHn7yBqvrNKNE65ycrSBWbgJrEly+HwTpEBHQleiZ+ZAEpYhbYxCzx6clddoiOTmaJ
	p/tOsoFUcQoES0xYMoEJ5A5hAR+JM91iIGEWAVWJj//XM4HYvAK2ErMuTWGDsAUlfky+xwJi
	MwuoS0yat4gZwpaX2LzmLTPEO+oSj/7qgpgiAkYS2/d7QVSISOx78Y4R5AIJgbkcEteWtjNC
	rBKQ+Db5EAtEq6zEpgPMEA9LShxccYNlAqPELCSLZyFZPAvJ4llIVixgZFnFKJpakFxQnJRe
	ZKpXnJhbXJqXrpecn7uJERL1E3cw3j9gfYgxGWj9RGYp0eR8YNLIK4k3NDYzsjA1MTU2Mrc0
	I01YSZw3/VFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGXQtkZopGRuTnMGuf8Asy5f7Y
	0GGwlb3zQF5dQkLSRomul9m2yQ7ntiq9vVvXsUBzte920y9ie2Y4sUzUvdTwpMnT5vQSZ5Nb
	+qrqGinvzqVIfv3PkaV+Z6aznNWZAqYFF2bFSYe73y+Ud3Vn/uM05+o0udjZFpax9+OfhS/f
	JSX/69C1sx+VWIozEg21mIuKEwGFiD2sEAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNKsWRmVeSWpSXmKPExsVy+t9jQd3Nm8KDDa5tMrRYsvsGq8XB+/UW
	bVcOsls0L17PZnF54SVWi94FV9ksNj2+xmpxedccNovZS/pZLGac38dksWhZK7PFhN8X2Bx4
	PPbPXcPusXlJvcfsuz8YPfq2rGL0OH5jO5PH501yAWxRDYw2GamJKalFCql5yfkpmXnptkre
	wfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA3KimUJeaUAoUCEouLlfTtME0IDXHTtYBp
	jND1DQmC6zEyQAMJ6xgz7q4+yV7wVabi+9Ud7A2MU8S6GDk5JARMJOad+cEMYYtJXLi3nq2L
	kYtDSGA6o8TRJ2+gnN+MEq1zfrKCVLEJqEl8+XKYHcQWEdCV6Jn4kQWkiFlgE7PEpyd32SE6
	Opklnu47yQZSxSkQLDFhyQSmLkYODmEBH4kz3WCrWQRUJT7+X88EYvMK2ErMujSFDcIWlPgx
	+R4LiM0soC4xad4iZghbXmLzmrfMIGMkgOKP/uqCmCICRhLb93tBVIhI7HvxjnECo9AsJINm
	IRk0C8mgWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQITirPpHYwrmywOMQowMGo
	xMNbsDIsWIg1say4MvcQowQHs5II75JF4cFCvCmJlVWpRfnxRaU5qcWHGJOB/pzILCWanA9M
	eHkl8YbGJmZGlkZmFkYm5uakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnVwFh384z3g/Te
	aJXlt9dV7p9md0Yqh3/9TCn7B3rfzk1/e9LpZ0feB43Dn4u1v1ecXtq5n+XtvT2msdkP9mdu
	8X5ScGYl08fL33auv6dUlbRJ7K7EJc3OLRdv347UNpT5JDE7yvbtW4FwO2VV9+KTG/ZO5v55
	4Nd+nXQV17De5uqQt5u3zU/4EMqvxFKckWioxVxUnAgAipT5em4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 23, 2014 8:06 PM, Vivek Gautam wrote:
> On Wednesday, April 23, 2014 7:58 PM, Anton Tikhomirov wrote:
> > On Wednesday, April 23, 2014 6:52 PM, Vivek Gautam wrote:
> >> On Wednesday, April 23, 2014 6:27 PM, Anton Tikhomirov wrote:
> >> > On Monday, April 21, 2014 9:17 PM, Vivek Gautam wrote:
> >> >>
> >> >> Facilitate getting required 3.3V and 1.0V VDD supply for
> >> >> DWC3 controller on Exynos.
> >> >>
> >> >> With patches for regulators' nodes merged in 3.15:
> >> >> c8c253f ARM: dts: Add regulator entries to smdk5420
> >> >> 275dcd2 ARM: dts: add max77686 pmic node for smdk5250,
> >> >>
> >> >> certain perripherals will now need to ensure that,
> >> >> they request VDD regulators in their drivers, and enable
> >> >> them so as to make them working.
> >> >>
> >> >> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> >> >> Cc: Anton Tikhomirov <av.tikhomirov@samsung.com>
> >> >> ---
> >> >>
> >> >> Based on 'usb-next' branch of Greg's USB tree.
> >> >> Also cleanly applies on 'next' branch of Balbi's USB tree.
> >> >>
> >> >>  drivers/usb/dwc3/dwc3-exynos.c |   51
> >> >> ++++++++++++++++++++++++++++++++++++++--
> >> >>  1 file changed, 49 insertions(+), 2 deletions(-)
> >> >>
> >> >> diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-
> >> >> exynos.c
> >> >> index 28c8ad7..c9d9102 100644
> >> >> --- a/drivers/usb/dwc3/dwc3-exynos.c
> >> >> +++ b/drivers/usb/dwc3/dwc3-exynos.c
> >> >> @@ -27,6 +27,7 @@
> >> >>  #include <linux/usb/usb_phy_gen_xceiv.h>
> >> >>  #include <linux/of.h>
> >> >>  #include <linux/of_platform.h>
> >> >> +#include <linux/regulator/consumer.h>
> >> >>
> >> >>  struct dwc3_exynos {
> >> >>       struct platform_device  *usb2_phy;
> >> >> @@ -34,6 +35,8 @@ struct dwc3_exynos {
> >> >>       struct device           *dev;
> >> >>
> >> >>       struct clk              *clk;
> >> >> +     struct regulator        *vdd33;
> >> >> +     struct regulator        *vdd10;
> >> >>  };
> >> >>
> >> >>  static int dwc3_exynos_register_phys(struct dwc3_exynos *exynos)
> >> >> @@ -144,20 +147,46 @@ static int dwc3_exynos_probe(struct
> >> >> platform_device *pdev)
> >> >>
> >> >>       clk_prepare_enable(exynos->clk);
> >> >>
> >> >> +     exynos->vdd33 = devm_regulator_get(dev, "vdd33");
> >> >> +     if (IS_ERR(exynos->vdd33)) {
> >> >> +             ret = PTR_ERR(exynos->vdd33);
> >> >> +             goto err2;
> >> >
> >> > Is regulator property mandatory for dwc3-exynos? If it is not
> >> > and device tree doesn't provide it, dwc3-exynos driver probe
> >> shouldn't
> >> > fail here.
> >>
> >> These are the VDD regulators (from PMIC ldo supplies), in absence of
> >> which the controller will not be powered up.
> >> So doesn't it make sense to stop the probe when these are not supplied
> >> by device tree ?
> >
> > Agree. Just curious, is there special reason for this change except making
> > things right?
> 
> Yea, actually after the patch (which got merged in 3.15 rc1)
> 275dcd2 ARM: dts: add max77686 pmic node for smdk5250,
> 
> the USB stops working, and that's because the regulators related to
> usb are not turned on by default (ldo12 and ldo15 to be specific).
> So we need to enable those regulators, which ofcourse the driver
> should be doing, if i am not wrong.
> Similar is the reason for EHCI, and OHCI exynos patches in this series.

Oh, I see. Thank you for your explanation.

> 
> I shall be sending the dt patch for this soon.

OK, I will wait for your patch.

Best regards,
Jingoo Han

> 
> 
> --
> Best Regards
> Vivek Gautam
> Samsung R&D Institute, Bangalore
> India


