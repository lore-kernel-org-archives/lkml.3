Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab3C0M5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 08:57:18 -0400
Received: from mail-ia0-f176.google.com ([209.85.210.176]:50436 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab3C0M5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 08:57:15 -0400
MIME-Version: 1.0
In-Reply-To: <1363885931-20571-4-git-send-email-gerlando.falauto@keymile.com>
References: <1363885931-20571-1-git-send-email-gerlando.falauto@keymile.com>
	<1363885931-20571-4-git-send-email-gerlando.falauto@keymile.com>
Date: Wed, 27 Mar 2013 13:57:15 +0100
Message-ID: <CACRpkdam9AEohegBCqshbAT_Xq4_H6VHwToKzJO_1TdCJQZhrQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/9] gpio: mvebu: convert to usage of *pmask_cache
 within irq_chip_type
From: Linus Walleij <linus.walleij@linaro.org>
To: Gerlando Falauto <gerlando.falauto@keymile.com>
Cc: linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>, Simon Guinot <sguinot@lacie.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 6:12 PM, Gerlando Falauto
<gerlando.falauto@keymile.com> wrote:

> Since we have now introduced pmask_cache within irq_chip_type to also
> handle per-chip-type mask registers, convert gpio-mvebu driver to use
> this new pointer.
>
> Signed-off-by: Gerlando Falauto <gerlando.falauto@keymile.com>

If the genirq changes are accepted you can have my
Acked-by: Linus Walleij <linus.walleij@linaro.org>

>From the GPIO side of things.

Yours,
Linus Walleij
