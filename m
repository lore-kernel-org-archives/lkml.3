Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab3A2Krj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 05:47:39 -0500
Received: from mail-ia0-f175.google.com ([209.85.210.175]:46037 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab3A2Krg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 05:47:36 -0500
MIME-Version: 1.0
In-Reply-To: <1359382990-19353-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1359382990-19353-1-git-send-email-mathias.nyman@linux.intel.com>
Date: Tue, 29 Jan 2013 11:47:36 +0100
Message-ID: <CACRpkdY75vHvsKLR3BHmxmgWj_6gQbA+phiJy+KEHcDsCg55Vw@mail.gmail.com>
Subject: Re: [RFC PATCH v2] gpiolib-acpi: Add ACPI5 event model support to gpio.
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

On Mon, Jan 28, 2013 at 3:23 PM, Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:

> Add ability to handle ACPI events signalled by GPIO interrupts.
>
> ACPI5 platforms can use GPIO signaled ACPI events. These GPIO interrupts are
> handled by ACPI event methods which need to be called from the GPIO
> controller's interrupt handler. acpi_gpio_request_interrupt() finds out which
> gpio pins have acpi event methods and assigns interrupt handlers that calls
> the acpi event methods for those pins.
>
> Partially based on work by Rui Zhang <rui.zhang@intel.com>
>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

OK I am pleased with this, patch applied!

Yours,
Linus Walleij
