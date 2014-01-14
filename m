Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaANKQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 05:16:53 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:53969 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaANKQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 05:16:45 -0500
MIME-Version: 1.0
In-Reply-To: <52CC6782.4060309@broadcom.com>
References: <1386787041-6035-1-git-send-email-syin@broadcom.com>
	<1387592016-13740-1-git-send-email-syin@broadcom.com>
	<1387592016-13740-3-git-send-email-syin@broadcom.com>
	<CACRpkdaAq15wKD900SqN1sQFLBATiuA3vNoua+KJGHU+gdCgqg@mail.gmail.com>
	<52CC6782.4060309@broadcom.com>
Date: Tue, 14 Jan 2014 11:16:45 +0100
Message-ID: <CACRpkdYyz+zrzt0y135Wcq-yUMhiHOb1ov15+SsnVOcZvad96g@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] pinctrl: Add pinctrl binding for Broadcom Capri SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: Sherman Yin <syin@broadcom.com>
Cc: Mark Brown <broonie@kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 7, 2014 at 9:45 PM, Sherman Yin <syin@broadcom.com> wrote:
> On 14-01-07 09:15 AM, Linus Walleij wrote:

> Is that what you wanted to see in pinctrl-bindings.txt, or is there
> something else you want to see added to that txt file?  I didn't want to add
> the description of slew-rate arguments there because this is capri-specific.
> I'm not quite sure what else to add.
(...)
> That doc already says bias-pull-up is specified in Ohm, and the specific
> values are chip-specific, so I don't think they should be mentioned there.

You're right, forget about this. I didn't realize the pinctrl bindings doc
was that good...

>>> +Optional Properties (for HDMI pins):
>>> +
>>> +- function:                    String. Specifies the pin mux selection.
>>> Values
>>> +                               must be one of: "alt1", "alt2", "alt3",
>>> "alt4"
>>> +- slew-rate:                   Integer. Controls slew rate.
>>> +                                       0: Standard(100kbps)&
>>> Fast(400kbps) mode
>>> +                                       1: Highspeed (3.4Mbps) mode
>>
>> Hmmmm slew rate is not specifiec in "bps" but rather in
>> something like volts per second. But maybe it's best to keep
>> this value driver-specific.
>
> Right, I think the slew-rates values are capri specific.

OK

Yours,
Linus Walleij
