Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab3BEPVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:21:33 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:58036 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab3BEPVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:21:32 -0500
MIME-Version: 1.0
In-Reply-To: <1359978868-28736-61-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
	<1359978868-28736-61-git-send-email-lee.jones@linaro.org>
Date: Tue, 5 Feb 2013 16:21:31 +0100
Message-ID: <CACRpkdYePNewky9ffwkSzzwhxXU4Ft4kRHjJGgaE9HsL8kf2VQ@mail.gmail.com>
Subject: Re: [PATCH 60/73] ARM: ux500: regulators: Add LDO USB consumer
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        =?ISO-8859-1?Q?Bengt_J=F6nsson?= <bengt.g.jonsson@stericsson.com>,
        Supriya Karanth <supriya.karanth@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 4, 2013 at 12:54 PM, Lee Jones <lee.jones@linaro.org> wrote:

> +static struct regulator_consumer_supply ab8505_usb_consumers[] = {
> +       /* HS USB OTG physical interface */
> +       REGULATOR_SUPPLY("v-usb", NULL),
> +};

As noted by Mark elsewhere this should be the name of the voltage input
on the actual component.

"v-usb" is the name of a rail.

But what is that actual name of the voltage input on that component?

"vdd" or similar are common.

This need to be changed in this definition
and the consumer driver alike.

Yours,
Linus Walleij
