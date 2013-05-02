Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab3EBAUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 20:20:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:39959 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3EBAUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 20:20:17 -0400
X-AuditID: cbfee68d-b7f016d000007930-75-5181b13f8724
From: Jingoo Han <jg1.han@samsung.com>
To: "'Guenter Roeck'" <linux@roeck-us.net>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
References: <001401ce455f$e7ba02a0$b72e07e0$@samsung.com>
 <20130430150544.GA15491@roeck-us.net>
In-reply-to: <20130430150544.GA15491@roeck-us.net>
Subject: Re: [PATCH V2 7/7] watchdog: ts72xx_wdt: use devm_*() functions
Date: Thu, 02 May 2013 09:20:14 +0900
Message-id: <003c01ce46ca$d1380290$73a807b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGXfkOVVNCAVd90P2TnO2B95afohQEmo8fCmVVizFA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t8zY137jY2BBqtecVvMWb+GzeLywkus
	Fpd3zWGzuLFuH7vFk4VnmCxuzXjB6sDmcW2zmMeJGb9ZPHZ+b2D36NuyitHj8ya5ANYoLpuU
	1JzMstQifbsEroyPv16zFTzXrTh4YSZzA2OLShcjJ4eEgInEhyN3GSFsMYkL99azgdhCAssY
	JZpWccDUdBx6xd7FyAUUX8QocarxDSuE84tR4uajw6wgVWwCahJfvhxmB7FFBDQkrk+ZwwhS
	xCywnVFiz+JXTBBjEyVmTZoOtoJTwEhixvtDYLawgIfEjsvnwM5gEVCVODqhD2wor4ClxKWV
	C5kgbEGJH5PvsYDYzAJaEut3HmeCsOUlNq95ywxxqoLEjrOvGSGOsJJoWL2YHaJGRGLfi3dg
	B0kIvGSXWLj8LzvEMgGJb5MPAQ3lAErISmw6ADVHUuLgihssExglZiFZPQvJ6llIVs9CsmIB
	I8sqRtHUguSC4qT0IkO94sTc4tK8dL3k/NxNjJCo7d3BePuA9SHGZKD1E5mlRJPzgVGfVxJv
	aGxmZGFqYmpsZG5pRpqwkjivWot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbG/W4RDvu0
	ZQ+Jzai9rLl6npRpyFme+a++8W9+Z/HT+uHil3yLXjdmxybekXj1pGHy9yxWnqykxWt1uV48
	KpBg3K0dea+aecP1FSfD9fVuswefrYspZu09emlSKP/iizs3zJxUlNg82+71n3Vz30VH/vjA
	uZit4Fab7K1Tul3tl98bF5+tNtk/V4mlOCPRUIu5qDgRAK4Eu93wAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsVy+t9jAV37jY2BBu332SzmrF/DZnF54SVW
	i8u75rBZ3Fi3j93iycIzTBa3ZrxgdWDzuLZZzOPEjN8sHju/N7B79G1ZxejxeZNcAGtUA6NN
	RmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtAFSgpliTml
	QKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaMj79esxU81604eGEmcwNji0oXIyeH
	hICJRMehV+wQtpjEhXvr2boYuTiEBBYxSpxqfMMK4fxilLj56DArSBWbgJrEly+HwTpEBDQk
	rk+ZwwhSxCywnVFiz+JXTCAJIYFEiVmTprOB2JwCRhIz3h8Cs4UFPCR2XD7HCGKzCKhKHJ3Q
	BzaUV8BS4tLKhUwQtqDEj8n3WEBsZgEtifU7jzNB2PISm9e8ZYY4VUFix9nXjBBHWEk0rF7M
	DlEjIrHvxTvGCYxCs5CMmoVk1Cwko2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cT
	IzgpPJPewbiqweIQowAHoxIP7wfdxkAh1sSy4srcQ4wSHMxKIrw/pwGFeFMSK6tSi/Lji0pz
	UosPMSYDfTqRWUo0OR+YsPJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoE
	s4WJg1OqgdHJvUu/1lowv5R1Qu7mjncXGmc8ujn12t3o8nPTn79L0Fjec0B6X9rF1Tc338hx
	Ph5ntOLLBO3tJTal8rpcJlw5nXM7Q+PZ2XK03vUqP/j84N7d16vLTml2cL3eF8w6U3bug/0c
	T3i3PhCPjJN7GZ6fUMnHcT+Et8f7+MuilXXhId8m+eeaPFJiKc5INNRiLipOBACqUtUuTgMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 01, 2013 12:06 AM, Guenter Roeck wrote:
> On Tue, Apr 30, 2013 at 02:02:25PM +0900, Jingoo Han wrote:
> > Use devm_*() functions to make cleanup paths simpler.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> > No changes since v1:
> >
> Side note: If you make no changes, there is no need to send V2, especially not
> one marked as another version. Usually, when I do that kind of thing, I just
> resend.
> 
> This also applies if you get a Reviewed-by:, Acked-by:, or similar response.
> You can leave it up to the maintainer to add those to the patch.
> 
> >  drivers/watchdog/ts72xx_wdt.c |   64 +++++++----------------------------------
> >  1 files changed, 11 insertions(+), 53 deletions(-)
> >
> > diff --git a/drivers/watchdog/ts72xx_wdt.c b/drivers/watchdog/ts72xx_wdt.c
> > index b8a9245..b19ca75 100644
> > --- a/drivers/watchdog/ts72xx_wdt.c
> > +++ b/drivers/watchdog/ts72xx_wdt.c
> > @@ -396,7 +396,7 @@ static int ts72xx_wdt_probe(struct platform_device *pdev)
> >  	struct resource *r1, *r2;
> >  	int error = 0;
> >
> > -	wdt = kzalloc(sizeof(struct ts72xx_wdt), GFP_KERNEL);
> > +	wdt = devm_kzalloc(&pdev->dev, sizeof(struct ts72xx_wdt), GFP_KERNEL);
> >  	if (!wdt) {
> >  		dev_err(&pdev->dev, "failed to allocate memory\n");
> 
> My understanding from other conversations is that this error message is no
> longer needed.

The error message for devm_ioremap_resource() is not necessary,
however, the error message for devm_kzalloc() is necessary.
In devm_kzalloc(), there is no error message.
It just return NULL, when it fails as below:

./drivers/base/devres.c

773 void * devm_kzalloc(struct device *dev, size_t size, gfp_t gfp)
774 {
775         struct devres *dr;
776
777         /* use raw alloc_dr for kmalloc caller tracing */
778         dr = alloc_dr(devm_kzalloc_release, size, gfp);
779         if (unlikely(!dr))
780                 return NULL;
781
782         set_node_dbginfo(&dr->node, "devm_kzalloc_release", size);
783         devres_add(dev, dr->data);
784         return dr->data;
785 }
786 EXPORT_SYMBOL_GPL(devm_kzalloc);


> 
> >  		return -ENOMEM;
> > @@ -405,44 +405,22 @@ static int ts72xx_wdt_probe(struct platform_device *pdev)
> >  	r1 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >  	if (!r1) {
> >  		dev_err(&pdev->dev, "failed to get memory resource\n");
> > -		error = -ENODEV;
> > -		goto fail;
> > -	}
> > -
> > -	r1 = request_mem_region(r1->start, resource_size(r1), pdev->name);
> > -	if (!r1) {
> > -		dev_err(&pdev->dev, "cannot request memory region\n");
> > -		error = -EBUSY;
> > -		goto fail;
> > +		return -ENODEV;
> >  	}
> >
> > -	wdt->control_reg = ioremap(r1->start, resource_size(r1));
> > -	if (!wdt->control_reg) {
> > -		dev_err(&pdev->dev, "failed to map memory\n");
> > -		error = -ENODEV;
> > -		goto fail_free_control;
> > -	}
> > +	wdt->control_reg = devm_ioremap_resource(&pdev->dev, r1);
> > +	if (IS_ERR(wdt->control_reg))
> > +		return PTR_ERR(wdt->control_reg);
> >
> >  	r2 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> >  	if (!r2) {
> >  		dev_err(&pdev->dev, "failed to get memory resource\n");
> > -		error = -ENODEV;
> > -		goto fail_unmap_control;
> > +		return -ENODEV;
> >  	}
> >
> > -	r2 = request_mem_region(r2->start, resource_size(r2), pdev->name);
> > -	if (!r2) {
> > -		dev_err(&pdev->dev, "cannot request memory region\n");
> > -		error = -EBUSY;
> > -		goto fail_unmap_control;
> > -	}
> > -
> > -	wdt->feed_reg = ioremap(r2->start, resource_size(r2));
> > -	if (!wdt->feed_reg) {
> > -		dev_err(&pdev->dev, "failed to map memory\n");
> > -		error = -ENODEV;
> > -		goto fail_free_feed;
> > -	}
> > +	wdt->feed_reg = devm_ioremap_resource(&pdev->dev, r2);
> > +	if (IS_ERR(wdt->feed_reg))
> > +		return PTR_ERR(wdt->feed_reg);
> >
> >  	platform_set_drvdata(pdev, wdt);
> >  	ts72xx_wdt_pdev = pdev;
> > @@ -455,45 +433,25 @@ static int ts72xx_wdt_probe(struct platform_device *pdev)
> >  	error = misc_register(&ts72xx_wdt_miscdev);
> >  	if (error) {
> >  		dev_err(&pdev->dev, "failed to register miscdev\n");
> > -		goto fail_unmap_feed;
> > +		goto fail;
> >  	}
> >
> >  	dev_info(&pdev->dev, "TS-72xx Watchdog driver\n");
> >
> >  	return 0;
> >
> > -fail_unmap_feed:
> > -	platform_set_drvdata(pdev, NULL);
> > -	iounmap(wdt->feed_reg);
> > -fail_free_feed:
> > -	release_mem_region(r2->start, resource_size(r2));
> > -fail_unmap_control:
> > -	iounmap(wdt->control_reg);
> > -fail_free_control:
> > -	release_mem_region(r1->start, resource_size(r1));
> >  fail:
> > -	kfree(wdt);
> > +	platform_set_drvdata(pdev, NULL);
> 
> 	platform_set_drvdata(pdev, NULL);
> 
> is not needed. By eliminating it you could get rid of the entire error path.

OK, I will remove it.
Thank you.

Best regards,
Jingoo Han

> 
> >  	return error;
> >  }
> >
> >  static int ts72xx_wdt_remove(struct platform_device *pdev)
> >  {
> > -	struct ts72xx_wdt *wdt = platform_get_drvdata(pdev);
> > -	struct resource *res;
> >  	int error;
> >
> >  	error = misc_deregister(&ts72xx_wdt_miscdev);
> >  	platform_set_drvdata(pdev, NULL);
> >
> > -	iounmap(wdt->feed_reg);
> > -	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> > -	release_mem_region(res->start, resource_size(res));
> > -
> > -	iounmap(wdt->control_reg);
> > -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > -	release_mem_region(res->start, resource_size(res));
> > -
> > -	kfree(wdt);
> >  	return error;
> >  }
> >
> > --
> > 1.7.2.5
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >

