Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbaKDKSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:18:12 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:40388 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbaKDKSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:18:08 -0500
MIME-Version: 1.0
In-Reply-To: <1415012493-134561-2-git-send-email-mika.westerberg@linux.intel.com>
References: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com>
	<1415012493-134561-2-git-send-email-mika.westerberg@linux.intel.com>
Date: Tue, 4 Nov 2014 11:18:07 +0100
Message-ID: <CACRpkdbXT367GgpG2=fNqPRG8-8Sz8syV0TNC68Hm6MFvdVBdQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] gpio / ACPI: Add knowledge about pin controllers
 to acpi_get_gpiod()
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Ning Li <ning.li@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 12:01 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> The GPIO resources (GpioIo/GpioInt) used in ACPI contain a GPIO number
> which is relative to the hardware GPIO controller. Typically this number
> can be translated directly to Linux GPIO number because the mapping is
> pretty much 1:1.
>
> However, when the GPIO driver is using pins exported by a pin controller
> driver via set of GPIO ranges, the mapping might not be 1:1 anymore and
> direct translation does not work.
>
> In such cases we need to translate the ACPI GPIO number to be suitable for
> the GPIO controller driver in question by checking all the pin controller
> GPIO ranges under the given device and using those to get the proper GPIO
> number.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Sweet, patch applied.

Yours,
Linus Walleij
