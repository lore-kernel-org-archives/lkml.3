Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbaJ1OMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:12:40 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:65151 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbaJ1OMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:12:38 -0400
MIME-Version: 1.0
In-Reply-To: <20141026182541.GA23020@gmail.com>
References: <1412717576-19737-1-git-send-email-b.galvani@gmail.com>
	<1412717576-19737-3-git-send-email-b.galvani@gmail.com>
	<CACRpkdb4WLX+FeEAuh=YZteaNPzq0WMN0PTTpHnMWmwTts6=Bg@mail.gmail.com>
	<20141026182541.GA23020@gmail.com>
Date: Tue, 28 Oct 2014 15:12:37 +0100
Message-ID: <CACRpkdbhLf5pNXZJ_neSrL4XgqH7YpDXUPWqRJkdaD4xw88feg@mail.gmail.com>
Subject: Re: [PATCH 2/3] pinctrl: meson: add device tree bindings documentation
From: Linus Walleij <linus.walleij@linaro.org>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Carlo Caione <carlo@caione.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2014 at 7:25 PM, Beniamino Galvani <b.galvani@gmail.com> wrote:
> On Fri, Oct 24, 2014 at 01:53:28PM +0200, Linus Walleij wrote:
>>
>> I think it's better to use the compatible string to indicate different
>> versions of the hardware and then have just have one big
>> regs to cover all registers.
>
> The problem here is that the register ranges are not contiguous and
> the holes in between are used by other devices, so I can't use a
> single range.

OK I get it.

>> So for per-pin configuration, "function" and "pins" would be
>> apropriate.
>
> I will use "groups" instead of "pins" for the pinmux configuration.

Excellent!

Yours,
Linus Walleij
