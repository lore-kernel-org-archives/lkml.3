Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbaDXB0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 21:26:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64086 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaDXB0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 21:26:17 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-46-5358683721c6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Tikhomirov'" <av.tikhomirov@samsung.com>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, balbi@ti.com, kgene.kim@samsung.com,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1398082604-3013-1-git-send-email-gautam.vivek@samsung.com>
 <002b01cf5f52$a7bc0d70$f7342850$%tikhomirov@samsung.com>
 <001a01cf5f54$af090810$0d1b1830$%han@samsung.com>
In-reply-to: <001a01cf5f54$af090810$0d1b1830$%han@samsung.com>
Subject: Re: [PATCH 1/3] usb: ohci-exynos: Make provision for vdd regulators
Date: Thu, 24 Apr 2014 10:26:15 +0900
Message-id: <000001cf5f5c$2f6c2440$8e446cc0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9dW7xThSfjkrSrQe+CdXtZr3k56gB9L0nAAADtKFAAARFQsA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t8zQ13zjIhggzsTtCyW7L7BanHwfr1F
	25WD7BbNi9ezWVxeeInVonfBVTaLTY+vsVpc3jWHzWL2kn4Wixnn9zFZLFrWymwx4fcFNgce
	j/1z17B7bF5S7zH77g9Gj74tqxg9jt/YzuTxeZNcAFsUl01Kak5mWWqRvl0CV8aNmasZCxYa
	V6z7+ZqtgXGeRhcjJ4eEgInEttlf2CBsMYkL99YD2VwcQgLLGCUufPvGAlPUOXkCI0RiEaPE
	tz/bmSCc30DOhN3sIFVsAmoSX74cBrNFBOIlFi17zQJSxCywgkli48NVYKOEBLYxSrxbrwti
	cwrYSfR1d7CC2MICPhIT7t9gBLFZBFQlOg/vALN5BWwlltxYwAxhC0r8mHwPbA6zgJbE+p3H
	mSBseYnNa94C1XAAnaou8eivLsQNThJ3uqayQpSISOx78Q7sAwmBqRwS91o7oHYJSHybfIgF
	oldWYtMBZoiPJSUOrrjBMoFRYhaSzbOQbJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLVK07MLS7N
	S9dLzs/dxAiJ/Ik7GO8fsD7EmAy0fiKzlGhyPjBx5JXEGxqbGVmYmpgaG5lbmpEmrCTOm/4o
	KUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY9z81d/Kn683+eMQdeFcuKLv0QNlX/busfdT
	uv/m+brKf2+fuCTtS4nuK+559m/B7xl5b3fYXMlk/XKnn6ehZxfH//0XjDa/EE3W36486en5
	I9duu03cHOJ8q/mxDnvjsa51Sy9uZXd+Gbe36I/wgxtHLyoqxs/5+cH8WOrbSrHqFxHXVebM
	vPtBiaU4I9FQi7moOBEAeL+1zxIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDKsWRmVeSWpSXmKPExsVy+t9jAV3zjIhgg+kbVSyW7L7BanHwfr1F
	25WD7BbNi9ezWVxeeInVonfBVTaLTY+vsVpc3jWHzWL2kn4Wixnn9zFZLFrWymwx4fcFNgce
	j/1z17B7bF5S7zH77g9Gj74tqxg9jt/YzuTxeZNcAFtUA6NNRmpiSmqRQmpecn5KZl66rZJ3
	cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtCNSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAa
	I3R9Q4LgeowM0EDCOsaMGzNXMxYsNK5Y9/M1WwPjPI0uRk4OCQETic7JExghbDGJC/fWs3Ux
	cnEICSxilPj2ZzsThPMbyJmwmx2kik1ATeLLl8NgtohAvMSiZa9ZQIqYBVYwSWx8uIoFJCEk
	sI1R4t16XRCbU8BOoq+7gxXEFhbwkZhw/wbYOhYBVYnOwzvAbF4BW4klNxYwQ9iCEj8m3wOb
	wyygJbF+53EmCFteYvOat0A1HECnqks8+qsLcYOTxJ2uqawQJSIS+168Y5zAKDQLyaRZSCbN
	QjJpFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGC08oz6R2MqxosDjEKcDAq8fAq
	3AoPFmJNLCuuzD3EKMHBrCTCm+cRESzEm5JYWZValB9fVJqTWnyIMRno0YnMUqLJ+cCUl1cS
	b2hsYmZkaWRmYWRibk6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjE1pfI6RndzP315L
	8ZZYw92z4fU2/Y3tYm+K9S/fSijk6b63KqqprTphgnH6pwOMDS91+Ly5prUpZNUxzvS3KOZW
	FAgLCV7wM+C7YGp9rdCC+b+e/v3n73asJn7PSZFVCTod8TlMtVL+NjPW+Oo53zW8xWb97cC/
	hpaHP9q+PG+O54qZZnVYiaU4I9FQi7moOBEA1BGAFm8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 24, 2014 9:33 AM, Jingoo Han wrote:
> On Thursday, April 24, 2014 9:18 AM, Anton Tikhomirov wrote:
> > On Monday, April 21, 2014 9:17 PM, Vivek Gautam wrote:
> > >
> > > Facilitate getting required 3.3V and 1.0V VDD supply for
> > > OHCI controller on Exynos.
> > >
> > > With patches for regulators' nodes merged in 3.15:
> > > c8c253f ARM: dts: Add regulator entries to smdk5420
> > > 275dcd2 ARM: dts: add max77686 pmic node for smdk5250,
> > >
> > > certain perripherals will now need to ensure that,
> > > they request VDD regulators in their drivers, and enable
> > > them so as to make them working.
> > >
> > > Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> > > Cc: Jingoo Han <jg1.han@samsung.com>
> > > ---
> > >
> > > Based on 'usb-next' branch of Greg's usb tree.
> > >
> > >  drivers/usb/host/ohci-exynos.c |   47
> > > ++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 47 insertions(+)
> > >
> > > diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-
> > > exynos.c
> > > index 68588d8..e2e72a8 100644
> > > --- a/drivers/usb/host/ohci-exynos.c
> > > +++ b/drivers/usb/host/ohci-exynos.c
> > > @@ -18,6 +18,7 @@
> > >  #include <linux/module.h>
> > >  #include <linux/of.h>
> > >  #include <linux/platform_device.h>
> > > +#include <linux/regulator/consumer.h>
> > >  #include <linux/usb/phy.h>
> > >  #include <linux/usb/samsung_usb_phy.h>
> > >  #include <linux/usb.h>
> > > @@ -37,6 +38,8 @@ struct exynos_ohci_hcd {
> > >  	struct clk *clk;
> > >  	struct usb_phy *phy;
> > >  	struct usb_otg *otg;
> > > +	struct regulator *vdd33;
> > > +	struct regulator *vdd10;
> > >  };
> > >
> > >  static void exynos_ohci_phy_enable(struct platform_device *pdev)
> > > @@ -98,6 +101,28 @@ static int exynos_ohci_probe(struct platform_device
> > > *pdev)
> > >  		exynos_ohci->otg = phy->otg;
> > >  	}
> > >
> > > +	exynos_ohci->vdd33 = devm_regulator_get(&pdev->dev, "vdd33");
> > > +	if (IS_ERR(exynos_ohci->vdd33)) {
> > > +		err = PTR_ERR(exynos_ohci->vdd33);
> > > +		goto fail_regulator1;
> > > +	}
> > > +	err = regulator_enable(exynos_ohci->vdd33);
> > > +	if (err) {
> > > +		dev_err(&pdev->dev, "Failed to enable VDD33 supply\n");
> > > +		goto fail_regulator1;
> > > +	}
> > > +
> > > +	exynos_ohci->vdd10 = devm_regulator_get(&pdev->dev, "vdd10");
> > > +	if (IS_ERR(exynos_ohci->vdd10)) {
> > > +		err = PTR_ERR(exynos_ohci->vdd10);
> > > +		goto fail_regulator2;
> > > +	}
> > > +	err = regulator_enable(exynos_ohci->vdd10);
> > > +	if (err) {
> > > +		dev_err(&pdev->dev, "Failed to enable VDD10 supply\n");
> > > +		goto fail_regulator2;
> > > +	}
> > > +
> >
> > Do we need to skip regulator settings together with PHY configuration
> > in case of exynos5440?
> 
> Oh, right. In the case of exynos5440, regulator settings is not
> necessary. Vivek, would you fix it in order skip regulator settings
> in exynos5440? It also applies to ehci-exynos.

Sorry, in the case of exynos5440, this patch already skips
regulator settings.

In the case of exynos5440, there is no need to set PHY setting
and regulator setting.

How about making regulator setting "optional"?
Then, regulator setting can be done, only when regulator
is supported.

exynos_ohci_probe()
	exynos_ohci->vdd33 = devm_regulator_get(&pdev->dev, "vdd33");
	if (IS_ERR(exynos_ohci->vdd33)) {
		dev_err(&pdev->dev, "Failed to get VDD33 supply\n");
	} else {
		err = regulator_enable(exynos_ohci->vdd33);
		if (err) {
			dev_err(&pdev->dev, "Failed to enable VDD33 supply\n");
			goto fail_regulator1;
		}
	}

	exynos_ohci->vdd10 = devm_regulator_get(&pdev->dev, "vdd10");
	if (IS_ERR(exynos_ohci->vdd10)) {
		dev_err(&pdev->dev, "Failed to get VDD10 supply\n");
	} else {
		err = regulator_enable(exynos_ohci->vdd10);
		if (err) {
			dev_err(&pdev->dev, "Failed to enable VDD10 supply\n");
			goto fail_regulator2;
		}
	}

In this case, suspend/resume can be fixed as below.

exynos_ohci_suspend()
	if (exynos_ohci->vdd10)
		regulator_disable(exynos_ohci->vdd10);
	if (exynos_ohci->vdd33)
		regulator_disable(exynos_ohci->vdd33);

exynos_ohci_resume()

	if (exynos_ohci->vdd33) {
		ret = regulator_enable(exynos_ohci->vdd33);
		if (ret) {
			dev_err(dev, "Failed to enable VDD33 supply\n");
			return ret;
		}
	}
	if (exynos_ohci->vdd10) {
		ret = regulator_enable(exynos_ohci->vdd10);
		if (ret) {
			dev_err(dev, "Failed to enable VDD10 supply\n");
			return ret;
		}
	}

Best regards,
Jingoo Han

> 
> >
> > >  skip_phy:
> > >  	exynos_ohci->clk = devm_clk_get(&pdev->dev, "usbhost");
> > >
> > > @@ -154,6 +179,10 @@ fail_add_hcd:
> > >  fail_io:
> > >  	clk_disable_unprepare(exynos_ohci->clk);
> > >  fail_clk:
> > > +	regulator_disable(exynos_ohci->vdd10);
> > > +fail_regulator2:
> > > +	regulator_disable(exynos_ohci->vdd33);
> > > +fail_regulator1:
> > >  	usb_put_hcd(hcd);
> > >  	return err;
> > >  }
> > > @@ -172,6 +201,9 @@ static int exynos_ohci_remove(struct
> > > platform_device *pdev)
> > >
> > >  	clk_disable_unprepare(exynos_ohci->clk);
> > >
> > > +	regulator_disable(exynos_ohci->vdd10);
> > > +	regulator_disable(exynos_ohci->vdd33);
> > > +
> > >  	usb_put_hcd(hcd);
> > >
> > >  	return 0;
> > > @@ -208,6 +240,9 @@ static int exynos_ohci_suspend(struct device *dev)
> > >
> > >  	clk_disable_unprepare(exynos_ohci->clk);
> > >
> > > +	regulator_disable(exynos_ohci->vdd10);
> > > +	regulator_disable(exynos_ohci->vdd33);
> > > +
> > >  	spin_unlock_irqrestore(&ohci->lock, flags);
> > >
> > >  	return 0;
> > > @@ -218,6 +253,18 @@ static int exynos_ohci_resume(struct device *dev)
> > >  	struct usb_hcd *hcd			= dev_get_drvdata(dev);
> > >  	struct exynos_ohci_hcd *exynos_ohci	= to_exynos_ohci(hcd);
> > >  	struct platform_device *pdev		= to_platform_device(dev);
> > > +	int ret;
> > > +
> > > +	ret = regulator_enable(exynos_ohci->vdd33);
> > > +	if (ret) {
> > > +		dev_err(dev, "Failed to enable VDD33 supply\n");
> > > +		return ret;
> >
> > Not sure, but shall we continue resuming and do everything
> > we can in case of error? At least it will avoid
> > WARN_ON(clk->enable_count == 0) on next system suspend.
> >
> > > +	}
> > > +	ret = regulator_enable(exynos_ohci->vdd10);
> > > +	if (ret) {
> > > +		dev_err(dev, "Failed to enable VDD10 supply\n");
> > > +		return ret;
> > > +	}
> > >
> > >  	clk_prepare_enable(exynos_ohci->clk);
> > >
> > > --
> >
> > Thanks

