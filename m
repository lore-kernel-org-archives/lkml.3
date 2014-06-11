Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbaFKOWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 10:22:31 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:38807 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaFKOW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 10:22:28 -0400
MIME-Version: 1.0
In-Reply-To: <2E89032DDAA8B9408CB92943514A0337A56F53A6@SW-EX-MBX01.diasemi.com>
References: <cover.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
	<bf4b6d7b061e66d3ca7f3dd44319b9e26ae7103f.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
	<CAMuHMdWirVk+jrz40yw4=zAOFH6VTX9CXcpO01e0rK8S8VGGHw@mail.gmail.com>
	<CAL_JsqK0RqYuZ8YB1sBZK7hMXvp6oEPfAu11m95F61_kGV3Ptg@mail.gmail.com>
	<2E89032DDAA8B9408CB92943514A0337A56F53A6@SW-EX-MBX01.diasemi.com>
Date: Wed, 11 Jun 2014 09:22:27 -0500
Message-ID: <CAL_JsqJJz2S4fn25pJK5UDG9j36JKnS++VQCMhbdxQd_4-2OFQ@mail.gmail.com>
Subject: Re: [PATCH 8/8] DT: Add vendor prefix for Dialog Semiconductor Ltd.
From: Rob Herring <robherring2@gmail.com>
To: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Support Opensource <Support.Opensource@diasemi.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 8:17 AM, Opensource [Adam Thomson]
<Adam.Thomson.Opensource@diasemi.com> wrote:
>> On Wed, Jun 11, 2014 at 13:43, Rob Herring wrote:
>>
>> dlg is the correct one and seems to be the most widely used, so we
>> should go with that and mark the others deprecated.
>>
>> diasemi is documented for the da9210, but not used anywhere.
>>
>> There appears to be 2 different da9053 bindings. I'd guess the dialog
>> variant used on 2 i.MX boards is not used. Other i.MX boards use the
>> dlg version. I'm not sure what is going on with da9055. Please sort
>> these out.
>>
>
> The intention is to update the other Dialog drivers after we've agreed this
> prefix. With regards to da9055, what's the issue here as I believe that uses
> the 'dlg' prefix already?

In documentation it does, but I'm not sure how these strings are used:

drivers/mfd/da9055-core.c:              .of_compatible = "dialog,da9055-gpio",
drivers/mfd/da9055-core.c:              .of_compatible =
"dialog,da9055-regulator",
drivers/mfd/da9055-core.c:              .of_compatible =
"dialog,da9055-regulator",
drivers/mfd/da9055-core.c:              .of_compatible =
"dialog,da9055-regulator",
drivers/mfd/da9055-core.c:              .of_compatible =
"dialog,da9055-regulator",
drivers/mfd/da9055-core.c:              .of_compatible =
"dialog,da9055-regulator",
drivers/mfd/da9055-core.c:              .of_compatible =
"dialog,da9055-regulator",
drivers/mfd/da9055-core.c:              .of_compatible =
"dialog,da9055-regulator",
drivers/mfd/da9055-core.c:              .of_compatible =
"dialog,da9055-regulator",
drivers/mfd/da9055-core.c:              .of_compatible = "dialog,da9055-onkey",
drivers/mfd/da9055-core.c:              .of_compatible = "dialog,da9055-rtc",
drivers/mfd/da9055-core.c:              .of_compatible = "dialog,da9055-hwmon",
drivers/mfd/da9055-core.c:              .of_compatible =
"dialog,da9055-watchdog",

Rob
