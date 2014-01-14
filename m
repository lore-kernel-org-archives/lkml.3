Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbaANWcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 17:32:08 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:58934 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaANWcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 17:32:03 -0500
X-AuditID: cbfee68e-b7f566d000002344-16-52d5bae1b2f9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Marek Vasut'" <marex@denx.de>, "'Wolfram Sang'" <wsa@the-dreams.de>,
        "'Fabio Estevam'" <fabio.estevam@freescale.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Richard Zhu'" <r65037@freescale.com>, linux-pci@vger.kernel.org,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Shawn Guo'" <shawn.guo@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1389700739-3696-1-git-send-email-wsa@the-dreams.de>
 <1389700739-3696-4-git-send-email-wsa@the-dreams.de>
 <201401141417.03349.marex@denx.de>
In-reply-to: <201401141417.03349.marex@denx.de>
Subject: Re: [PATCH 4/7] drivers/pci/host: don't check resource with
 devm_ioremap_resource
Date: Wed, 15 Jan 2014 07:32:01 +0900
Message-id: <001701cf1178$7191ec10$54b5c430$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8RKwMU8Q77stjIR12CkU1yjH5AOwATK5zw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t8zY92Hu64GGazrM7JY0pRhMatL1+Ly
	wkusFpseX2O1uLxrDpvF2XnH2SzetDUyWjyeJWzxdN0SZouVJ2YxO3B5zJt1gsXj3+F+Jo8F
	m0o97lzbw+axeUm9R9+WVYweJ089YfH4vEkugCOKyyYlNSezLLVI3y6BK+Pn//KCGTwVj8+o
	NzB+5uxi5OSQEDCR6DxzhxnCFpO4cG89WxcjF4eQwDJGieUds9hhiv4v6YVKTGeUWHTsMpTz
	i1Hi7K8/jCBVbAJqEl++HAbrEBEok9ixfRYLSBGzwB9GiT0XrrCBJIQE5jBKrFhVBGJzCuhL
	LP7+lQXEFhaIkbi+eDITiM0ioCqxY+o6MJtXwFbi4M9dLBC2oMSPyffAbGYBLYn1O48zQdjy
	EpvXvAX6gQPoVHWJR391IW4wklh8cAo7RImIxL4X7xhB7pEQmMghcezadlaIXQIS3yYfYoHo
	lZXYdAAaFJISB1fcYJnAKDELyeZZSDbPQrJ5FpIVCxhZVjGKphYkFxQnpRcZ6RUn5haX5qXr
	JefnbmKExHvfDsabB6wPMSYDrZ/ILCWanA9MF3kl8YbGZkYWpiamxkbmlmakCSuJ8y56mBQk
	JJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgdFj+15ljdbmCeust8Yl/N/W6OAr+IPzfXeLY6Hw
	pCfbu+Q1l+5eyb3u0xkDdYmevMXflkkz3nK7f1un9pKKltStfXNDG+ck6NbM/Lectd/zsNKH
	2KvXtEOeqQUGqyR3z99cLrCie353ydfZS84fzsv1dzevcXDknja5a+Kbp5t7LaX5mrLvyCmx
	FGckGmoxFxUnAgBrZwGIDQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOKsWRmVeSWpSXmKPExsVy+t9jQd2Hu64GGdyapWuxpCnDYlaXrsXl
	hZdYLTY9vsZqcXnXHDaLs/OOs1m8aWtktHg8S9ji6bolzBYrT8xiduDymDfrBIvHv8P9TB4L
	NpV63Lm2h81j85J6j74tqxg9Tp56wuLxeZNcAEdUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxz
	vKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtCBSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9
	Q4LgeowM0EDCOsaMn//LC2bwVDw+o97A+Jmzi5GTQ0LAROL/kl42CFtM4sK99UA2F4eQwHRG
	iUXHLkM5vxglzv76wwhSxSagJvHly2F2EFtEoExix/ZZLCBFzAJ/GCX2XLgCNkpIYA6jxIpV
	RSA2p4C+xOLvX1lAbGGBGInriyczgdgsAqoSO6auA7N5BWwlDv7cxQJhC0r8mHwPzGYW0JJY
	v/M4E4QtL7F5zVvmLkYOoFPVJR791YW4wUhi8cEp7BAlIhL7XrxjnMAoNAvJpFlIJs1CMmkW
	kpYFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYKTyTOpHYwrGywOMQpwMCrx8P4Ivxok
	xJpYVlyZe4hRgoNZSYRXvh4oxJuSWFmVWpQfX1Sak1p8iDEZ6NGJzFKiyfnARJdXEm9obGJm
	ZGlkZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYwmGkEnTMrkdfMSv/0+ua8k
	+fNjvglBpmfOVjK7tAlql1RMXVvzufFg5+zJM6ouX1l0zWry/glfOSKuKgi4t4t/mx62esH5
	mEPK6oZLF72NFhN3VN24X+Ttx4d7Jsw7aJsduXNN0sauk2UBKzMn3L4toN4VKhC3V4Hzw3c2
	Hsuixo40hXtr1osqsRRnJBpqMRcVJwIA/q2Zr2oDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 14, 2014 10:17 PM, Marek Vasut wrote:
> On Tuesday, January 14, 2014 at 12:58:55 PM, Wolfram Sang wrote:
> > devm_ioremap_resource does sanity checks on the given resource. No need to
> > duplicate this in the driver.
> >
> > Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> 
> True that,
> 
> Acked-by: Marek Vasut <marex@denx.de>

(+cc Fabio Estevam)

Hi all,

The same patch was already sent by Fabio Estevam a month ago.[1]
Also, it was applied to pci/next tree.[2]

[1] http://www.spinics.net/lists/linux-pci/msg26873.html
[2] http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/commit/?h=next&id=ebb034a4ce9fc37877b3df2b85b9c33d43349586

Best regards,
Jingoo Han

> 
> > ---
> >
> > Should go via subsystem tree
> >
> >  drivers/pci/host/pci-imx6.c | 5 -----
> >  1 file changed, 5 deletions(-)
> >
> > diff --git a/drivers/pci/host/pci-imx6.c b/drivers/pci/host/pci-imx6.c
> > index bd70af8..5002e23 100644
> > --- a/drivers/pci/host/pci-imx6.c
> > +++ b/drivers/pci/host/pci-imx6.c
> > @@ -426,11 +426,6 @@ static int __init imx6_pcie_probe(struct
> > platform_device *pdev) "imprecise external abort");
> >
> >  	dbi_base = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > -	if (!dbi_base) {
> > -		dev_err(&pdev->dev, "dbi_base memory resource not found\n");
> > -		return -ENODEV;
> > -	}
> > -
> >  	pp->dbi_base = devm_ioremap_resource(&pdev->dev, dbi_base);
> >  	if (IS_ERR(pp->dbi_base)) {
> >  		ret = PTR_ERR(pp->dbi_base);
> 
> Best regards,
> Marek Vasut

