Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab3G3SzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:55:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57740 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756758Ab3G3SzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:55:10 -0400
Message-ID: <1375210496.20048.80.camel@cumari.coelho.fi>
Subject: Re: [PATCH v2] Documentation: dt: bindings: TI WiLink modules
From: Luciano Coelho <coelho@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <mturquette@linaro.org>, <mark.rutland@arm.com>, <balbi@ti.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <linux-arm@vger.kernel.org>,
        <tony@atomide.com>, <nm@ti.com>
Date: Tue, 30 Jul 2013 21:54:56 +0300
In-Reply-To: <1551085.3MDKgN8U89@avalon>
References: <1375109728-5931-1-git-send-email-coelho@ti.com>
	 <1551085.3MDKgN8U89@avalon>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(using the new devicetree mailing list address)

On Tue, 2013-07-30 at 20:24 +0200, Laurent Pinchart wrote:
> Hi Luciano,
> 
> Thank you for the patch.
> 
> On Monday 29 July 2013 17:55:28 Luciano Coelho wrote:
> > Add device tree bindings documentation for the TI WiLink modules.
> > Currently only the WLAN part of the WiLink6, WiLink7 and WiLink8
> > modules is supported.
> > 
> > Signed-off-by: Luciano Coelho <coelho@ti.com>
> > ---
> > 
> > Changes in v2:
> > 
> > Use generic clock definitions to get the clock data instead of passing
> > the frequencies directly.  Also added definition for "internal"
> > ti,wilink-clock.
> > 
> > Please review.
> 
> The proposal looks good to me, I just have one small comment.

Cool! Thanks for the review.

[...]
> > +Example:
> > +--------
> > +
> > +Example definition that can be used in OMAP4 Panda:
> > +
> > +wlan {
> > +	compatible = "ti,wilink6";
> > +	interrupt-parent = <&gpio2>;
> > +	interrupts = <21 0x4>;	/* gpio line 53, high level triggered */
> 
> Could you please use the IRQ_TYPE_LEVEL_HIGH macro (defined in <dt-
> bindings/interrupt-controller/irq.h>) instead of the hardcode 0x4 constant ?

Ah, right, I saw this new header file recently but forgot to update my
example.  I'll update the OMAP4 Panda and OMAP4 SDP dts files I just
sent out as well.

--
Cheers,
Luca.

