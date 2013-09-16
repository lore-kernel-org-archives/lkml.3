Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653Ab3IPRZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 13:25:45 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:62942 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab3IPRZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 13:25:42 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.101.165]
In-Reply-To: <20130916150147.GA14047@earth.universe>
References: <1379277856-24571-1-git-send-email-sre@debian.org>
	<1379277856-24571-4-git-send-email-sre@debian.org>
	<CAAwP0s0e-gYkNA78eQH7x2VJbM1byaisUeqU8YbbeWUbKwsxCQ@mail.gmail.com>
	<20130916150147.GA14047@earth.universe>
Date: Mon, 16 Sep 2013 19:25:41 +0200
Message-ID: <CABxcv==p02u8goDGJHFW0HtoPetxsRk+nmujnTqNDcGuVY0+mg@mail.gmail.com>
Subject: Re: [RFCv2 3/3] ARM: dts: N900: Add SSI information
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Javier Martinez Canillas <martinez.javier@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        =?UTF-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 5:01 PM, Sebastian Reichel <sre@debian.org> wrote:
> Hi,
>
>> Is the Synchronous Serial Interface (SSI)  only supported by
>> OMAP34xx/OMAP35xx SoC and not by OMAP36xx/OMAP37xx SoC?
>>
>> I'm asking this since if SSI is supported by both we should add the
>> device nodes in omap3.dtsi instead of omap34xx.dtsi.
>>
>> I thought that all OMAP3 SoC supported SSI and all OMAP4 SoC supported
>> HSI but I guess I was wrong...
>
> I just do not know. Information about the SSI core is not included
> in the public OMAP TRM. It only lists the memory space as reserved.
>
> Thus I only included it in OMAP34xx, which is used in Nokia N900 and
> must support SSI.
>

I see... hopefully someone from TI can shed some light on this.

> -- Sebastian
>

Best regards,
Javier
