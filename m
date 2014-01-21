Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbaAUNf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 08:35:59 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:45207 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbaAUNfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 08:35:52 -0500
MIME-Version: 1.0
In-Reply-To: <1384265558-10521-1-git-send-email-linus.walleij@linaro.org>
References: <1384265558-10521-1-git-send-email-linus.walleij@linaro.org>
Date: Tue, 21 Jan 2014 14:35:52 +0100
Message-ID: <CACRpkdZoEwgRALT0R8vWB1aWxR_WCR2U0b1yF0Mr0qNm0LDGug@mail.gmail.com>
Subject: Re: [PATCH 1/4 v3] mfd: tc3589x: Add device tree bindings
From: Linus Walleij <linus.walleij@linaro.org>
To: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 3:12 PM, Linus Walleij <linus.walleij@linaro.org> wrote:

> This defines the device tree bindings for the Toshiba TC3589x
> series of multi-purpose expanders. Only the stuff I can test
> is defined: GPIO and keypad. Others may implement more
> subdevices further down the road.
>
> This is to complement
> commit a435ae1d51e2f18414f2a87219fdbe068231e692
> "mfd: Enable the tc3589x for Device Tree" which left off
> the definition of the device tree bindings.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v2->v3:
> - Fix the keys/rows bindings to be u32 rather than
>   /bits/ 8, inconsistency noted by Mark Rutland.
> ChangeLog v1->v2:
> - Include a verbose example in the DT bindings.
> - Explain why this is a stand-alone bindings patch.

So will this since Nov 12 uncommented-upon patch be merged or
do you want me to do some change?

There was some back-and-forth regarding the (existing, already
in use) linux-specific input bindings but the only thing I can
see is some back and forth leaning toward just letting these
be used.

I am happy to change this in whatever way but no directions
for two months....

Yours,
Linus Walleij
