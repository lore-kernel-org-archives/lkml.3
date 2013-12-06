Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab3LFBtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 20:49:11 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:56858 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab3LFBtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 20:49:06 -0500
X-AuditID: cbfee68e-b7fee6d000003b32-9f-52a12d102499
From: Jingoo Han <jg1.han@samsung.com>
To: "'Grygorii Strashko'" <grygorii.strashko@ti.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Kevin Hilman'" <khilman@linaro.org>,
        "'Tony Lindgren'" <tony@atomide.com>,
        "'Peter Ujfalusi'" <peter.ujfalusi@ti.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000001cef155$be1674e0$3a435ea0$%han@samsung.com>
 <52A0AEDD.7060509@ti.com>
In-reply-to: <52A0AEDD.7060509@ti.com>
Subject: Re: [PATCH 1/2] rtc: rtc-twl: Use devm_*() functions
Date: Fri, 06 Dec 2013 10:49:04 +0900
Message-id: <000d01cef225$57f02230$07d06690$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7x0gpiKvxMyt3kQ/uT/jm5jRqQWwAUbRiA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t8zA10B3YVBBos+KFksuXiV3WLO+jVs
	FiunsFhcXniJ1eLr4RWMFpd3zWGzmPXxB6vF/s4ORov9V7wcOD2+fZ3E4rFn4kk2jzvX9rB5
	nJjxm8Wjb8sqRo/jN7YzeUyf95PJ4/MmuQCOKC6blNSczLLUIn27BK6MO53P2Ao2qVT8/TGf
	pYFxgkwXIyeHhICJRMOUGywQtpjEhXvr2boYuTiEBJYxSnz4voQVpmjGnTXMEIlFjBKrb32A
	cn4BVT0+wAhSxSagJvHly2F2EFtEIFFixdytYEXMAi1MEr1NK8CKhAQiJc72gHRzcHACNUy5
	aQYSFhawlVi26gRYCYuAqsSqOzvZQEp4geLLX6WChHkFBCV+TL4HdimzgJbE+p3HmSBseYnN
	a96CTZQQUJd49FcX4gIjiekvXzNClIhI7HvxjhHkGgmBiRwSU6fNg1olIPFt8iEWiF5ZiU0H
	mCH+lZQ4uOIGywRGiVlINs9CsnkWks2zkKxYwMiyilE0tSC5oDgpvchIrzgxt7g0L10vOT93
	EyMk1vt2MN48YH2IMRlo/URmKdHkfGCqyCuJNzQ2M7IwNTE1NjK3NCNNWEmcd9HDpCAhgfTE
	ktTs1NSC1KL4otKc1OJDjEwcnFINjGFhwRGXX5vXXqhf1m6rduzR26rNDzaU+UzcX1Vx9tTu
	+6f9pG9VnfStqV1XLSrpYv10m9zZSXdPXHrAE93QeHuLrMvEGkV1kfNXhW75HomN12jrf1dy
	8LPalXqlNRlbb53/uejhOvnJC9sWpa4/rHXmb3KZ2EXZt73yD0XmP9zblfWTXUl9mrMSS3FG
	oqEWc1FxIgCG24WDCwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsVy+t9jAV0B3YVBBrcPyFosuXiV3WLO+jVs
	FiunsFhcXniJ1eLr4RWMFpd3zWGzmPXxB6vF/s4ORov9V7wcOD2+fZ3E4rFn4kk2jzvX9rB5
	nJjxm8Wjb8sqRo/jN7YzeUyf95PJ4/MmuQCOqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hT
	MwNDXUNLC3MlhbzE3FRbJRefAF23zByg85QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYE
	wfUYGaCBhHWMGXc6n7EVbFKp+PtjPksD4wSZLkZODgkBE4kZd9YwQ9hiEhfurWfrYuTiEBJY
	xCix+tYHZgjnF6PEh8cHGEGq2ATUJL58OcwOYosIJEqsmLsVrIhZoIVJordpBViRkECkxNke
	kG4ODk6ghik3zUDCwgK2EstWnQArYRFQlVh1ZycbSAkvUHz5q1SQMK+AoMSPyfdYQGxmAS2J
	9TuPM0HY8hKb17wFmyghoC7x6K8uxAVGEtNfvmaEKBGR2PfiHeMERqFZSCbNQjJpFpJJs5C0
	LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRnEieSe1gXNlgcYhRgINRiYeXY9WCICHW
	xLLiytxDjBIczEoivD3iC4OEeFMSK6tSi/Lji0pzUosPMSYD/TmRWUo0OR+Y5PJK4g2NTcyM
	LI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgVFqv+y+oNjHQTs5fHsye17s
	j8ypO+vrLXfl0xm9Z3OqVT51G6zNf3zftfqr4jmhomdqu6wnfEnkZp5670zTCp13f5S/GWbY
	1QnOiFnz12HjJe1XeheFXtysX7/n30e+lsxlJ960Pn2yqvDeBh/H5xmHPjE+Pu7ElzrZ4sK1
	7IR+F2vnNU9/2dYrsRRnJBpqMRcVJwIAwohbI2gDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 06, 2013 1:51 AM, Grygorii Strashko wrote:
> On 12/05/2013 03:03 AM, Jingoo Han wrote:
> > Use devm_*() functions to make cleanup paths simpler, and remove
> > unnecessary remove().
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> >   drivers/rtc/rtc-twl.c |   38 +++++++++++++-------------------------
> >   1 file changed, 13 insertions(+), 25 deletions(-)
> >
> > diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
> > index c2e80d7..1915464 100644
> > --- a/drivers/rtc/rtc-twl.c
> > +++ b/drivers/rtc/rtc-twl.c
> > @@ -479,7 +479,7 @@ static int twl_rtc_probe(struct platform_device *pdev)
> >   	u8 rd_reg;
> >
> >   	if (irq <= 0)
> > -		goto out1;
> > +		return ret;
> >
> >   	/* Initialize the register map */
> >   	if (twl_class_is_4030())
> > @@ -489,7 +489,7 @@ static int twl_rtc_probe(struct platform_device *pdev)
> >
> >   	ret = twl_rtc_read_u8(&rd_reg, REG_RTC_STATUS_REG);
> >   	if (ret < 0)
> > -		goto out1;
> > +		return ret;
> >
> >   	if (rd_reg & BIT_RTC_STATUS_REG_POWER_UP_M)
> >   		dev_warn(&pdev->dev, "Power up reset detected.\n");
> > @@ -500,7 +500,7 @@ static int twl_rtc_probe(struct platform_device *pdev)
> >   	/* Clear RTC Power up reset and pending alarm interrupts */
> >   	ret = twl_rtc_write_u8(rd_reg, REG_RTC_STATUS_REG);
> >   	if (ret < 0)
> > -		goto out1;
> > +		return ret;
> >
> >   	if (twl_class_is_6030()) {
> >   		twl6030_interrupt_unmask(TWL6030_RTC_INT_MASK,
> > @@ -512,7 +512,7 @@ static int twl_rtc_probe(struct platform_device *pdev)
> >   	dev_info(&pdev->dev, "Enabling TWL-RTC\n");
> >   	ret = twl_rtc_write_u8(BIT_RTC_CTRL_REG_STOP_RTC_M, REG_RTC_CTRL_REG);
> >   	if (ret < 0)
> > -		goto out1;
> > +		return ret;
> >
> >   	/* ensure interrupts are disabled, bootloaders can be strange */
> >   	ret = twl_rtc_write_u8(0, REG_RTC_INTERRUPTS_REG);
> > @@ -522,34 +522,29 @@ static int twl_rtc_probe(struct platform_device *pdev)
> >   	/* init cached IRQ enable bits */
> >   	ret = twl_rtc_read_u8(&rtc_irq_bits, REG_RTC_INTERRUPTS_REG);
> >   	if (ret < 0)
> > -		goto out1;
> > +		return ret;
> >
> >   	device_init_wakeup(&pdev->dev, 1);
> >
> > -	rtc = rtc_device_register(pdev->name,
> > -				  &pdev->dev, &twl_rtc_ops, THIS_MODULE);
> > +	rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
> > +					&twl_rtc_ops, THIS_MODULE);
> >   	if (IS_ERR(rtc)) {
> > -		ret = PTR_ERR(rtc);
> >   		dev_err(&pdev->dev, "can't register RTC device, err %ld\n",
> >   			PTR_ERR(rtc));
> > -		goto out1;
> > +		return PTR_ERR(rtc);
> >   	}
> >
> > -	ret = request_threaded_irq(irq, NULL, twl_rtc_interrupt,
> > -				   IRQF_TRIGGER_RISING | IRQF_ONESHOT,
> > -				   dev_name(&rtc->dev), rtc);
> > +	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
> > +					twl_rtc_interrupt,
> > +					IRQF_TRIGGER_RISING | IRQF_ONESHOT,
> > +					dev_name(&rtc->dev), rtc);
> 
> Looks like this will change driver release order and free_irq
> will be called after RTC device is unregistered.
> I think, you need to request irq first -> then register RTC device.
> Right?

Hi Grygorii Strashko,

No, free_irq() will be called before RTC device is unregistered.

In probe(), the following functions are called as below:
  1. devm_rtc_device_register() -> rtc_device_register()
  2. devm_request_threaded_irq() -> request_threaded_irq()

The release functions will be inversely called.
When removing rtc-twl.
  1. devm_irq_release() -> free_irq()
  2. devm_rtc_device_release() -> rtc_device_unregister()

Thus, it is safe.
Thank you for your feedback. :-)

Best regards,
Jingoo Han

> 
> >   	if (ret < 0) {
> >   		dev_err(&pdev->dev, "IRQ is not free.\n");
> > -		goto out2;
> > +		return ret;
> >   	}
> >
> >   	platform_set_drvdata(pdev, rtc);
> >   	return 0;
> > -
> > -out2:
> > -	rtc_device_unregister(rtc);
> > -out1:
> > -	return ret;
> >   }
> >
> >   /*
> > @@ -559,9 +554,6 @@ out1:
> >   static int twl_rtc_remove(struct platform_device *pdev)
> >   {
> >   	/* leave rtc running, but disable irqs */
> > -	struct rtc_device *rtc = platform_get_drvdata(pdev);
> > -	int irq = platform_get_irq(pdev, 0);
> > -
> >   	mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
> >   	mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_TIMER_M);
> >   	if (twl_class_is_6030()) {
> > @@ -571,10 +563,6 @@ static int twl_rtc_remove(struct platform_device *pdev)
> >   			REG_INT_MSK_STS_A);
> >   	}
> >
> > -
> > -	free_irq(irq, rtc);
> > -
> > -	rtc_device_unregister(rtc);
> >   	return 0;
> >   }
> >
> >

