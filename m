Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab3AKUMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 15:12:47 -0500
Received: from mail-ia0-f175.google.com ([209.85.210.175]:43278 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012Ab3AKUMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 15:12:43 -0500
MIME-Version: 1.0
In-Reply-To: <50EF27B4.60608@wwwdotorg.org>
References: <1355343907-11535-1-git-send-email-linus.walleij@stericsson.com>
	<50EF27B4.60608@wwwdotorg.org>
Date: Fri, 11 Jan 2013 21:12:43 +0100
Message-ID: <CACRpkdZ0b=ZohgaBH3qPH_O5TiWmXJXs6872D+YPVA9g4BssYg@mail.gmail.com>
Subject: Re: [PATCH v2] drivers/pinctrl: grab default handles from device core
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Kevin Hilman <khilman@ti.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Mitch Bradley <wmb@firmworks.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 9:42 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 12/12/2012 01:25 PM, Linus Walleij wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> This makes the device core auto-grab the pinctrl handle and set
>> the "default" (PINCTRL_STATE_DEFAULT) state for every device
>> that is present in the device model right before probe. This will
>> account for the lion's share of embedded silicon devcies.
>
> There are quite a few problems with this patch, and they end up
> completely breaking at least Tegra in next-20130110.

But I have not put this patch into linux-next.

I was still waiting for Greg to ACK it...

Apparently it was included in a pull request to the SH tree or something,
Simon can you remove these patches for now, this patch needs to
be elaborated on in the pinctrl tree first.

Yours,
Linus Walleij
