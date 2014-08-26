Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934280AbaHZJd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:33:26 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:52953 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787AbaHZJdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:33:22 -0400
Date: Tue, 26 Aug 2014 10:33:12 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Arnaud Ebalard <arno@natisbad.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jonathan Cameron <jic23@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        LINUX ARM KERNEL <linux-arm-kernel@lists.infradead.org>,
        LINUX KERNEL <linux-kernel@vger.kernel.org>,
        LINUX SH <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Mark Brown <broonie@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin Fuzzey <mfuzzey@parkeon.com>, Pawel Moll <pawel.moll@arm.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Silvio F <silvio.fricke@gmail.com>, Simon Horman <horms@verge.net.au>,
        Support Opensource <support.opensource@diasemi.com>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [RESEND PATCH V2] devicetree: Dialog Semiconductor consolidate
 existing vendor prefixes to standardise on 'dlg'
Message-ID: <20140826093312.GI9574@lee--X1>
References: <201408221446.s7MEkNVF001775@swsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201408221446.s7MEkNVF001775@swsrvapps-01.diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014, Opensource [Steve Twiss] wrote:
> From: Steve Twiss <stwiss.opensource@diasemi.com>
> 
> This patch series updates the device tree vendor prefix for
> Dialog Semiconductor.
> 
> Various methods are currently used throughout the kernel: 'diasemi',
> 'dialog' and 'dlg'. Others have also been suggested.
> 
> This patch set aims to consolidate the usage of the vendor prefix to
> use a common standard. The prefix 'dlg' is used.
> 
> Acked-by: Simon Horman <horms+renesas@verge.net.au>
> Acked-by: Rob Herring <robh@kernel.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Acked-by: Shawn Guo <shawn.guo@freescale.com>
> 
> Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>
> 
> ---

[...]

> Hi Lee,
> 
> This is a resend according to requests for e-mail reformatting and removal
> of '[]' in From: and Signed-off-by: tags. There are no patch alterations
> from RFC V2.
> 
> I have got the Ack for the two remaining files r8a7790-lager.dts and
> r8a7791-koelsch.dts because of the previous request for SHMobile to Ack
> their part of the patch.
> - http://www.spinics.net/lists/arm-kernel/msg349289.html
> - https://lkml.org/lkml/2014/6/11/273
> 
> I think this is it. But, if I am missing anything or there are problems, can
> I get a quick explanation in the reply so I can fix it and move forwards
> please?
> 
> In full:
> Acked-by the following people so far:

When you say "so far", does that mean you're missing Acks still?

If you have the full-set I will apply this and send out the necessary
pull-request(s).

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
