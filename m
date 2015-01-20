Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbbATK32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:29:28 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:54212 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbbATK30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:29:26 -0500
Date: Tue, 20 Jan 2015 10:29:19 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/3] mfd: lubbock_io: add lubbock_io board
Message-ID: <20150120102919.GP5767@x1>
References: <1421406010-14851-1-git-send-email-robert.jarzmik@free.fr>
 <1421406010-14851-2-git-send-email-robert.jarzmik@free.fr>
 <20150119091705.GG21886@x1>
 <87ppaah9k5.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ppaah9k5.fsf@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2015, Robert Jarzmik wrote:
> Lee Jones <lee.jones@linaro.org> writes:
> > On Fri, 16 Jan 2015, Robert Jarzmik wrote:

[...]

> >> +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> >
> > platform_get_irq()?
> No. I need the flags.

Where are they used?

[...]

> >> +	if (ret) {
> >> +		dev_err(&pdev->dev, "Couldn't request main irq : ret = %d\n",
> >> +			ret);
> >
> > I'm not keen on this type of formatting.  Besides the system will
> > print out the returned error on failure.
> Well, it will print -EINVAL or -ENODEV. When I'll receive an request on the
> driver with -ENODEV, how will I know it will come from this request_irq() or
> another part of the code ... Well I can remove it if you want, but I think it's
> an error.

I'm not asking you to remove the entire message, just the junk at the
end.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
