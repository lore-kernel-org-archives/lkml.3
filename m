Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab3LLUbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:31:25 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:55775 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab3LLUbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:31:23 -0500
MIME-Version: 1.0
In-Reply-To: <1386784327-22164-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1386784327-22164-1-git-send-email-prabhakar.csengg@gmail.com>
Date: Thu, 12 Dec 2013 21:31:22 +0100
Message-ID: <CACRpkdZSyiA1zF3VcGrT+2yu3X5=eoon=0rqr7UejY4kjf7jNw@mail.gmail.com>
Subject: Re: [PATCH v7] gpio: davinci: use {readl|writel}_relaxed() instead of __raw_*
From: Linus Walleij <linus.walleij@linaro.org>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 6:52 PM, Prabhakar Lad
<prabhakar.csengg@gmail.com> wrote:

> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>
> This patch replaces the __raw_readl/writel with
> {readl|writel}_relaxed(), Altough the code runs on ARMv5
> based SOCs, changing this will help copying the code
> for other uses.
>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  This patch is part of series [1] rest of the patches
>  are Acked/reviewed so posting this patch independently
>  and marking it as v7.
>
>  [1] http://www.spinics.net/lists/devicetree/msg13037.html
>
>  drivers/gpio/gpio-davinci.c |   36 ++++++++++++++++++------------------

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Should I take this into the GPIO tree, or should it go
in through the DaVinci tree?

Yours,
Linus Walleij
