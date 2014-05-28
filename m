Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbaE1Bhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 21:37:52 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:45445 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaE1Bhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 21:37:50 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-8d-53853decc2dd
From: Jingoo Han <jg1.han@samsung.com>
To: "'Bjorn Helgaas'" <bhelgaas@google.com>, "'Arnd Bergmann'" <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Magnus Damm'" <damm@opensource.se>, linux-pci@vger.kernel.org,
        linux-sh@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-14-git-send-email-arnd@arndb.de>
 <20140527225422.GE11907@google.com>
In-reply-to: <20140527225422.GE11907@google.com>
Subject: Re: [PATCH] pci: rcar host needs OF
Date: Wed, 28 May 2014 10:37:47 +0900
Message-id: <002401cf7a15$6e25d9f0$4a718dd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac95/p7OaZVpVAJ3SpGah8yk5UJcMQAFof8w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t8zQ903tq3BBjsnSFn8nXSM3WJJU4bF
	/ce3mCwuL7zEarHp8TVWi8u75rBZnJ13nM1izp8pzA4cHr9/TWL0WLCp1GPzknqPlT8usXv0
	bVnF6PF5k1wAWxSXTUpqTmZZapG+XQJXxsbG6ywFr3grvjV9ZW9g/M/VxcjJISFgInHg1kRm
	CFtM4sK99WxdjFwcQgLLGCW+f//OBFN04ulvJojEIkaJ3xM72SGc34wSO1/uZQWpYhNQk/jy
	5TA7iC0i4CXx4/VxsCJmgeOMEodPTwIrEhK4xCjRN4Wvi5GDg1PAQOLPdGWQsLCAjsSpCfdY
	QcIsAqoS35Y4gIR5BWwlZt05wQZhC0r8mHyPBcRmFtCSWL/zOBOELS+xec1bZpBWCQF1iUd/
	dSEuMJJon3CEEaJERGLfi3eMINdICPxll1jb1wuWYBEQkPg2+RALRK+sxKYD0ICQlDi44gbL
	BEaJWUg2z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCm9yEivODG3uDQvXS85P3cTIySW+3Yw3jxg
	fYgxGWj9RGYp0eR8YCrIK4k3NDYzsjA1MTU2Mrc0I01YSZx30cOkICGB9MSS1OzU1ILUovii
	0pzU4kOMTBycUg2Mc7do/Z66l8vK5sS5WeIBf+z/TFdoll965tgT65S8hl8vnePPO5Xdv27B
	8nfrUmd5g7DnW+w1wh7udS8NL4s3Edb/IJgkzDm/UsJfUerL85hHLwt5mOXk4zTtZjHu1NMu
	Wrdz6Z3T/3eeb6qYyuO/6o3h3rq2rTfPX2ZuKdbRE5j1bVdCaZGrEktxRqKhFnNRcSIAeXd5
	EPsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsVy+t9jAd03tq3BBud3iFr8nXSM3WJJU4bF
	/ce3mCwuL7zEarHp8TVWi8u75rBZnJ13nM1izp8pzA4cHr9/TWL0WLCp1GPzknqPlT8usXv0
	bVnF6PF5k1wAW1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKL
	T4CuW2YO0DlKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xoyNjddZCl7x
	Vnxr+srewPifq4uRk0NCwETixNPfTBC2mMSFe+vZuhi5OIQEFjFK/J7YyQ7h/GaU2PlyLytI
	FZuAmsSXL4fZQWwRAS+JH6+PgxUxCxxnlDh8ehJYkZDAJUaJvil8XYwcHJwCBhJ/piuDhIUF
	dCROTbjHChJmEVCV+LbEASTMK2ArMevOCTYIW1Dix+R7LCA2s4CWxPqdx5kgbHmJzWveMoO0
	SgioSzz6qwtxgZFE+4QjjBAlIhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPS
	cw31ihNzi0vz0vWS83M3MYITxTOpHYwrGywOMQpwMCrx8B5Y3BIsxJpYVlyZe4hRgoNZSYR3
	kUBrsBBvSmJlVWpRfnxRaU5q8SHGZKA/JzJLiSbnA5NYXkm8obGJmZGlkZmFkYm5OWnCSuK8
	B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUwHheKUxGyP3HhUsFjXssTTW9XubAv+7DFo+JU0KpM
	p7/HXpju7WTZdb72WMVaLrOfOjcfrjyxxFTowrUt1ZuyP0f0uM6LcMvhU5W43VvjJBo79dfd
	VLmrz+4Ht+k+CBZ6N58lamnN5VKzi1t4/TYxpHPMCdH/HFwzu0tsYrVsj175mRTDnYYTlViK
	MxINtZiLihMBvw8HhFgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 28, 2014 7:54 AM, Bjorn Helgaas wrote:
> On Thu, May 08, 2014 at 04:56:25PM +0200, Arnd Bergmann wrote:
> > The pci-rcar driver is enabled for compile tests, and this has
> > now shown that the driver cannot build without CONFIG_OF,
> > following the inclusion of f8f2fe7355fb "PCI: rcar: Use new OF
> > interrupt mapping when possible":
> >
> > drivers/built-in.o: In function `rcar_pci_map_irq':
> > :(.text+0x1cc7c): undefined reference to `of_irq_parse_and_map_pci'
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > Cc: Magnus Damm <damm@opensource.se>
> > Cc: linux-pci@vger.kernel.org
> > Cc: linux-sh@vger.kernel.org
> 
> If I understand correctly, this patch was superceded by this one:
> 
>     "[PATCH] of/irq: provide int of_irq_parse_and_map_pci wrapper"
> 
> and you aren't expecting me to do anything.  Let me know if otherwise.

Yes, right. I checked that the build error was resolved by the above
mentioned patch.

Best regards,
Jingoo Han

> 
> > ---
> >  drivers/pci/host/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
> > index fbbef0b..4675f47 100644
> > --- a/drivers/pci/host/Kconfig
> > +++ b/drivers/pci/host/Kconfig
> > @@ -27,7 +27,7 @@ config PCI_TEGRA
> >
> >  config PCI_RCAR_GEN2
> >  	bool "Renesas R-Car Gen2 Internal PCI controller"
> > -	depends on ARCH_SHMOBILE || (ARM && COMPILE_TEST)
> > +	depends on ARCH_SHMOBILE || (ARM && OF && COMPILE_TEST)
> >  	help
> >  	  Say Y here if you want internal PCI support on R-Car Gen2 SoC.
> >  	  There are 3 internal PCI controllers available with a single
> > --
> > 1.8.3.2
> >

