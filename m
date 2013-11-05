Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab3KEMkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 07:40:01 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:50423 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab3KEMj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 07:39:59 -0500
MIME-Version: 1.0
In-Reply-To: <1383406775-14902-2-git-send-email-prabhakar.csenng@gmail.com>
References: <1383406775-14902-1-git-send-email-prabhakar.csenng@gmail.com>
	<1383406775-14902-2-git-send-email-prabhakar.csenng@gmail.com>
Date: Tue, 5 Nov 2013 13:39:58 +0100
Message-ID: <CACRpkdZ7pwGQnK0NN4tybLUNdMxu5WVaGX8Dqu+kMgVBuyF16w@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] gpio: davinci: Fixed a check for unbanked gpio
From: Linus Walleij <linus.walleij@linaro.org>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: Sekhar Nori <nsekhar@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Alex Elder <alex.elder@linaro.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 2, 2013 at 4:39 PM, Lad, Prabhakar
<prabhakar.csengg@gmail.com> wrote:

> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>
> This patch fixes the check for the offset in
> gpio_to_irq_unbanked() function.
>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Is this a regression that should go in right now?

Yours,
Linus Walleij
