Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbaAUNhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 08:37:41 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:34371 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbaAUNhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 08:37:38 -0500
MIME-Version: 1.0
In-Reply-To: <1381871803-22796-1-git-send-email-linus.walleij@linaro.org>
References: <1381871803-22796-1-git-send-email-linus.walleij@linaro.org>
Date: Tue, 21 Jan 2014 14:37:37 +0100
Message-ID: <CACRpkdYYN2hDsRw2xu0kv0zGDBGENFoqS915qCok28ZQhBOygg@mail.gmail.com>
Subject: Re: [PATCH 3/5] mfd: tc3589x: reform device tree probing
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 11:16 PM, Linus Walleij
<linus.walleij@linaro.org> wrote:

> This changes the following mechanisms in the TC3589x device tree
> probing path:
>
> - Use the .of_match_table in struct device_driver to match the
>   device in the device tree.
> - Add matches for the proper compatible strings "toshiba,..."
>   and all sub-variants, just as is done for the .id matches.
> - Move over all the allocation of platform data etc to the
>   tc3589x_of_probe() function and follow the pattern of passing
>   a platform data pointer back, or an error pointer on error,
>   as found in the STMPE driver.
> - Match the new (proper) compatible strings for the GPIO and
>   keypad MFD cells.
> - Use of_device_is_compatible() rather than just !strcmp()
>   to discover which cells to instantiate.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Waiting for this patch to go in as well... I can resend the
entire set of it helps.

Yours,
Linus Walleij
