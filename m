Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438Ab3LDNh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 08:37:59 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39901 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506Ab3LDNh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 08:37:57 -0500
X-AuditID: cbfec7f4-b7f966d0000003d9-9f-529f30322d3b
Message-id: <1386164272.6195.3.camel@AMDC1943>
Subject: Re: [PATCH v6 3/3] mfd: max14577: Add device tree bindings document
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
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
Date: Wed, 04 Dec 2013 14:37:52 +0100
In-reply-to: <20131204112039.GC907@lee--X1>
References: <1386153615-25456-1-git-send-email-k.kozlowski@samsung.com>
 <1386153615-25456-4-git-send-email-k.kozlowski@samsung.com>
 <20131204112039.GC907@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLIsWRmVeSWpSXmKPExsVy+t/xK7pGBvODDK62aVoc3KppsXHGelaL
	qQ+fsFlc//Kc1WL+kXOsFhNXTma2OPdqJaPF2aY37Bb3vx5ltPh2pYPJYtPja6wWC9uWsFhc
	3jWHzWLtkbvsFkuvX2SymDB9LYvF4RUHmCzWvZzOYvHqYBuLg7DHmnlrGD0WfL7C7jGh/xOj
	x85Zd9k9Vi7/wuaxeYWWx6ZVnWwer1bPZPW4c20PUGhJvUffllWMHp83yXlsnBsawBvFZZOS
	mpNZllqkb5fAlfFlC19Bl2jF+fv3WRoYnwt0MXJySAiYSGzqnsEIYYtJXLi3nq2LkYtDSGAp
	o8SPJcuZIJzPjBLT1rwHquLg4BXQk1h8XRWkQVjAR6LxzBtmEJtNwFhi8/IlbCAlIgIqEufe
	mIO0MgvsYJVY1r6JBaSGRUBVYvPuJawgNqeAtsTUmVeh5i9jlJh09DxYEbOAusSkeYuYIS5S
	ktjd3skOEZeX2LzmLVicV0BQ4sfkeywTGAVmIWmZhaRsFpKyBYzMqxhFU0uTC4qT0nMN9YoT
	c4tL89L1kvNzNzFCovTLDsbFx6wOMQpwMCrx8HKwzwsSYk0sK67MPcQowcGsJMK7XHd+kBBv
	SmJlVWpRfnxRaU5q8SFGJg5OqQZGI9tVk/aZ+RfMmP/qS9gxrxu3dJWzPi2LO+fnWyH9d/3/
	oBnBoqY9rqbrQ5+ZGtT+27/ixTtlxomfXC/sDl65ZfZfh7deopHP8j9vX/5s2dTXs6WOTWRX
	rcs7eES68YfTl6SjWYs3J54+cfP6Ut+Lat8L16/9uVz7Q+W/zNxEGcsDTYlrVpbmliuxFGck
	GmoxFxUnAgApXfMcsAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-04 at 11:20 +0000, Lee Jones wrote:
> > Add document describing device tree bindings for MAX14577 MFD driver.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  Documentation/devicetree/bindings/mfd/max14577.txt |   48 ++++++++++++++++++++
> >  1 file changed, 48 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/mfd/max14577.txt b/Documentation/devicetree/bindings/mfd/max14577.txt
> > new file mode 100644
> > index 000000000000..f4fd16360b6b
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/mfd/max14577.txt
> > @@ -0,0 +1,48 @@
> > +MAXIM MAX14577 multi-function device
> 
> Why is Maxim capitalised in such a way?
> 
> If you're going to use the term Multi-Function Device, please
> capitalise it.
> 
> > +MAX14577 is a Multi-function device with Micro-USB Interface Circuit, Li+
> 
> Same here.

I'll fix this. The MAXIM capitalization came from other drivers.

> > +Battery Charger and SFOUT LDO output for powering USB devices. It is
> > +interfaced to host controller using I2C.
> > +
> > +Required properties:
> > +- compatible : Must be "maxim,max14577".
> > +- reg : I2C slave address for the max14577 chip.
> > +- interrupts : IRQ line for the max14577 chip.
> > +- interrupt-parent :  The parent interrupt controller.
> > +
> > +Optional nodes:
> > +- regulators :
> > +  Required child node properties:
> > +  - compatible : "maxim,max14577-regulator"
> > +
> > +  Optional child nodes:
> > +    Each child node representing a regulator, following standard regulator
> > +    bindings. Valid names for a regulator are: "CHARGER" and "SAFEOUT".
> > +    The SAFEOUT is a constant voltage regulator so there is no need
> 
> s/constant/fixed
OK.

> > +    to specify voltages for it.
> 
> The whole of the "Optional nodes" explaination isn't as clear as it
> could otherwise be. 
> 
> > +	[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
> > +
> > +Example:
> > +	max14577@25 {
> > +		compatible = "maxim,max14577";
> > +		reg = <0x25>;
> > +		interrupt-parent = <&gpx1>;
> > +		interrupts = <5 0>;
> 
> I'm gussing this is IRQ5 and the 0 is flags? If so, please use
> #defines for the flags.

This is a standard interrupt binding. The max14577 MFD core driver
ignores the interrupt flags and always uses IRQF_TRIGGER_FALLING. I can
fix this with new patch for drivers/mfd/max14577.c but still I don't see
what should be added in documentation.


Best regards,
Krzysztof

