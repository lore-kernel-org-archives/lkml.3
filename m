Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab3JGMHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 08:07:21 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62608 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755979Ab3JGMHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 08:07:17 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>, Rob Landley <rob@landley.net>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] gpiolib: convert ACPI GPIO helpers to gpiod_ interfaces
Date: Mon, 07 Oct 2013 14:18:56 +0200
Message-ID: <1459866.s5LiRGpgct@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1380639537-23406-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1380639537-23406-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 01, 2013 05:58:52 PM Mika Westerberg wrote:
> Hi all,
> 
> This series converts the ACPI GPIO helpers in gpiolib-acpi.c to use the new
> and preferred GPIO descriptor based interface as suggested by the GPIO
> subsystem maintainer.
> 
> The first patch is just a cosmetic fix to move acpi_gpiochip_free_interrupts()
> closer to acpi_gpiochip_request_interrupts(). Patches [2-5/5] do the actual
> conversion.
> 
> The series is based on the latest patches from Alexandre Courbot and I've
> tested them on Intel Haswell based machine.
> 
> Please review.
> 
> Mika Westerberg (5):
>   gpiolib / ACPI: move acpi_gpiochip_free_interrupts next to the request function
>   gpiolib / ACPI: convert to gpiod interfaces
>   gpiolib / ACPI: add ACPI support for gpiod_get_index()
>   gpiolib / ACPI: allow passing GPIOF_ACTIVE_LOW for GpioInt resources
>   gpiolib / ACPI: document the GPIO descriptor based interface

The patches look good to me so

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

for the whole series.

Thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
