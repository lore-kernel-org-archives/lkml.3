Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab3K2HnG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 02:43:06 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:57448 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3K2HnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 02:43:01 -0500
MIME-Version: 1.0
In-Reply-To: <1385057731-4348-4-git-send-email-prabhakar.csengg@gmail.com>
References: <1385057731-4348-1-git-send-email-prabhakar.csengg@gmail.com>
	<1385057731-4348-4-git-send-email-prabhakar.csengg@gmail.com>
Date: Fri, 29 Nov 2013 08:43:00 +0100
Message-ID: <CACRpkdZaSgEMTPPSYJyENc+zhTTLhzchi2F=CzdZs=DskMvVwg@mail.gmail.com>
Subject: Re: [PATCH v6 3/6] gpio: davinci: remove unused variable intc_irq_num
From: Linus Walleij <linus.walleij@linaro.org>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Sekhar Nori <nsekhar@ti.com>, Grygorii Strashko <grygorii.strashko@ti.com>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 7:15 PM, Prabhakar Lad
<prabhakar.csengg@gmail.com> wrote:

> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>
> As the davinci-gpio driver is migrated to use irqdomain
> there is no need to pass the irq base for the gpio driver.
> This patch removes this variable from davinci_gpio_platform_data
> and also the refrences from the machine file.
>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

*Very* nice patch!

Yours,
Linus Walleij
