Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934452AbaDJAXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 20:23:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36545 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804AbaDJAXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 20:23:49 -0400
X-AuditID: cbfee690-b7f266d00000287c-97-5345e4936406
From: Jingoo Han <jg1.han@samsung.com>
To: "'Alan Stern'" <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, kgene.kim@samsung.com,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1397016042-4451-1-git-send-email-gautam.vivek@samsung.com>
 <Pine.LNX.4.44L0.1404091430240.28384-100000@netrider.rowland.org>
In-reply-to: <Pine.LNX.4.44L0.1404091430240.28384-100000@netrider.rowland.org>
Subject: Re: [PATCH 1/2] usb: ehci-exynos: Return immediately from suspend if
 ehci_suspend fails
Date: Thu, 10 Apr 2014 09:23:48 +0900
Message-id: <001a01cf5453$243d9c70$6cb8d550$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9UIgZlejja77FnSTy6cqH6C3G9JwAMEXmg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t8zI93JT1yDDV4/0bRou3KQ3aJ58Xo2
	i8sLL7Fa9C64ymax6fE1VovLu+awWcw4v4/JYtGyVmaLCb8vsDlweuyfu4bdY/OSeo/Zd38w
	evRtWcXo8XmTXABrFJdNSmpOZllqkb5dAlfGykk/WQou8Fc0NcxmbmBczNPFyMkhIWAisfPq
	X0YIW0ziwr31bCC2kMAyRok9Dythal60nmXvYuQCik9nlPg2/RsbhPObUeLDv1dgHWwCahJf
	vhxmB7FFBHQk3uy6ANbBLNDDJPGu4xxUezejxJN1TWBVnAJ+Ei1XbrCA2MICSRLbJv1lBrFZ
	BFQlWma/B5vKK2ArcWDdCyhbUOLH5Htg9cwCWhKbtzWxQtjyEpvXvAXq5QC6VV3i0V9diCOM
	JP4+/M0OUSIise/FO0aQGyQEfrJLbDj5CGqXgMS3yYdYIHplJTYdYIZ4WVLi4IobLBMYJWYh
	2TwLyeZZSDbPQrJiASPLKkbR1ILkguKk9CITveLE3OLSvHS95PzcTYyQmJ6wg/HeAetDjMlA
	6ycyS4km5wNTQl5JvKGxmZGFqYmpsZG5pRlpwkrivGqPkoKEBNITS1KzU1MLUovii0pzUosP
	MTJxcEo1MIrwObKFb+H+FdJy7/G6x5vvSTnUMX0oN7s5e4VRw9/XwvylbJuW3DudYqmeNNVB
	6vjM3/YztdzunZef1b3JNC8k4eU8HgWxgzJvL90qnq11R/l7tazJyhPXD6aZLGZYfY3nePay
	Td2/35k9bd23e+7Wd3LtUguUrB39Ig1OrQxRZI4L/VRpaaTEUpyRaKjFXFScCAA2E2sv/wIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsVy+t9jQd3JT1yDDT6+V7Fou3KQ3aJ58Xo2
	i8sLL7Fa9C64ymax6fE1VovLu+awWcw4v4/JYtGyVmaLCb8vsDlweuyfu4bdY/OSeo/Zd38w
	evRtWcXo8XmTXABrVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqt
	kotPgK5bZg7QQUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjJWTfrIU
	XOCvaGqYzdzAuJini5GTQ0LAROJF61l2CFtM4sK99WxdjFwcQgLTGSW+Tf8G5fxmlPjw7xUb
	SBWbgJrEly+HwTpEBHQk3uy6wA5SxCzQwyTxruMcO0RHN6PEk3VNYFWcAn4SLVdusIDYwgJJ
	Etsm/WUGsVkEVCVaZr8Hm8orYCtxYN0LKFtQ4sfke2D1zAJaEpu3NbFC2PISm9e8BerlALpV
	XeLRX12II4wk/j78zQ5RIiKx78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddQ
	rzgxt7g0L10vOT93EyM4ZTyT2sG4ssHiEKMAB6MSD++BZa7BQqyJZcWVuYcYJTiYlUR4p5wG
	CvGmJFZWpRblxxeV5qQWH2JMBnp0IrOUaHI+MJ3llcQbGpuYGVkamVkYmZibkyasJM57oNU6
	UEggPbEkNTs1tSC1CGYLEwenVAOjhmuOfZFmtjTzIq7H90r7Y1s2Svzrqp8X8+H/3Aj/VOs0
	nStyiQt9ZmiafJnBuZb5EcfmMNGKn51C0db62R7SP2Y4uZ+4H7g9i+/Gq5w3EfPLPjPmmwja
	i/hs+/Vgz3V9q7dRsxpZKgssTVd8Xfe9aq9jCeefJdu7rT+y+rfPM/pd/MsnWVuJpTgj0VCL
	uag4EQB4nTqMXQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 10, 2014 3:32 AM, Alan Stern wrote:
> On Wed, 9 Apr 2014, Vivek Gautam wrote:
> 
> > Patch 'b8efdaf USB: EHCI: add check for wakeup/suspend race'
> > adds a check for possible race between suspend and wakeup interrupt,
> > and thereby it returns -EBUSY as error code if there's a wakeup
> > interrupt.
> > So the platform host controller should not proceed further with
> > its suspend callback, rather should return immediately to avoid
> > powering down the essential things, like phy.
> >
> > Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> > Cc: Alan Stern <stern@rowland.harvard.edu>
> > Cc: Jingoo Han <jg1.han@samsung.com>
> > ---
> >
> > Based on 'usb-next' branch of Greg's usb tree.
> >
> >  drivers/usb/host/ehci-exynos.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/usb/host/ehci-exynos.c b/drivers/usb/host/ehci-exynos.c
> > index d1d8c47..a4550eb 100644
> > --- a/drivers/usb/host/ehci-exynos.c
> > +++ b/drivers/usb/host/ehci-exynos.c
> > @@ -212,6 +212,8 @@ static int exynos_ehci_suspend(struct device *dev)
> >  	int rc;
> >
> >  	rc = ehci_suspend(hcd, do_wakeup);
> > +	if (rc)
> > +		return rc;
> >
> >  	if (exynos_ehci->otg)
> >  		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
> > @@ -221,7 +223,7 @@ static int exynos_ehci_suspend(struct device *dev)
> >
> >  	clk_disable_unprepare(exynos_ehci->clk);
> >
> > -	return rc;
> > +	return 0;
> >  }
> >
> >  static int exynos_ehci_resume(struct device *dev)
> 
> The first hunk of this patch is correct, but the second hunk isn't
> needed.  A similar remark is true for the ehci-platform patch.

Hi Alan,

Do you mean the following?

1st hunk
 +	if (rc)
 +		return rc;

2nd hunk
 -	return rc;
 +	return 0;

Currently, the 'rc' will be always 'zero'; however, I don't
Have any objection, because the code might be  modified later.

Best regards,
Jingoo Han
> 
> Alan Stern

