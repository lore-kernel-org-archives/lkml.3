Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab3HPNQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 09:16:26 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:64882 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab3HPNQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 09:16:20 -0400
MIME-Version: 1.0
In-Reply-To: <1375133350-18828-3-git-send-email-ddaney.cavm@gmail.com>
References: <1375133350-18828-1-git-send-email-ddaney.cavm@gmail.com>
	<1375133350-18828-3-git-send-email-ddaney.cavm@gmail.com>
Date: Fri, 16 Aug 2013 15:16:20 +0200
Message-ID: <CACRpkdaM=hqwHhNxCLCEZudRNYsyW-bZMXzZyvuW4qs2fGaREw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] gpio MIPS/OCTEON: Add a driver for OCTEON's
 on-chip GPIO pins.
From: Linus Walleij <linus.walleij@linaro.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-mips@linux-mips.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 11:29 PM, David Daney <ddaney.cavm@gmail.com> wrote:

> From: David Daney <david.daney@cavium.com>
>
> The SOCs in the OCTEON family have 16 (or in some cases 20) on-chip
> GPIO pins, this driver handles them all.  Configuring the pins as
> interrupt sources is handled elsewhere (OCTEON's irq handling code).
>
> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
>
> Device tree binding defintions already exist for this device in
> Documentation/devicetree/bindings/gpio/cavium-octeon-gpio.txt

I like this.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

I guess you will merge both patches through the MIPS arch
tree?

Yours,
Linus Walleij
