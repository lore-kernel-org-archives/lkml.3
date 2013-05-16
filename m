Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab3EPUmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 16:42:42 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:46941 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab3EPUmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 16:42:40 -0400
MIME-Version: 1.0
In-Reply-To: <5195401B.5070209@ti.com>
References: <1368636386-17138-1-git-send-email-dmurphy@ti.com>
	<20130515170516.GA6135@kahuna>
	<5194FCDD.8080209@ti.com>
	<CAGo_u6pX+DdVNWqdPXDChzMr27YAXL_Zvt7DxWBijOCW0rXpkA@mail.gmail.com>
	<5195401B.5070209@ti.com>
Date: Thu, 16 May 2013 15:42:39 -0500
X-Google-Sender-Auth: ycuc5JWwznaHyo4aZT6ppGDYCIw
Message-ID: <CAGo_u6oQP6eGkCQe=uTBmUsKQqFbS9_xXYt24_HRtjEr561O=g@mail.gmail.com>
Subject: Re: [PATCH v4] ARM:dts:omap4-panda: Update the LED support for the
 panda DTS
From: Nishanth Menon <nm@ti.com>
To: Dan Murphy <dmurphy@ti.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, devicetree-discuss@lists.ozlabs.org,
        lkml <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 3:22 PM, Dan Murphy <dmurphy@ti.com> wrote:
> On 05/16/2013 01:18 PM, Nishanth Menon wrote:
>> On Thu, May 16, 2013 at 10:35 AM, Dan Murphy <dmurphy@ti.com> wrote:
>>> I am not sure you really want to do this.
>>> If I make the pinctrl part of the led structure then the only way the gpio_wk7 on a1-a3 to be configured is when
>>> the CONFIG_LEDS_GPIO flag is set.
>>>
>>> Do you really want that dependency?  You did say it was a key fix
>>> At least this way the pins are configured regardless of that flag.
>> That is better as the system will be left in the pinmux configuration
>> handed over from bootloader.
> So you want to depend on a boot loader to configure pins correctly for the kernel?
> Hmmm seems risky to me.

Not really! if it is a critical pinmux, pinmux defaults are great,
else belongs definitely to device->pinctrl :) depending on bootloader
pinmux implies NOT having pinmux even for device - NO. that is
definitely not what I stated.
Regards,
NM
