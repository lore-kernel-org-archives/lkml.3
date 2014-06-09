Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbaFIL5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 07:57:24 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57611 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbaFIL5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 07:57:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140606152840.GV24240@lee--X1>
References: <1382427526-2390-1-git-send-email-ldewangan@nvidia.com>
	<20140606152840.GV24240@lee--X1>
Date: Mon, 9 Jun 2014 13:57:16 +0200
Message-ID: <CACRpkdYPxPo2VPS=7-5UKWVJuQaZBV8JVGnfLQb=FxeemiCBgA@mail.gmail.com>
Subject: Re: [PATCH V5 REPOST] mfd: add support for ams AS3722 PMIC
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Rob Landley <rob@landley.net>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Florian Lobmaier <florian.lobmaier@ams.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2014 at 5:28 PM, Lee Jones <lee.jones@linaro.org> wrote:

>> +     as3722->en_intern_int_pullup = of_property_read_bool(np,
>> +                                     "ams,enable-internal-int-pullup");
>> +     as3722->en_intern_i2c_pullup = of_property_read_bool(np,
>> +                                     "ams,enable-internal-i2c-pullup");
>
> These are still not documented.  Can you please do so?

...and these look an awful lot like some pin config shoehorned
silently into the MFD subsystem.

There *are* cases where a complete pin control driver for some
IP is overkill though, I'm worried if this is some generic disease
with this driver :-/

Yours,
Linus Walleij
