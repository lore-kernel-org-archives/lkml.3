Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305AbaFLEVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 00:21:21 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:24476 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaFLEVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 00:21:19 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-85-53992ab6c755
From: Jingoo Han <jg1.han@samsung.com>
To: "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1402064411-18244-1-git-send-email-gautam.vivek@samsung.com>
 <Pine.LNX.4.44L0.1406111131200.890-100000@iolanthe.rowland.org>
In-reply-to: <Pine.LNX.4.44L0.1406111131200.890-100000@iolanthe.rowland.org>
Subject: Re: [PATCH v2 1/2] usb: ehci-exynos: Make provision for vdd regulators
Date: Thu, 12 Jun 2014 13:21:09 +0900
Message-id: <003801cf85f5$bc7ca200$3575e600$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+Fi1uNlb0vFAPsQ2uUC9QWQ846dgAab7xA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t8zfd1tWjODDQ5/ZrVou3KQ3aJ58Xo2
	i8sLL7Fa9C64ymax6fE1VovLu+awWcw4v4/JYtGyVmaLCb8vsDlweuyfu4bdY/OSeo/Zd38w
	evRtWcXo8XmTXABrFJdNSmpOZllqkb5dAlfGl6erGAsO8lYcOPmWuYHxDFcXIyeHhICJxN8b
	u9ghbDGJC/fWs3UxcnEICSxjlFi8+CQjTFHjojtQiUWMEtN/fWOFcH4zSjT9esgEUsUmoCbx
	5cthsFEiApESu1dfZgIpYhZ4yCgx4+FdFoiOLkaJ+0s2MYNUcQr4SGx5+5IVxBYW8Jc4M7GR
	DcRmEVCVuNX8G2wqr4CtRMO1f4wQtqDEj8n3WEBsZgEtifU7jzNB2PISm9e8BZrJAXSrusSj
	v7oQRxhJLOtezQpRIiKx78U7RpAbJAT+sku8XreNEWKXgMS3yYdYIHplJTYdYIZ4WVLi4Iob
	LBMYJWYh2TwLyeZZSDbPQrJiASPLKkbR1ILkguKk9CJDveLE3OLSvHS95PzcTYyQqO7dwXj7
	gPUhxmSg9ROZpUST84FJIa8k3tDYzMjC1MTU2Mjc0ow0YSVx3qSHSUFCAumJJanZqakFqUXx
	RaU5qcWHGJk4OKUaGK9x3E6/3MG+TuCF7IveTP3XP71v/ORSFvspHD+N++zr9w4X/nfI/is0
	yMjWPr3xcskRlbr6lPXqD878ZOrunrZMOab+psiTj8qB32y0nq/M1uAVCDwnGjtp/TV+LT7L
	A8EbHpowmoU8eLtYJ8D2x9HJPRYJHzdEvrxTKXhX8cYMw16WaKY0RyWW4oxEQy3mouJEAKlj
	/oYAAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t9jAd1tWjODDX4EWrRdOchu0bx4PZvF
	5YWXWC16F1xls9j0+BqrxeVdc9gsZpzfx2SxaFkrs8WE3xfYHDg99s9dw+6xeUm9x+y7Pxg9
	+rasYvT4vEkugDWqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJ
	xSdA1y0zB+geJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPGl6erGAsO
	8lYcOPmWuYHxDFcXIyeHhICJROOiO2wQtpjEhXvrgWwuDiGBRYwS0399Y4VwfjNKNP16yARS
	xSagJvHly2F2EFtEIFJi9+rLTCBFzAIPGSVmPLzLAtHRxShxf8kmZpAqTgEfiS1vX7KC2MIC
	/hJnJjaC7WMRUJW41fwbbCqvgK1Ew7V/jBC2oMSPyfdYQGxmAS2J9TuPM0HY8hKb17wFmskB
	dKu6xKO/uhBHGEks617NClEiIrHvxTvGCYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk9
	10ivODG3uDQvXS85P3cTIzhhPJPewbiqweIQowAHoxIPL0PtjGAh1sSy4srcQ4wSHMxKIryO
	54FCvCmJlVWpRfnxRaU5qcWHGJOBHp3ILCWanA9MZnkl8YbGJmZGlkZmFkYm5uakCSuJ8x5s
	tQ4UEkhPLEnNTk0tSC2C2cLEwSnVwCi1QPnbYvsfnekF7/T+zouYc2H3CsbNIr0O3Tsan97u
	uZ277byXR/mMCebRk+2PbGRwvHLGbnKE/2+517PvWj9av6MxzEnTMPXcl7uOes9VNvUzx3ep
	ruI9zyludfUTq+pTLf8zbOzr33rqJn3KLFNf4/k+aNp3scfLlv3Yeny/RcG33VM/ysopsRRn
	JBpqMRcVJwIA+ZwlaFwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 12, 2014 12:39 AM, Alan Stern wrote:
> On Fri, 6 Jun 2014, Vivek Gautam wrote:
> 
> > Facilitate getting required 3.3V and 1.0V VDD supply for
> > EHCI controller on Exynos.
> >
> > With patches for regulators' nodes merged in 3.15:
> > c8c253f ARM: dts: Add regulator entries to smdk5420
> > 275dcd2 ARM: dts: add max77686 pmic node for smdk5250,
> >
> > certain perripherals will now need to ensure that,
> > they request VDD regulators in their drivers, and enable
> > them so as to make them working.
> 
> "Certain peripherals"?  Don't you mean "certain controllers"?
> 
> Does this mean some controllers don't need to use the VDD regulators?
> 
> > @@ -193,7 +196,31 @@ static int exynos_ehci_probe(struct platform_device *pdev)
> >
> >  	err = exynos_ehci_get_phy(&pdev->dev, exynos_ehci);
> >  	if (err)
> > -		goto fail_clk;
> > +		goto fail_regulator1;
> > +
> > +	exynos_ehci->vdd33 = devm_regulator_get(&pdev->dev, "vdd33");
> > +	if (!IS_ERR(exynos_ehci->vdd33)) {
> > +		err = regulator_enable(exynos_ehci->vdd33);
> > +		if (err) {
> > +			dev_err(&pdev->dev,
> > +				"Failed to enable 3.3V Vdd supply\n");
> > +			goto fail_regulator1;
> > +		}
> > +	} else {
> > +		dev_warn(&pdev->dev, "Regulator 3.3V Vdd supply not found\n");
> > +	}
> 
> What if this is one of the controllers that don't need to use a VDD
> regulator?  Do you really want to print out a warning in that case?
> Should you call devm_regulator_get_optional() instead?

I agree with Alan's suggestion. This warning message is not
proper, when USB controllers that don't need a VDD regulator
are used. The devm_regulator_get_optional() looks better.

Best regards,
Jingoo Han


