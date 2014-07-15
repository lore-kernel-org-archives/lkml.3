Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbaGOJEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:04:11 -0400
Received: from mail-yk0-f173.google.com ([209.85.160.173]:52338 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758057AbaGOJEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:04:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140715085914.GT26465@leverpostej>
References: <1405340169-2820-1-git-send-email-harinik@xilinx.com>
	<1405340169-2820-2-git-send-email-harinik@xilinx.com>
	<20140714150749.GH26465@leverpostej>
	<CAFcVECK9U_3+3htTAu7r-agi43mC9Z2pqHeS9TpHTbZ3=o-o8w@mail.gmail.com>
	<20140715085914.GT26465@leverpostej>
Date: Tue, 15 Jul 2014 14:34:06 +0530
Message-ID: <CAFcVECJ+tO4U5H2QvuY8xpkh5FrX_PtCvrH8FsZQ28bJwYRckA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] devicetree: Add Cadence WDT devicetree bindings documentation
From: Harini Katakam <harinikatakamlinux@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "wim@iguana.be" <wim@iguana.be>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "michals@xilinx.com" <michals@xilinx.com>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "harini.katakam@xilinx.com" <harini.katakam@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Jul 15, 2014 at 2:29 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Tue, Jul 15, 2014 at 07:39:40AM +0100, Harini Katakam wrote:
>> Hi Mark,
>>
>> On Mon, Jul 14, 2014 at 8:37 PM, Mark Rutland <mark.rutland@arm.com> wrote:
>> > On Mon, Jul 14, 2014 at 01:16:09PM +0100, Harini Katakam wrote:
>> >> Add cadence-wdt bindings documentation.
>> >>
>> >> Signed-off-by: Harini Katakam <harinik@xilinx.com>
>> >> ---
>> >>
>> >> v3 changes:
>> >> - Change reset property type and improve description.
>> >> - Improve description of clocks and interrupts.
>> >> - Use watchdog@ in the example.
>> >> - Use only cdns compatible string for now.
>> >>
>> >> v2:
>> >> No changes
>> >>
>> >> ---
>> >>  .../devicetree/bindings/watchdog/cadence-wdt.txt   |   27 ++++++++++++++++++++
>> >>  1 file changed, 27 insertions(+)
>> >>  create mode 100644 Documentation/devicetree/bindings/watchdog/cadence-wdt.txt
>> >>

<snip>

>> >> +Optional properties
>> >> +- reset                      : If this property exists, then a reset is done
>> >> +                       when watchdog times out.
>> >
>> > That's a bit of an ambiguous name (too easy to misconstrue as a reset
>> > device reference). Do any other watchdogs have similar properties?
>>
>> I could change it to "reset-on-timeout" if that better.
>> From the documentation of other drivers, there seems to be a reset-type
>> property in atmel. Dint find any other reset related properties.
>>
>
> Ok. reset-on-timeout sounds like a better property name to avoid
> possible confusion.
>
> That said, what happens if we don't specify the device should reset the
> system (but have a timeout-sec property)?
>

A reset wont be done but a message will be printed when the watchdog times out
just as an indication.

Regards,
Harini
