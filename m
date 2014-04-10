Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965751AbaDJQGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 12:06:07 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:56122 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965694AbaDJQGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 12:06:02 -0400
MIME-Version: 1.0
In-Reply-To: <1396268209-19108-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1396268209-19108-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Thu, 10 Apr 2014 18:06:01 +0200
Message-ID: <CACRpkdZ4zndoCPSvdhMru6hofeCb0ivSVfy1dPckdnfeWUrL4g@mail.gmail.com>
Subject: Re: [PATCH] gpio / ACPI: Don't crash on NULL chip->dev
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Alexandre Courbot <gnurou@gmail.com>, Sabrina Dubroca <sd@queasysnail.net>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 2:16 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> Commit aa92b6f689ac (gpio / ACPI: Allocate ACPI specific data directly in
> acpi_gpiochip_add()) moved ACPI handle checking to acpi_gpiochip_add() but
> forgot to check whether chip->dev is NULL before dereferencing it.
>
> Since chip->dev pointer is optional we can end up with crash like following:

Sorry for taking so long before getting to it, patch applied for fixes.

Yours,
Linus Walleij
