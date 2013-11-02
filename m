Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab3KBRxG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 13:53:06 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:42663 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab3KBRxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 13:53:01 -0400
Date: Sat, 2 Nov 2013 13:52:56 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH v2 5/9] usb: gadget: s3c-hsotg: enable generic phy support
Message-ID: <20131102175256.GF17505@beef>
References: <1383335158-19730-1-git-send-email-matt.porter@linaro.org>
 <1383335158-19730-6-git-send-email-matt.porter@linaro.org>
 <1868561.m5DoOTCY2U@flatron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1868561.m5DoOTCY2U@flatron>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 02, 2013 at 02:09:21PM +0100, Tomasz Figa wrote:
> Hi Matt.
> 
> On Friday 01 of November 2013 15:45:54 Matt Porter wrote:
> > Adds support for the generic PHY subsystem. Generic PHY
> > support is probed and then the driver falls back to checking
> > for an old style USB PHY and pdata if not found.
> > 
> > Signed-off-by: Matt Porter <matt.porter@linaro.org>
> > ---
> >  drivers/usb/gadget/s3c-hsotg.c | 54
> > ++++++++++++++++++++++++++++-------------- 1 file changed, 36
> > insertions(+), 18 deletions(-)
> 
> Patches that convert the driver to generic PHY have been already posted by 
> Kamil Debski, as a part of a series[1] adding generic PHY drivers for S5P 
> and Exynos SoCs. After that series, there will be no need to support the 
> usb_phy subsystem in this driver anymore.
> 
> [1] http://www.mail-archive.com/linux-usb@vger.kernel.org/msg31189.html

Very nice...embarassing I somehow missed that last week. I deliberately
avoided removing that USB PHY support simply because I wanted to leave
the Samsung phy conversions to somebody else with hardware to test. ;)

I'll drop this patch and rebase on top of that series...thanks for
pointing it out.

-Matt
