Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab3BAJh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 04:37:56 -0500
Received: from mail-ia0-f178.google.com ([209.85.210.178]:41660 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab3BAJhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 04:37:52 -0500
MIME-Version: 1.0
In-Reply-To: <1359471223-4794-3-git-send-email-andreas@gaisler.com>
References: <1359471223-4794-1-git-send-email-andreas@gaisler.com>
	<1359471223-4794-3-git-send-email-andreas@gaisler.com>
Date: Fri, 1 Feb 2013 10:37:51 +0100
Message-ID: <CACRpkdbfKmG37QRR54S9MiFMZ+g0x37=-uQ1nCtDaJbSk0hHEA@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] of: Return -ENXIO from of_parse_phandle_with_args
 for too large index and return errors from of_gpio_named_count
From: Linus Walleij <linus.walleij@linaro.org>
To: Andreas Larsson <andreas@gaisler.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        software@gaisler.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 3:53 PM, Andreas Larsson <andreas@gaisler.com> wrote:

> This lets of_gpio_named_count return an errno on errors by being able to
> distinguish between reaching the end of the phandle list and getting some other
> error from of_parse_phandle_with_args.
>
> Return error from of_spi_register_master when there is an "cs-gpios" list for
> which gp_gpio_named_count fails.
>
> Adjust various drivers cope with error return from of_gpio_named_count,
> including via of_gpio_count.
>
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
> ---
> Changes since v1:
> - Handle error return values from calls to of_gpio_count

Looks correct to me, but I'm no DT-ninja.

For the GPIO portions:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
