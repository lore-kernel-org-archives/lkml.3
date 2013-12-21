Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab3LUIWJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 03:22:09 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:53634 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab3LUIWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 03:22:07 -0500
MIME-Version: 1.0
In-Reply-To: <1387361272-20861-3-git-send-email-grygorii.strashko@ti.com>
References: <1387361272-20861-1-git-send-email-grygorii.strashko@ti.com> <1387361272-20861-3-git-send-email-grygorii.strashko@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sat, 21 Dec 2013 13:51:45 +0530
Message-ID: <CA+V-a8vChjoYhtmGVkARxtX=dTrDAsbS5L1o69jN2pSg0v13xg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] gpio: davinci: reuse for Keystone SoC
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>, Sekhar Nori <nsekhar@ti.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 3:37 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
> The similar GPIO HW block is used by keystone SoCs as
> in Davinci SoCs.
> Hence, reuse Davinci GPIO driver for Keystone taking into
> account that Keystone contains ARM GIC IRQ controller which
> is implemented using IRQ Chip.
>
> Documentation:
>         http://www.ti.com/lit/ug/sprugv1/sprugv1.pdf
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: devicetree@vger.kernel.org
>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
