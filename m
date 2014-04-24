Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbaDXAiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 20:38:11 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:18672 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaDXAiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 20:38:07 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-aa-53585cedb1ea
From: Anton Tikhomirov <av.tikhomirov@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, balbi@ti.com, kgene.kim@samsung.com,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1398082604-3013-1-git-send-email-gautam.vivek@samsung.com>
 <002b01cf5f52$a7bc0d70$f7342850$%tikhomirov@samsung.com>
In-reply-to: <002b01cf5f52$a7bc0d70$f7342850$%tikhomirov@samsung.com>
Subject: RE: [PATCH 1/3] usb: ohci-exynos: Make provision for vdd regulators
Date: Thu, 24 Apr 2014 09:38:04 +0900
Message-id: <002e01cf5f55$74aff060$5e0fd120$%tikhomirov@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9dW7xThSfjkrSrQe+CdXtZr3k56gB9L0nAAAEPc3A=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t8zI923MRHBBrc2yVkcvF9v0XblILtF
	8+L1bBaXF15itehdcJXNYtPja6wWl3fNYbOYvaSfxWLG+X1MFouWtTJbTPh9gc2B22P/3DXs
	HpuX1HvMvvuD0aNvyypGj+M3tjN5fN4kF8AWxWWTkpqTWZZapG+XwJXx4Ph/loJ3KhXHtz5n
	bmBcLtvFyMkhIWAisfrXMyYIW0ziwr31bF2MXBxCAssYJR6dPsQOU3T97W6oxHRGiW1tE5hB
	EkIC/xgl9rXlg9hsAkYSLw9uBIuLCORKzHq7khmkgVngBaPEyb2nGCG6mxgl2jfuAxrFwcEp
	4CqxaoIRSIOwgI/E59mrwJpZBFQl1nedYgGxeQVcJB7eOMsEYQtK/Jh8DyzOLGAg8X5WHyuE
	LS+xec1bZpCREgLqEo/+6kLcYCXx581zZogScYlJDx6yg5wgITCRQ+LHnSuMELsEJL5NPsQC
	0SsrsekAM8TDkhIHV9xgmcAoMQvJ5llINs9CsnkWkhULGFlWMYqmFiQXFCelF5nqFSfmFpfm
	pesl5+duYoRE+8QdjPcPWB9iTAZaP5FZSjQ5H5gs8kriDY3NjCxMTUyNjcwtzUgTVhLnTX+U
	FCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBsUvxftKOiX5WYh+TOE+6qicf3b/o3QGBOYcf
	2f6N5zD7tPTG+9WcqYcnikYIPjHJ+HvL17DFr+5w0rNfDtufXwqfF36v57NYmxHfbiYB89fL
	+7Q8qmOcloqulbeQqtrNyyvKUdbAERtafUN78vu843zTszdfexEftP/qtjlfD969qzZLwkB5
	vhJLcUaioRZzUXEiABTQG7gMAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsVy+t9jQd23MRHBBg1XJSwO3q+3aLtykN2i
	efF6NovLCy+xWvQuuMpmsenxNVaLy7vmsFnMXtLPYjHj/D4mi0XLWpktJvy+wObA7bF/7hp2
	j81L6j1m3/3B6NG3ZRWjx/Eb25k8Pm+SC2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1
	MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6T0mhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQ
	XI+RARpIWMeY8eD4f5aCdyoVx7c+Z25gXC7bxcjJISFgInH97W42CFtM4sK99UA2F4eQwHRG
	iW1tE5hBEkIC/xgl9rXlg9hsAkYSLw9uBIuLCORKzHq7khmkgVngBaPEyb2nGCG6mxgl2jfu
	AxrFwcEp4CqxaoIRSIOwgI/E59mrwJpZBFQl1nedYgGxeQVcJB7eOMsEYQtK/Jh8DyzOLGAg
	8X5WHyuELS+xec1bZpCREgLqEo/+6kLcYCXx581zZogScYlJDx6yT2AUmoVk0iwkk2YhmTQL
	ScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMGp5JnUDsaVDRaHGAU4GJV4eA9cCA8W
	Yk0sK67MPcQowcGsJMKb5xERLMSbklhZlVqUH19UmpNafIgxGejRicxSosn5wDSXVxJvaGxi
	ZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MEj4fdBh/TtpoM6nnHdNf
	JcsUnxNMlyXLFgXzWW77vnzPT405K4OPW3Ob7v/tXmyyvSDYZN6TsscVC5dPeq9yLfM5f4bb
	ujv2jit4rqnV74mzdf7QXqSUIhTdW1n0asOUxnydzOmxb51rp4e15F78vq2Sv3bdrtw1Lztu
	OvtHHLuc8PPgv5mlSizFGYmGWsxFxYkAwtjYUGkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Hi,
> 
> > -----Original Message-----
> > From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-
> > owner@vger.kernel.org] On Behalf Of Vivek Gautam
> > Sent: Monday, April 21, 2014 9:17 PM
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
> > @@ -98,6 +101,28 @@ static int exynos_ohci_probe(struct
> platform_device
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

On the other hand, if power is not applied to the controller,
register access in ohci_resume() may lead to undefined behavior.
What's your opinion?

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

Thanks

