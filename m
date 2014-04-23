Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbaDWK5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 06:57:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22157 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaDWK5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 06:57:37 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-43-53579c9fa84b
From: Anton Tikhomirov <av.tikhomirov@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>
Cc: "'Linux USB Mailing List'" <linux-usb@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "'Greg KH'" <gregkh@linuxfoundation.org>,
        "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
References: <1398082604-3013-1-git-send-email-gautam.vivek@samsung.com>
 <1398082604-3013-3-git-send-email-gautam.vivek@samsung.com>
 <00bf01cf5ed6$28de18d0$7a9a4a70$%tikhomirov@samsung.com>
 <CAFp+6iE2eWJPMmxSF9gbfwMmeO7k0bo=geo5SKmdgBRjiFq7mA@mail.gmail.com>
In-reply-to: <CAFp+6iE2eWJPMmxSF9gbfwMmeO7k0bo=geo5SKmdgBRjiFq7mA@mail.gmail.com>
Subject: RE: [PATCH 3/3] usb: dwc3-exynos: Make provision for vdd regulators
Date: Wed, 23 Apr 2014 19:57:35 +0900
Message-id: <00d201cf5ee2$d55c4e90$8014ebb0$%tikhomirov@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9e2d+jTdZ2tv3/RG6ewpBxwcB2WQABvhsg
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t8zY935c8KDDb7NUrI4eL/eou3KQXaL
	5sXr2Sx6F1xls9j0+BqrxeVdc9gsZi/pZ7GYcX4fk8WiZa3MFhN+X2Bz4PLYP3cNu8fmJfUe
	s+/+YPTo27KK0eP4je1MHp83yQWwRXHZpKTmZJalFunbJXBlrGj/z1zwRqJi8pXV7A2MR4S7
	GDk4JARMJBbv1Opi5AQyxSQu3FvP1sXIxSEksIxR4tCpZUwQCROJn6dvMUEkpjNKdM96xg7h
	/GOU6Fizlw2kik3ASOLlwY3MILaIgK5Ez8SPLCBFzAJ3mCQuT3nGCtHRziRxYMFCZpDdnALB
	Ems2WIM0CAv4SCz7NRtsHYuAqsTShScZQWxeAReJzX2r2CBsQYkfk++xgNjMAuoSk+YtYoaw
	5SU2r3nLDPGOusSjv7ogpgjQPYsOhUNUiEtMevAQ7GYJgU4Oiec/l7NArBKQ+Db5EAtEq6zE
	pgPMEA9LShxccYNlAqPELCSLZyFZPAvJ4llIVixgZFnFKJpakFxQnJReZKRXnJhbXJqXrpec
	n7uJERLhfTsYbx6wPsSYDLR+IrOUaHI+MEHklcQbGpsZWZiamBobmVuakSasJM676GFSkJBA
	emJJanZqakFqUXxRaU5q8SFGJg5OqQZGl8YCs9r6o+/2LWfO4L/kWuBieyxWIn8Fw4I96xqj
	l0zf3bvg2Np204l/Wr0/THSOXfSCmZnpNuOUluyNV3euWR3z6ERVXNfKjhmV9mt2ri3LWfJd
	ybbz64o+u4+rHVmCEndsFK59kiw05YvnwgXr+716VucyVm3u0uzbOI9ztXBPwa5tYgZ1SizF
	GYmGWsxFxYkAbStbgwYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsVy+t9jQd35c8KDDTb2yFocvF9v0XblILtF
	8+L1bBa9C66yWWx6fI3V4vKuOWwWs5f0s1jMOL+PyWLRslZmiwm/L7A5cHnsn7uG3WPzknqP
	2Xd/MHr0bVnF6HH8xnYmj8+b5ALYohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0t
	LcyVFPISc1NtlVx8AnTdMnOALlNSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAG
	EtYxZqxo/89c8EaiYvKV1ewNjEeEuxg5OSQETCR+nr7FBGGLSVy4t56ti5GLQ0hgOqNE96xn
	7BDOP0aJjjV72UCq2ASMJF4e3MgMYosI6Er0TPzIAlLELHCHSeLylGesEB3tTBIHFiwEquLg
	4BQIllizwRqkQVjAR2LZr9lg61gEVCWWLjzJCGLzCrhIbO5bxQZhC0r8mHyPBcRmFlCXmDRv
	ETOELS+xec1bsJESQPFHf3VBTBGgexYdCoeoEJeY9OAh+wRGoVlIBs1CMmgWkkGzkLQsYGRZ
	xSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRGcQJ5J72Bc1WBxiFGAg1GJh1dieViwEGtiWXFl
	7iFGCQ5mJRFenWnhwUK8KYmVValF+fFFpTmpxYcYk4H+nMgsJZqcD0xueSXxhsYmZkaWRmYW
	Ribm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAWLdZKym40uq86aO5VvWL6lP2LDCT
	4uWtbUwq8tsstHLqbylVQ83VqjLLn5qtOcxccZDt+orF9xZfshN447M58o+d/C6DmFtf5gdp
	6b+dc6y50LtRMunOou/Gl491f2mXmvfkbZrnxuomt6rY85NbV72Im3fv/5u5jUlJak9rT187
	ctCmwuL4ViWW4oxEQy3mouJEAJZr7mxkAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Hi Anton,
> 
> 
> On Wed, Apr 23, 2014 at 2:56 PM, Anton Tikhomirov
> <av.tikhomirov@samsung.com> wrote:
> > Hello,
> >
> >> -----Original Message-----
> >> From: Vivek Gautam [mailto:gautamvivek1987@gmail.com] On Behalf Of
> >> Vivek Gautam
> >> Sent: Monday, April 21, 2014 9:17 PM
> >> To: linux-usb@vger.kernel.org; linux-samsung-soc@vger.kernel.org
> >> Cc: linux-kernel@vger.kernel.org; linux-omap@vger.kernel.org; linux-
> >> arm-kernel@lists.infradead.org; gregkh@linuxfoundation.org;
> >> stern@rowland.harvard.edu; balbi@ti.com; kgene.kim@samsung.com;
> Vivek
> >> Gautam; Anton Tikhomirov
> >> Subject: [PATCH 3/3] usb: dwc3-exynos: Make provision for vdd
> >> regulators
> >>
> >> Facilitate getting required 3.3V and 1.0V VDD supply for
> >> DWC3 controller on Exynos.
> >>
> >> With patches for regulators' nodes merged in 3.15:
> >> c8c253f ARM: dts: Add regulator entries to smdk5420
> >> 275dcd2 ARM: dts: add max77686 pmic node for smdk5250,
> >>
> >> certain perripherals will now need to ensure that,
> >> they request VDD regulators in their drivers, and enable
> >> them so as to make them working.
> >>
> >> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> >> Cc: Anton Tikhomirov <av.tikhomirov@samsung.com>
> >> ---
> >>
> >> Based on 'usb-next' branch of Greg's USB tree.
> >> Also cleanly applies on 'next' branch of Balbi's USB tree.
> >>
> >>  drivers/usb/dwc3/dwc3-exynos.c |   51
> >> ++++++++++++++++++++++++++++++++++++++--
> >>  1 file changed, 49 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-
> >> exynos.c
> >> index 28c8ad7..c9d9102 100644
> >> --- a/drivers/usb/dwc3/dwc3-exynos.c
> >> +++ b/drivers/usb/dwc3/dwc3-exynos.c
> >> @@ -27,6 +27,7 @@
> >>  #include <linux/usb/usb_phy_gen_xceiv.h>
> >>  #include <linux/of.h>
> >>  #include <linux/of_platform.h>
> >> +#include <linux/regulator/consumer.h>
> >>
> >>  struct dwc3_exynos {
> >>       struct platform_device  *usb2_phy;
> >> @@ -34,6 +35,8 @@ struct dwc3_exynos {
> >>       struct device           *dev;
> >>
> >>       struct clk              *clk;
> >> +     struct regulator        *vdd33;
> >> +     struct regulator        *vdd10;
> >>  };
> >>
> >>  static int dwc3_exynos_register_phys(struct dwc3_exynos *exynos)
> >> @@ -144,20 +147,46 @@ static int dwc3_exynos_probe(struct
> >> platform_device *pdev)
> >>
> >>       clk_prepare_enable(exynos->clk);
> >>
> >> +     exynos->vdd33 = devm_regulator_get(dev, "vdd33");
> >> +     if (IS_ERR(exynos->vdd33)) {
> >> +             ret = PTR_ERR(exynos->vdd33);
> >> +             goto err2;
> >
> > Is regulator property mandatory for dwc3-exynos? If it is not
> > and device tree doesn't provide it, dwc3-exynos driver probe
> shouldn't
> > fail here.
> 
> These are the VDD regulators (from PMIC ldo supplies), in absence of
> which the controller will not be powered up.
> So doesn't it make sense to stop the probe when these are not supplied
> by device tree ?

Agree. Just curious, is there special reason for this change except making
things right?


