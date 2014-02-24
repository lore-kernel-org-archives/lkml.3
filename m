Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaBXMLQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 07:11:16 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:37545 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaBXMLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 07:11:14 -0500
MIME-Version: 1.0
In-Reply-To: <1392148200-5393-2-git-send-email-ddaney.cavm@gmail.com>
References: <1392148200-5393-1-git-send-email-ddaney.cavm@gmail.com>
	<1392148200-5393-2-git-send-email-ddaney.cavm@gmail.com>
Date: Mon, 24 Feb 2014 13:11:13 +0100
Message-ID: <CACRpkdaO5a6WBHHkDCFVN_Eg8P2Z7pkaONXCcxji9unOmkOsqw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] of/gpio: Define OF_GPIO_OPEN_DRAIN and
 OF_GPIO_OPEN_SOURCE flags.
From: Linus Walleij <linus.walleij@linaro.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 8:49 PM, David Daney <ddaney.cavm@gmail.com> wrote:

>  enum of_gpio_flags {
>         OF_GPIO_ACTIVE_LOW = 0x1,
> +       OF_GPIO_OPEN_DRAIN = 0x2,
> +       OF_GPIO_OPEN_SOURCE = 0x4,
>  };

BTW I think this enum shall be deleted and replaced by
#include <dt-bindings/gpio/gpio.h> and use the definition from
there.

Yours,
Linus Walleij
