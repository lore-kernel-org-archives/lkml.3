Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab3LDNmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 08:42:11 -0500
Received: from mail-yh0-f47.google.com ([209.85.213.47]:54383 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab3LDNmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 08:42:08 -0500
Date: Wed, 4 Dec 2013 13:41:56 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH v6 3/3] mfd: max14577: Add device tree bindings document
Message-ID: <20131204134156.GA25422@lee--X1>
References: <1386153615-25456-1-git-send-email-k.kozlowski@samsung.com>
 <1386153615-25456-4-git-send-email-k.kozlowski@samsung.com>
 <20131204112039.GC907@lee--X1>
 <1386164272.6195.3.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1386164272.6195.3.camel@AMDC1943>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +MAXIM MAX14577 multi-function device
> > 
> > Why is Maxim capitalised in such a way?
> > 
> > If you're going to use the term Multi-Function Device, please
> > capitalise it.
> > 
> > > +MAX14577 is a Multi-function device with Micro-USB Interface Circuit, Li+
> > 
> > Same here.
> 
> I'll fix this. The MAXIM capitalization came from other drivers.

No need to repeat mistakes. I believe it should be Maxim.

> > > +Example:
> > > +	max14577@25 {
> > > +		compatible = "maxim,max14577";
> > > +		reg = <0x25>;
> > > +		interrupt-parent = <&gpx1>;
> > > +		interrupts = <5 0>;
> > 
> > I'm gussing this is IRQ5 and the 0 is flags? If so, please use
> > #defines for the flags.
> 
> This is a standard interrupt binding. The max14577 MFD core driver
> ignores the interrupt flags and always uses IRQF_TRIGGER_FALLING. I can
> fix this with new patch for drivers/mfd/max14577.c but still I don't see
> what should be added in documentation.

s/0/IRQ_TYPE_NONE

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
