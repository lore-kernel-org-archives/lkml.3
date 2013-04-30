Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab3D3CSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 22:18:37 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:39849 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3D3CSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 22:18:35 -0400
X-AuditID: cbfee691-b7fe56d000004b96-e8-517f29fae443
From: Jingoo Han <jg1.han@samsung.com>
To: "'Guenter Roeck'" <linux@roeck-us.net>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <001101ce44bd$0a0105f0$1e0311d0$@samsung.com>
 <20130429180957.GG5183@roeck-us.net>
In-reply-to: <20130429180957.GG5183@roeck-us.net>
Subject: Re: [PATCH RESEND 7/7] watchdog: ts72xx_wdt: use devm_*() functions
Date: Tue, 30 Apr 2013 11:18:33 +0900
Message-id: <000701ce4549$03cc1a80$0b644f80$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQH2sAmsi+8vjQwEHyvFXIz+VnEJTQHmRA7ImI3/G3A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t8zA91fmvWBBktvcFjMWb+GzeLywkus
	Fpd3zWGzuLFuH7vFk4VnmCx2r1zCYnFrxgtWB3aPvilX2TyubRbzODHjN4vHzu8NQKEtqxg9
	Pm+SC2CL4rJJSc3JLEst0rdL4MrYtmQPc8Ee8YpNC14xNjDeEOpi5OSQEDCRmH6yiwXCFpO4
	cG89WxcjF4eQwDJGicWrrrLBFD25+4UZxBYSmM4oMfu3HUTRL0aJKc9WM4Ik2ATUJL58OcwO
	YosIaEhcnzKHEaSIWeADo8T0pb2MEN0JElc+/QGbyilgKNHx7zjYamEBH4mVe46DbWARUJXY
	MWUdWD2vgKXEuglHmSFsQYkfk++B1TMLaEms33mcCcKWl9i85i0zxKUKEjvOvgbq5QA6wkpi
	035fiBIRiX0v3jFClHxkl9hwSwRilYDEt8mHWEDKJQRkJTYdgJoiKXFwxQ2WCYwSs5AsnoVk
	8Swki2ch2bCAkWUVo2hqQXJBcVJ6kalecWJucWleul5yfu4mRkgUT9zBeP+A9SHGZKD1E5ml
	RJPzgUkgryTe0NjMyMLUxNTYyNzSjDRhJXFe9RbrQCGB9MSS1OzU1ILUovii0pzU4kOMTByc
	Ug2MWXuD5Gf//c7R+/D7vgaDGYVf+G2yZSdkCGkJN32ue/qlPGyi7NZPkgHcvnmblDyeioof
	c5sqGSo8bfXKglMCLSv/Lnc8HHHwUmiFyNvE/YHKhwP13+kzHuhQlktomn/j6BfVu2abXrwL
	q5SUvCey1lty3zqDaL5Zv147TZgcdMoqzy3K3aZZiaU4I9FQi7moOBEA5vkHG/gCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t9jQd1fmvWBBn8vMFvMWb+GzeLywkus
	Fpd3zWGzuLFuH7vFk4VnmCx2r1zCYnFrxgtWB3aPvilX2TyubRbzODHjN4vHzu8NQKEtqxg9
	Pm+SC2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXL
	zAG6RUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYsW3JHuaCPeIVmxa8
	YmxgvCHUxcjJISFgIvHk7hdmCFtM4sK99WwgtpDAdEaJ2b/tuhi5gOxfjBJTnq1mBEmwCahJ
	fPlymB3EFhHQkLg+ZQ4jSBGzwAdGielLexkhuhMkrnz6AzaJU8BQouPfcRYQW1jAR2LlnuNg
	21gEVCV2TFkHVs8rYCmxbsJRZghbUOLH5Htg9cwCWhLrdx5ngrDlJTaveQt1qYLEjrOvgXo5
	gI6wkti03xeiRERi34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFp
	Xrpecn7uJkZwkngmtYNxZYPFIUYBDkYlHt4dS+oChVgTy4orcw8xSnAwK4nw1vHWBwrxpiRW
	VqUW5ccXleakFh9iTAZ6dCKzlGhyPjCB5ZXEGxqbmBlZGplZGJmYm5MmrCTOe6DVOlBIID2x
	JDU7NbUgtQhmCxMHp1QDo4XU6e+3puXM0WhadKhqeeM3wabDDCw7Fn5gNdxXXix6ssNdca4C
	69yaaWIrD61g+qGW6j3988+jEzeIJB9ezi6yoltg5Q3uquv3p3g+6FdpF7ea9dcgcv6cxWV3
	FT97Knw5khG1QqhCVM84UraMfZ9t+LXsedm3N10M6ms8oK6cevzyGRf2/0osxRmJhlrMRcWJ
	ABUMLYJWAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 30, 2013 3:10 AM, Guenter Roeck wrote:
> On Mon, Apr 29, 2013 at 06:36:34PM +0900, Jingoo Han wrote:
> > Use devm_*() functions to make cleanup paths simpler.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
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
> You have a mix of returns with and without error messages now. Can you make sure
> that this is all consistent ?

As I previously mentioned, there is no need to add an error message.
(http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg426498.html)

Best regards,
Jingoo Han

> 
> Thanks,
> Guenter

