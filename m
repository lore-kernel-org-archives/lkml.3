Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbaCEPae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:30:34 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:40984 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757857AbaCEPaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 10:30:25 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdbSk3Vv+-U=jQTH=8E=yx4tkHApGq-ARfwXs-cBf4=ddA@mail.gmail.com>
References: <1393369261-17469-1-git-send-email-delicious.quinoa@gmail.com>
	<CACRpkdbSk3Vv+-U=jQTH=8E=yx4tkHApGq-ARfwXs-cBf4=ddA@mail.gmail.com>
Date: Wed, 5 Mar 2014 09:30:23 -0600
Message-ID: <CANk1AXRWdxgY4T6CHAacePupuyKRn_byGCGdtdvbBHvJuZkZzw@mail.gmail.com>
Subject: Re: [PATCH v12] gpio: add a driver for the Synopsys DesignWare APB
 GPIO block
From: delicious quinoa <delicious.quinoa@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Jamie Iles <jamie@jamieiles.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Rutland <mark.rutland@arm.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 4, 2014 at 7:01 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, Feb 26, 2014 at 7:01 AM, Alan Tull <delicious.quinoa@gmail.com> wrote:
>
>> From: Jamie Iles <jamie@jamieiles.com>
>>
>> The Synopsys DesignWare block is used in some ARM devices (picoxcell)
>> and can be configured to provide multiple banks of GPIO pins.
>>
>> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
>> Signed-off-by: Alan Tull <atull@altera.com>
>> Reviewed-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>>
>> v12: - Add irq_startup/shutdown
>>      - do irq_create_mapping() in probe, irq_find_mapping() in to_irq()
>>      - Adjust mappings to show support for 1 gpio per port.
>>      - gpio-cells = <1>
>
> Patch applied!
>
> You've done a tremendous work on this driver and there is
> absolutely nothing controversial about the bindings, so it is
> my pleasure to include this driver.
>
> Yours,
> Linus Walleij

Excellent!  Thanks Linus!

And thanks Jamie for originating this driver!

Alan Tull
aka
delicious quinoa
