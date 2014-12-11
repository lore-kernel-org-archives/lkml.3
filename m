Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735AbaLKKnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 05:43:42 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:25361 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbaLKKnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 05:43:40 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-7d-5489755af768
From: Kamil Debski <k.debski@samsung.com>
To: "'Vivek Gautam'" <gautamvivek1987@gmail.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: linux-kernel@vger.kernel.org,
        "'Linux USB Mailing List'" <linux-usb@vger.kernel.org>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>
References: <1415787893-21857-1-git-send-email-gautam.vivek@samsung.com>
 <CAFp+6iGrv8rhGf7QkOi=2Ad+ZFPMpVn84hjNa9TiNWHFcWKLeg@mail.gmail.com>
In-reply-to: <CAFp+6iGrv8rhGf7QkOi=2Ad+ZFPMpVn84hjNa9TiNWHFcWKLeg@mail.gmail.com>
Subject: RE: [PATCH] phy: phy-samsung-usb2: Don't use same name for driver name
 and global structure
Date: Thu, 11 Dec 2014 11:43:36 +0100
Message-id: <016101d0152f$52197270$f64c5750$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AdAVC9SiJwUvotc5RoCADAxPIx7AZQAInemw
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t/xa7pRpZ0hBo8btC3arhxkt3j7fQu7
	xYWnPWwWl3fNYbNYtKyV2YHVY+esu+wefVtWMXocv7GdyePzJrkAligum5TUnMyy1CJ9uwSu
	jBdnzzAX/BWpuDj/JEsD4z2BLkZODgkBE4mJL96xQ9hiEhfurWfrYuTiEBJYyigxa9ZuKKeB
	SWLe9zXMXYwcHGwCmhKr7nmANIgIREksP9HHCFLDLNDKKDFp4QZGiIZ+Rokr/Q1MIFWcAsES
	yzZuZwOxhQXSJPZdncEMYrMIqEp8+v0fzOYVcJBY2/sWyhaU+DH5HgvIMmYBdYkpU3JBwswC
	8hKb17wFu0ECKPzory7EDUYS6z+fZYMoEZG42/CcdQKj0Cwkg2YhDJqFZNAsJB0LGFlWMYqm
	liYXFCel5xrpFSfmFpfmpesl5+duYoREw9cdjEuPWR1iFOBgVOLhzYjvDBFiTSwrrsw9xCjB
	wawkwmsVARTiTUmsrEotyo8vKs1JLT7EyMTBKdXAuGGnyJ6/q2d/m1MRomU0/c6H6G1RAoKu
	v0PfzUhRP8nLYO6lsVn26+zpdwPnGk3w1e7tnBd9Od1u7XWWiIBzPNe/eszZVRAnqyjG+00x
	aQMLW+ih7keGtV+Oz5Y4yMSoyBeVt6ifoZN1pc35Sa+yGs5bzfwf6N9wJLQ47kJQzg+eiBfM
	NZe5lFiKMxINtZiLihMBjHUoNGQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> From: Vivek Gautam [mailto:gautamvivek1987@gmail.com]
> Sent: Thursday, December 11, 2014 7:30 AM
> To: Kishon Vijay Abraham I; Kamil Debski
> Cc: linux-kernel@vger.kernel.org; Linux USB Mailing List; Vivek Gautam
> Subject: Re: [PATCH] phy: phy-samsung-usb2: Don't use same name for
> driver name and global structure
> 
> On Wed, Nov 12, 2014 at 3:54 PM, Vivek Gautam <gautam.vivek@samsung.com>
> wrote:
> > Using the same driver name for platform driver and a globally defined,
> > structure used throughout the file, looks a bit unpleasing.
> > So changing the driver name from "samsung_usb2_phy_driver" to
> > "samsung_usb2_phy"
> >
> > Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> > Cc: Kamil Debski <k.debski@samsung.com>
> > Cc: Kishon Vijay Abraham I <kishon@ti.com>
> > ---
> 
> Although just a trivial change, does it look valid ?

I can agree that the naming of this variable is a bit unfortunate.
Changing name of samsung_usb2_phy_driver to samsung_usb2_phy is, as
you said, a minor change and does not change how the driver works.

Acked-by: Kamil Debski <k.debski@samsung.com>

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

> 
> >  drivers/phy/phy-samsung-usb2.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/phy/phy-samsung-usb2.c b/drivers/phy/phy-
> samsung-usb2.c
> > index 908949d..2934fb7 100644
> > --- a/drivers/phy/phy-samsung-usb2.c
> > +++ b/drivers/phy/phy-samsung-usb2.c
> > @@ -226,7 +226,7 @@ static int samsung_usb2_phy_probe(struct
> platform_device *pdev)
> >         return 0;
> >  }
> >
> > -static struct platform_driver samsung_usb2_phy_driver = {
> > +static struct platform_driver samsung_usb2_phy = {
> >         .probe  = samsung_usb2_phy_probe,
> >         .driver = {
> >                 .of_match_table = samsung_usb2_phy_of_match,
> > @@ -234,7 +234,7 @@ static struct platform_driver
> samsung_usb2_phy_driver = {
> >         }
> >  };
> >
> > -module_platform_driver(samsung_usb2_phy_driver);
> > +module_platform_driver(samsung_usb2_phy);
> >  MODULE_DESCRIPTION("Samsung S5P/EXYNOS SoC USB PHY driver");
> >  MODULE_AUTHOR("Kamil Debski <k.debski@samsung.com>");
> >  MODULE_LICENSE("GPL v2");
> > --
> > 1.7.10.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 
> --
> Best Regards
> Vivek Gautam
> Samsung R&D Institute, Bangalore
> India

