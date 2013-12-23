Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab3LWQbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:31:06 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:61534 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247Ab3LWQbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:31:03 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-24-52b86543d8f1
From: Tomasz Figa <t.figa@samsung.com>
To: balbi@ti.com
Cc: Matt Porter <mporter@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>,
        Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dinh Nguyen <dinh.linux@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH v8 3/9] usb: gadget: s3c-hsotg: enable build for other
 platforms
Date: Mon, 23 Dec 2013 17:30:41 +0100
Message-id: <1831289.ILfyABDFji@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.3 (Linux/3.11.5-gentoo; KDE/4.11.3; x86_64; ; )
In-reply-to: <20131223162557.GC28679@saruman.home>
References: <1387462990-12039-1-git-send-email-mporter@linaro.org>
 <1387462990-12039-4-git-send-email-mporter@linaro.org>
 <20131223162557.GC28679@saruman.home>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t/xy7rOqTuCDB6v1bE4eL/e4lfjSiaL
	+UfOsVqsPKlt0f9mIatF8+L1bBbnXq1ktPjx+gKbxYWnPWwWZ5vesFtsenyN1eLyrjlsFouW
	tTJb3L7Ma7H0+kUmizlrtS2mHP7CYrF9ynQmiwnT17JYHF5xgMlBxGPNvDWMHi3NPWweCz5f
	Yfe43NfL5LF2+REWj52z7rJ7rFz+hc3jzrU9bB77565h99i8pN6jb8sqRo8t+z8zehy/sZ3J
	4/MmuQC+KC6blNSczLLUIn27BK6MR7ddCiZyVmxsXs/YwLiOvYuRk0NCwETi9b/lrBC2mMSF
	e+vZuhi5OIQEljJKfLv7iAXC6WKSWDtrEyNIFZuAmsTnhkdsILaIgIDE+heX2EGKmAU2s0nc
	nDgLbKywQJjE7A1/WUBsFgFViZ7Ns5hBbF4BTYmuBZ1gcX4BdYl3254ygdiiAm4SL/ZtAevl
	FDCSWPP9HSPE5sWMEtOaFjFBNAtK/Jh8D6yZWUBeYt/+qawQtpbE+p3HmSYwCs5CUjYLSdks
	JGULGJlXMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoTE9NcdjEuPWR1iFOBgVOLhTWjbHiTE
	mlhWXJl7iFGCg1lJhPddzI4gId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYw3Jx6edlGr/77Gmkw/
	XWvtkpPCTDvCzyw9d8Nwhvx+63Spmsdrq3fO0v/K4hnzNDY0SFd9YbVGeHX2U7fkiq7Deu78
	5xPlJSx9mC/E5J968lv8m/P+u09vTGi6erSl021dWf9FoaaPJUJNFrnb2NVOKizdlZ1etaz6
	XvyimhDDY1t7t51ROq/EUpyRaKjFXFScCACNl2fvxwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 of December 2013 10:25:57 Felipe Balbi wrote:
> On Thu, Dec 19, 2013 at 09:23:04AM -0500, Matt Porter wrote:
> > Remove unused Samsung-specific machine include and Kconfig
> > dependency on S3C.
> > 
> > Signed-off-by: Matt Porter <mporter@linaro.org>
> > Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> > Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
> > ---
> >  drivers/usb/gadget/Kconfig     | 7 +++----
> >  drivers/usb/gadget/s3c-hsotg.c | 2 --
> >  2 files changed, 3 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> > index a91e642..181e760 100644
> > --- a/drivers/usb/gadget/Kconfig
> > +++ b/drivers/usb/gadget/Kconfig
> > @@ -294,11 +294,10 @@ config USB_PXA27X
> >  	   gadget drivers to also be dynamically linked.
> >  
> >  config USB_S3C_HSOTG
> > -	tristate "S3C HS/OtG USB Device controller"
> > -	depends on S3C_DEV_USB_HSOTG
> > +	tristate "Designware/S3C HS/OtG USB Device controller"
> 
> causes build failure in x86. Sorry dropping from my queue.

Maybe depends on ARM would be a good enough stepping stone?

Best regards,
Tomasz

