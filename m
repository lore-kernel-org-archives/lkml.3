Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab3KSIak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 03:30:40 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:43900 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab3KSIaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 03:30:35 -0500
MIME-Version: 1.0
In-Reply-To: <20131113233411.565.32282.sendpatchset@w520>
References: <20131113233411.565.32282.sendpatchset@w520>
Date: Tue, 19 Nov 2013 09:30:34 +0100
Message-ID: <CACRpkdbK0HV5WCtah7aw4suz=CjaBVOZR0vv=YSkXQqmjr_U5g@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: Renesas RZ GPIO driver V2
From: Linus Walleij <linus.walleij@linaro.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 12:34 AM, Magnus Damm <magnus.damm@gmail.com> wrote:

> From: Magnus Damm <damm@opensource.se>
>
> This patch adds a GPIO driver for the RZ series of SoCs from
> Renesas. The V2 of the driver requires DT to be used.
>
> The hardware allows control of GPIOs in blocks of up to 16 pins.
> Interrupts are not included in this hardware block, if interrupts
> are needed then the PFC needs to be configured to a IRQ pin function
> which is handled by the GIC hardware.
>
> Tested with yet-to-be-posted DT devices on r7s72100 and Genmai using
> LEDs, DIP switches and I2C bitbang.
>
> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
>
>  Changes since V1:
>  - Drop platform data interface as suggested by Linus Walleij, thanks!
>  - Various changes suggested by Laurent Pinchart (except !!), thanks!

This looks all right to me, but I'm waiting for you and Laurent
to hash out the final details (v3?)

Yours,
Linus Walleij
