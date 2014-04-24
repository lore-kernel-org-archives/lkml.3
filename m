Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaDXAci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 20:32:38 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32565 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbaDXAcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 20:32:35 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-c8-53585ba14fb9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Tikhomirov'" <av.tikhomirov@samsung.com>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, balbi@ti.com, kgene.kim@samsung.com,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1398082604-3013-1-git-send-email-gautam.vivek@samsung.com>
 <002b01cf5f52$a7bc0d70$f7342850$%tikhomirov@samsung.com>
In-reply-to: <002b01cf5f52$a7bc0d70$f7342850$%tikhomirov@samsung.com>
Subject: Re: [PATCH 1/3] usb: ohci-exynos: Make provision for vdd regulators
Date: Thu, 24 Apr 2014 09:32:33 +0900
Message-id: <001a01cf5f54$af090810$0d1b1830$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9dW7xThSfjkrSrQe+CdXtZr3k56gB9L0nAAADtKFA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+Zke7C6Ihgg6kftCyW7L7BanHwfr1F
	25WD7BbNi9ezWVxeeInVonfBVTaLTY+vsVpc3jWHzWL2kn4Wixnn9zFZLFrWymwx4fcFNgce
	j/1z17B7bF5S7zH77g9Gj74tqxg9jt/YzuTxeZNcAFsUl01Kak5mWWqRvl0CV8b66UvYCo6p
	VKxrvsPewNgh28XIySEhYCKx5ucBZghbTOLCvfVsXYxcHEICyxglDrZ9Z4Qpav37GyoxnVHi
	UfN0JgjnN6PE9EU/WECq2ATUJL58OcwOkhARmM8o0fBkMSuIwyzwglHi5N5TjBAtTYwS7Rv3
	AQ3j4OAUcJVYNcEIpFtYwEdiwv0bYPtYBFQlrp0+BTaVV8BW4uXyM1C2oMSPyffAbGYBLYn1
	O48zQdjyEpvXvGUGGSkhoC7x6K8uSFhEwEri1KzFbBAlIhL7XrwDO0FCYCaHxLbzS9kgdglI
	fJt8iAWiV1ZiEywsJCUOrrjBMoFRYhaSzbOQbJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLSK07M
	LS7NS9dLzs/dxAiJ/b4djDcPWB9iTAZaP5FZSjQ5H5g68kriDY3NjCxMTUyNjcwtzUgTVhLn
	XfQwKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo9+uicYVpa6FryQtPf7Ol2BN/3vps9Bs
	1qJzRSmLfGfJ7cyKj+C9psjRKHN6S/96Maua9Z+Otbn9f1HmOsU+gEGra+Xn/IscfNIXLgTL
	M/dFhG6xfaM4qS7MOJpVUbyj/fZ91dr47+wfL/MdcNC//2XavKUnyph+WHPOZrBrm3vgm+HO
	/xXiSizFGYmGWsxFxYkApIOM9hMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsVy+t9jQd2F0RHBBoc+qFgs2X2D1eLg/XqL
	tisH2S2aF69ns7i88BKrRe+Cq2wWmx5fY7W4vGsOm8XsJf0sFjPO72OyWLSsldliwu8LbA48
	HvvnrmH32Lyk3mP23R+MHn1bVjF6HL+xncnj8ya5ALaoBkabjNTElNQihdS85PyUzLx0WyXv
	4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKAblRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0
	Ruj6hgTB9RgZoIGEdYwZ66cvYSs4plKxrvkOewNjh2wXIyeHhICJROvf32wQtpjEhXvrgWwu
	DiGB6YwSj5qnM0E4vxklpi/6wQJSxSagJvHly2F2kISIwHxGiYYni1lBHGaBF4wSJ/eeYoRo
	aWKUaN+4D2gYBwengKvEqglGIN3CAj4SE+7fYASxWQRUJa6dPgU2lVfAVuLl8jNQtqDEj8n3
	wGxmAS2J9TuPM0HY8hKb17xlBhkpIaAu8eivLkhYRMBK4tSsxWwQJSIS+168Y5zAKDQLyaRZ
	SCbNQjJpFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCE8szqR2MKxssDjEKcDAq
	8fAeuBAeLMSaWFZcmXuIUYKDWUmEN88jIliINyWxsiq1KD++qDQntfgQYzLQoxOZpUST84FJ
	L68k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGPfe2dOsk7Yx
	XChDc/bKdXMeZu5kUXCVPSiwT8tcpFZaTUo8rGnjH0fd6xfs1G9OM0l/01SQtqF6/cUrXUoZ
	ftusNZrKbbvCZiYmpep6Llt0foaHeO6WKxfkp5jNYpi6eI5PyuvkLbYuAmrKm2fXPn+4U5ph
	Nv+3Vr5imfqFN5VOCWT7frweqsRSnJFoqMVcVJwIALsJFhBwAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 24, 2014 9:18 AM, Anton Tikhomirov wrote:
> On Monday, April 21, 2014 9:17 PM, Vivek Gautam wrote:
> >
> > Facilitate getting required 3.3V and 1.0V VDD supply for
> > OHCI controller on Exynos.
> >
> > With patches for regulators' nodes merged in 3.15:
> > c8c253f ARM: dts: Add regulator entries to smdk5420
> > 275dcd2 ARM: dts: add max77686 pmic node for smdk5250,
> >
> > certain perripherals will now need to ensure that,
> > they request VDD regulators in their drivers, and enable
> > them so as to make them working.
> >
> > Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> > Cc: Jingoo Han <jg1.han@samsung.com>
> > ---
> >
> > Based on 'usb-next' branch of Greg's usb tree.
> >
> >  drivers/usb/host/ohci-exynos.c |   47
> > ++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 47 insertions(+)
> >
> > diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-
> > exynos.c
> > index 68588d8..e2e72a8 100644
> > --- a/drivers/usb/host/ohci-exynos.c
> > +++ b/drivers/usb/host/ohci-exynos.c
> > @@ -18,6 +18,7 @@
> >  #include <linux/module.h>
> >  #include <linux/of.h>
> >  #include <linux/platform_device.h>
> > +#include <linux/regulator/consumer.h>
> >  #include <linux/usb/phy.h>
> >  #include <linux/usb/samsung_usb_phy.h>
> >  #include <linux/usb.h>
> > @@ -37,6 +38,8 @@ struct exynos_ohci_hcd {
> >  	struct clk *clk;
> >  	struct usb_phy *phy;
> >  	struct usb_otg *otg;
> > +	struct regulator *vdd33;
> > +	struct regulator *vdd10;
> >  };
> >
> >  static void exynos_ohci_phy_enable(struct platform_device *pdev)
> > @@ -98,6 +101,28 @@ static int exynos_ohci_probe(struct platform_device
> > *pdev)
> >  		exynos_ohci->otg = phy->otg;
> >  	}
> >
> > +	exynos_ohci->vdd33 = devm_regulator_get(&pdev->dev, "vdd33");
> > +	if (IS_ERR(exynos_ohci->vdd33)) {
> > +		err = PTR_ERR(exynos_ohci->vdd33);
> > +		goto fail_regulator1;
> > +	}
> > +	err = regulator_enable(exynos_ohci->vdd33);
> > +	if (err) {
> > +		dev_err(&pdev->dev, "Failed to enable VDD33 supply\n");
> > +		goto fail_regulator1;
> > +	}
> > +
> > +	exynos_ohci->vdd10 = devm_regulator_get(&pdev->dev, "vdd10");
> > +	if (IS_ERR(exynos_ohci->vdd10)) {
> > +		err = PTR_ERR(exynos_ohci->vdd10);
> > +		goto fail_regulator2;
> > +	}
> > +	err = regulator_enable(exynos_ohci->vdd10);
> > +	if (err) {
> > +		dev_err(&pdev->dev, "Failed to enable VDD10 supply\n");
> > +		goto fail_regulator2;
> > +	}
> > +
> 
> Do we need to skip regulator settings together with PHY configuration
> in case of exynos5440?

Oh, right. In the case of exynos5440, regulator settings is not 
necessary. Vivek, would you fix it in order skip regulator settings
in exynos5440? It also applies to ehci-exynos.

Best regards,
Jingoo Han

> 
> >  skip_phy:
> >  	exynos_ohci->clk = devm_clk_get(&pdev->dev, "usbhost");
> >
> > @@ -154,6 +179,10 @@ fail_add_hcd:
> >  fail_io:
> >  	clk_disable_unprepare(exynos_ohci->clk);
> >  fail_clk:
> > +	regulator_disable(exynos_ohci->vdd10);
> > +fail_regulator2:
> > +	regulator_disable(exynos_ohci->vdd33);
> > +fail_regulator1:
> >  	usb_put_hcd(hcd);
> >  	return err;
> >  }
> > @@ -172,6 +201,9 @@ static int exynos_ohci_remove(struct
> > platform_device *pdev)
> >
> >  	clk_disable_unprepare(exynos_ohci->clk);
> >
> > +	regulator_disable(exynos_ohci->vdd10);
> > +	regulator_disable(exynos_ohci->vdd33);
> > +
> >  	usb_put_hcd(hcd);
> >
> >  	return 0;
> > @@ -208,6 +240,9 @@ static int exynos_ohci_suspend(struct device *dev)
> >
> >  	clk_disable_unprepare(exynos_ohci->clk);
> >
> > +	regulator_disable(exynos_ohci->vdd10);
> > +	regulator_disable(exynos_ohci->vdd33);
> > +
> >  	spin_unlock_irqrestore(&ohci->lock, flags);
> >
> >  	return 0;
> > @@ -218,6 +253,18 @@ static int exynos_ohci_resume(struct device *dev)
> >  	struct usb_hcd *hcd			= dev_get_drvdata(dev);
> >  	struct exynos_ohci_hcd *exynos_ohci	= to_exynos_ohci(hcd);
> >  	struct platform_device *pdev		= to_platform_device(dev);
> > +	int ret;
> > +
> > +	ret = regulator_enable(exynos_ohci->vdd33);
> > +	if (ret) {
> > +		dev_err(dev, "Failed to enable VDD33 supply\n");
> > +		return ret;
> 
> Not sure, but shall we continue resuming and do everything
> we can in case of error? At least it will avoid
> WARN_ON(clk->enable_count == 0) on next system suspend.
> 
> > +	}
> > +	ret = regulator_enable(exynos_ohci->vdd10);
> > +	if (ret) {
> > +		dev_err(dev, "Failed to enable VDD10 supply\n");
> > +		return ret;
> > +	}
> >
> >  	clk_prepare_enable(exynos_ohci->clk);
> >
> > --
> 
> Thanks

