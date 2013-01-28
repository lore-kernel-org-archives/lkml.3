Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab3A1Iax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 03:30:53 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:33062 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab3A1Iav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 03:30:51 -0500
MIME-Version: 1.0
In-Reply-To: <51029142.9050901@linux.intel.com>
References: <1359114505-4473-1-git-send-email-mathias.nyman@linux.intel.com>
	<CACRpkdZvoacYP0rwnrcyHfKWrN67HvN5jCVom4Lx6Qd9RC0fjg@mail.gmail.com>
	<51029142.9050901@linux.intel.com>
Date: Mon, 28 Jan 2013 09:30:51 +0100
Message-ID: <CACRpkdau1zrZsMxKcB-em3SM0uBVXjU+JA1GJjOcNXWeBiR43Q@mail.gmail.com>
Subject: Re: [RFC PATCH] gpiolib-acpi: Add ACPI5 event model support to gpio.
From: Linus Walleij <linus.walleij@linaro.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        grant.likely@secretlab.ca, linux-acpi@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>, tianyu.lan@intel.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 3:05 PM, Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:
> On 01/25/2013 02:54 PM, Linus Walleij wrote:

>> Second: why is there no mirror function *releasing* all the IRQs again?
>> One-way interface?
>
> My thinking was that using devm_request_threaded_irq(chip->dev, ...) will
> automatically free the interrupts on driver detach, making the release
> function unnecessary.

Oh that's probably correct. Thanks!

Yours,
Linus Walleij
