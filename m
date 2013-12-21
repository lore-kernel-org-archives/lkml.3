Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab3LUIVT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 03:21:19 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:32861 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3LUIVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 03:21:17 -0500
MIME-Version: 1.0
In-Reply-To: <1387361272-20861-2-git-send-email-grygorii.strashko@ti.com>
References: <1387361272-20861-1-git-send-email-grygorii.strashko@ti.com> <1387361272-20861-2-git-send-email-grygorii.strashko@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sat, 21 Dec 2013 13:50:56 +0530
Message-ID: <CA+V-a8tBQPAHjHibLa=n1mu31ZJyLU3vGwLutHqe=Fg4eXq6zA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] gpio: davinci: don't create irq_domain in case of
 unbanked irqs
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>, Sekhar Nori <nsekhar@ti.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 3:37 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
> The system may crash if:
> - there are more then 1 bank
> - unbanked irqs are enabled
> - someone will call gpio_to_irq() for GPIO from bank2 or above
>
> Hence, fix it by not creating irq_domain if unbanked irqs are enabled
> and correct gpio_to_irq_banked() to handle this properly.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: Sekhar Nori <nsekhar@ti.com>
>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
