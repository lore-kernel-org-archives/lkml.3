Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab3IZFFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 01:05:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53424 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab3IZFFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 01:05:11 -0400
X-AuditID: cbfee68e-b7f756d000004512-51-5243c08507ed
From: Kukjin Kim <kgene@kernel.org>
To: "'Chander Kashyap'" <chander.kashyap@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: thomas.abraham@linaro.org, tglx@linutronix.de, t.figa@samsung.com
References: <1379937815-21746-1-git-send-email-chander.kashyap@linaro.org>
In-reply-to: <1379937815-21746-1-git-send-email-chander.kashyap@linaro.org>
Subject: RE: [PATCH v2] irqchip: exynos-combiner: remove hard-coded irq_base
 value
Date: Thu, 26 Sep 2013 14:05:09 +0900
Message-id: <02c701ceba75$f95b1900$ec114b00$@org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac64VPu0VRzoBnUnRIuXE33vSefZdgCIHE4w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t8zA93WA85BBvMvWFk8XH+TxWLT42us
	Fpd3zWGzmHF+H5PF+hmvWSw2b5rKbHFsxhJGB3aPO9f2sHm8O3eO3WPzknqPvi2rGD0+b5IL
	YI3isklJzcksSy3St0vgyui5pFLQKVhxdN5EtgbGw7xdjJwcEgImEvOn9TNB2GISF+6tZwOx
	hQSWMUq0zEuFqWn78IwFIr6IUeLdSv4uRi4g+y+jxLkll4AaODjYBJQlGpv0QWqEBbQkFm5p
	YgGpERGYyyhx6sxxVpAEs4CrxJG1r5ggBnlJHHo7G8zmFPCW2Ht5NyNEc4hE28b7YMtYBFQl
	Zm/7BhbnFTCUuLF5JyuELSjxY/I9FoiZWhLrdx5ngrDlJTavecsMco+EgLrEo7+6IGERASOJ
	/ctnQ5WLSOx78Y4R5DYJga/sEveWH2SG2CUg8W3yIRaIXlmJTQeYIX6XlDi44gbLBEbJWUg2
	z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCm9yEivODG3uDQvXS85P3cTIySe+3Yw3jxgfYgxGWj9
	RGYp0eR8YDrIK4k3NDYzsjA1MTU2Mrc0I01YSZxXrcU6UEggPbEkNTs1tSC1KL6oNCe1+BAj
	EwenVANjgd2tjQ82rIrkXdDTFm0vs9o+UztVREz9mXxoDPPJGT+PiSmWR869lZOQUl0j9uQ4
	I/eWp3k39vd9tY1uWnnOtqlVs2aPzprYR/aTnz6WvuQX7bMhSP/AxyeuiXv79jtZv5h0wYB5
	sdLmm1piKi6scupNCoUfCmqUJNekBNzqM3x+Wv3RRDslluKMREMt5qLiRADc2R0s/QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsVy+t9jAd3WA85BBie7TS0err/JYrHp8TVW
	i8u75rBZzDi/j8li/YzXLBabN01ltjg2YwmjA7vHnWt72DzenTvH7rF5Sb1H35ZVjB6fN8kF
	sEY1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAJ2h
	pFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8zouaRS0ClYcXTeRLYGxsO8
	XYycHBICJhJtH56xQNhiEhfurWcDsYUEFjFKvFvJ38XIBWT/ZZQ4t+QSUIKDg01AWaKxSR+k
	RlhAS2LhliYWkBoRgbmMEqfOHGcFSTALuEocWfuKCWKQl8Sht7PBbE4Bb4m9l3czQjSHSLRt
	vA+2mEVAVWL2tm9gcV4BQ4kbm3eyQtiCEj8m32OBmKklsX7ncSYIW15i85q3zCD3SAioSzz6
	qwsSFhEwkti/fDZUuYjEvhfvGCcwCs9CMmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FwjveLE
	3OLSvHS95PzcTYzgdPFMegfjqgaLQ4wCHIxKPLwXmJ2DhFgTy4orcw8xSnAwK4nwfjMCCvGm
	JFZWpRblxxeV5qQWH2JMBnp0IrOUaHI+MJXllcQbGpuYGVkamVkYmZibkyasJM57sNU6UEgg
	PbEkNTs1tSC1CGYLEwenVANjl7uWTRn3ToaFnauvHBJtXDPjSLiARsFN/oSw5vePw52X3C9J
	6Zfd+6GjoeOmsfr1y8VZHVGH3m9gkv57QCrY/fz3pbN44zf2HjWNmBQsxjXNUX5RgnJutGd9
	pcbxRqNTW1Z5+c+8MMnq8V8G282NJj7mGrW7Oh0ar72dvvrBSa5bfZsPdQUpsRRnJBpqMRcV
	JwIAN4Ztv1sDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chander Kashyap wrote:
> 
> Replace irq_domain_add_simple with "irq_domain_add_linear" in order to use
> linear irq domain, and to remove hardcoded irq_base_value.
> 
> Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
> ---
> Changes since v1:
> 	- Replaced irq_domain_add_simple with irq_domain_add_linear,
> 	  as suggested by Tomasz
> 
>  drivers/irqchip/exynos-combiner.c |   15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/irqchip/exynos-combiner.c b/drivers/irqchip/exynos-
> combiner.c
> index 4c68265..2551046 100644
> --- a/drivers/irqchip/exynos-combiner.c
> +++ b/drivers/irqchip/exynos-combiner.c
> @@ -206,8 +206,7 @@ static unsigned int combiner_lookup_irq(int group)
> 
>  static void __init combiner_init(void __iomem *combiner_base,
>  				 struct device_node *np,
> -				 unsigned int max_nr,
> -				 int irq_base)
> +				 unsigned int max_nr)
>  {
>  	int i, irq;
>  	unsigned int nr_irq;
> @@ -221,7 +220,7 @@ static void __init combiner_init(void __iomem
> *combiner_base,
>  		return;
>  	}
> 
> -	combiner_irq_domain = irq_domain_add_simple(np, nr_irq, irq_base,
> +	combiner_irq_domain = irq_domain_add_linear(np, nr_irq,
>  				&combiner_irq_domain_ops, combiner_data);
>  	if (WARN_ON(!combiner_irq_domain)) {
>  		pr_warning("%s: irq domain init failed\n", __func__);
> @@ -248,7 +247,6 @@ static int __init combiner_of_init(struct device_node
> *np,
>  {
>  	void __iomem *combiner_base;
>  	unsigned int max_nr = 20;
> -	int irq_base = -1;
> 
>  	combiner_base = of_iomap(np, 0);
>  	if (!combiner_base) {
> @@ -262,14 +260,7 @@ static int __init combiner_of_init(struct device_node
> *np,
>  			__func__, max_nr);
>  	}
> 
> -	/*
> -	 * FIXME: This is a hardwired COMBINER_IRQ(0,0). Once all devices
> -	 * get their IRQ from DT, remove this in order to get dynamic
> -	 * allocation.
> -	 */
> -	irq_base = 160;
> -
> -	combiner_init(combiner_base, np, max_nr, irq_base);
> +	combiner_init(combiner_base, np, max_nr);
> 
>  	return 0;
>  }
> --
> 1.7.9.5

Looks nice to me, applied with Tomasz's review.

Thanks,
Kukjin

