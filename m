Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbaGHJ2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:28:03 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:54058 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbaGHJ16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:27:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140707152309.GH4939@tarshish>
References: <1403091577-10232-1-git-send-email-harinik@xilinx.com>
	<5cc8b89b-20ff-4fa9-92dd-bb2f6d3512d8@BY2FFO11FD030.protection.gbl>
	<CACRpkdb1M3-hrSKLKWz21LCJ1sMvsq5E-aqkpmVhy0NwOS5HhA@mail.gmail.com>
	<20140707152309.GH4939@tarshish>
Date: Tue, 8 Jul 2014 11:27:57 +0200
Message-ID: <CACRpkdY+3hy5iw=uRdmu665NWsoGacTMgjUq97219kEcfn7Dqw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] gpio: Add driver for Zynq GPIO controller
From: Linus Walleij <linus.walleij@linaro.org>
To: Baruch Siach <baruch@tkos.co.il>
Cc: =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Harini Katakam <harinik@xilinx.com>, Pawel Moll <pawel.moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Harini Katakam <harinikatakamlinux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Harini Katakam <harini.katakam@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2014 at 5:23 PM, Baruch Siach <baruch@tkos.co.il> wrote:
> On Mon, Jul 07, 2014 at 04:51:56PM +0200, Linus Walleij wrote:

>> This needs someone to step in and provide a replacement, my preferred
>> mechanism would be a /dev/gpiochip0/... hierarchy using char devices.
>
> I really like the ability to control GPIOs from shell, both interactively and
> scripted. I find it useful for quick hardware level debugging,

I would be happy to carry it in the unstable-ABI debugfs for sure.
It's the supported ABI that bothers me.

> and for boot
> time scripting (mainly in initramfs).

What is the usecase here?

> Do you intend to preserve this
> capability in the future? Will I need a special utility (or Busybox applet) to
> do this with char device ioctl?

It is ABI so we have to preserve it. But sometimes people come with
new zuper-complex userspace usecases and want to add this or
that crazy ABI to do stuff in userspace that the kernel can do better.
And all that I intend to just NACK.

Yours,
Linus Walleij
