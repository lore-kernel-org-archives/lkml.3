Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbaH2Ktm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 06:49:42 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51267 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751678AbaH2Ktk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 06:49:40 -0400
Date: Fri, 29 Aug 2014 11:49:04 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Matti Vaittinen <matti.vaittinen@nsn.com>
Cc: "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "arno@natisbad.org" <arno@natisbad.org>,
        "jgunthorpe@obsidianresearch.com" <jgunthorpe@obsidianresearch.com>,
        "san@rosetechnology.dk" <san@rosetechnology.dk>,
        "hs@denx.de" <hs@denx.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Sverdlin Alexander <alexander.sverdlin@nsn.com>
Subject: Re: [PATCH v2] rtc: ds1307: add trickle charger device tree binding
Message-ID: <20140829104904.GA21473@leverpostej>
References: <20140829112902.GA14650@fi-ourus-dhcp00977.emea.nsn-net.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140829112902.GA14650@fi-ourus-dhcp00977.emea.nsn-net.net>
Thread-Topic: [PATCH v2] rtc: ds1307: add trickle charger device tree binding
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mati,

Looks like my last reply [1] raced with this posting.

[...]

> +Optional properties:
> +- trickle : Used Trickle Charger configuration,
> +	corresponding to 4 lowest bits in trickle charger register.
> +	Following values are specified:
> +		0x5 => No diode, 250 ohm
> +		0x9 => Diode, 250 ohm
> +		0x6 => No diode, 2k ohm
> +		0xa => Diode, 2k ohm
> +		0x7 => No diode, 4k ohm
> +		0xb => Diode, 4k ohm

Optional?

For an optional property, please describe when said property should be
present, and what the absence implies.

Usually something like "should be present if $foo is not implemented in
$such_way", so it's obvious what the behaviour should be either way.

I still think this should be two proeprties and that the driver should
handle that as appropriate, as I mentioned in my last reply [1].

Mark.

[1] http://lkml.kernel.org/r/20140829104001.GB19424@leverpostej
