Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933209AbbAIPuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:50:32 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:64944 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077AbbAIPu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:50:29 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1501061627150.18120@linuxheads99>
References: <1420575219-27061-1-git-send-email-atull@opensource.altera.com>
 <1420575219-27061-2-git-send-email-atull@opensource.altera.com>
 <CAL_JsqKRe2YquSmi01wa5b=Ctns+1ek-PdSHDLuxyCfKasTw5g@mail.gmail.com> <alpine.DEB.2.02.1501061627150.18120@linuxheads99>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 9 Jan 2015 09:50:07 -0600
Message-ID: <CAL_Jsq+pn5MW6veUivEL49FLSQxZOWRq0gU9Q6iD5jzurKK3rQ@mail.gmail.com>
Subject: Re: [PATCH v8 1/4] doc: add bindings document for altera fpga manager
To: atull <atull@opensource.altera.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Simek <monstr@monstr.eu>,
        Michal Simek <michal.simek@xilinx.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>, iws@ovro.caltech.edu,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>, Mark Brown <broonie@kernel.org>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Kyle Teske <kyle.teske@ni.com>,
        Nicolas Pitre <nico@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        David Brown <davidb@codeaurora.org>, Rob Landley <rob@landley.net>,
        David Miller <davem@davemloft.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devel@driverdev.osuosl.org,
        Alan Tull <delicious.quinoa@gmail.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        "yvanderv@opensource.altera.com" <yvanderv@opensource.altera.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2015 at 4:34 PM, atull <atull@opensource.altera.com> wrote:
> On Tue, 6 Jan 2015, Rob Herring wrote:
>
>> On Tue, Jan 6, 2015 at 2:13 PM,  <atull@opensource.altera.com> wrote:
>> > From: Alan Tull <atull@opensource.altera.com>
>> >
>> > New bindings document for Altera fpga manager.
>> >
>> > Signed-off-by: Alan Tull <atull@opensource.altera.com>
>>
>> Acked-by: Rob Herring <robh@kernel.org>
>>
>> Like I said, this binding doesn't look like it will change other than
>> perhaps additional optional properties, so it can go into
>> Documentation. Perhaps .../bindings/fpga/. I'm happy to merge this
>> thru DT tree if you want.
>>
>> Rob
>
> Thanks, that would be great.  Yes ../bindings/fpga sounds good.
>
> Do you want me to send you a patch with the updated path?

Yes, please.

Rob
