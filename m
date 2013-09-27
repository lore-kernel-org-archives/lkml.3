Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab3I0NsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:48:22 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:49049 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab3I0NsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:48:16 -0400
MIME-Version: 1.0
In-Reply-To: <52458631.7030401@nvidia.com>
References: <1380044845-7734-1-git-send-email-ldewangan@nvidia.com>
	<CACRpkdZc2SGhUJUjVqen3tX5sqfm=PthK42ustAmoWwBsWzHPQ@mail.gmail.com>
	<52458631.7030401@nvidia.com>
Date: Fri, 27 Sep 2013 15:48:15 +0200
Message-ID: <CACRpkdY5DeXSJ+RTyPtfDJG=x=M7KsybsBT3e=D_YLksi0DSEw@mail.gmail.com>
Subject: Re: [rtc-linux] Re: [PATCH V4 2/3] pincntrl: add support for AMS
 AS3722 pin control driver
From: Linus Walleij <linus.walleij@linaro.org>
To: "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Rob Landley <rob@landley.net>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 3:20 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> On Friday 27 September 2013 06:10 PM, Linus Walleij wrote:
>>
>> On Tue, Sep 24, 2013 at 7:47 PM, Laxman Dewangan <ldewangan@nvidia.com>
>> wrote:
>>
>>> function which just return not supported.
>>> - Nit cleanups.
>>
>> This is getting a lot better quickly.
>>
>> I'd like someone from devicetree@vger.kernel.org to say
>> something about the DT bindings, can you convince one of
>> the DT custodians to ACK this?
>
> I will request Stephen to review this.

OK I buy the rest of your explantions and I'm ready to merge
this if the device tree people give green light.

Yours,
Linus Walleij
