Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab3KRNOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:14:09 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:40131 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3KRNNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:13:54 -0500
MIME-Version: 1.0
In-Reply-To: <1383905510-31760-6-git-send-email-prabhakar.csengg@gmail.com>
References: <1383905510-31760-1-git-send-email-prabhakar.csengg@gmail.com>
	<1383905510-31760-6-git-send-email-prabhakar.csengg@gmail.com>
Date: Mon, 18 Nov 2013 14:13:53 +0100
Message-ID: <CACRpkdb+vzbt9_Z1xuZA+uU5hi7vD+c95f27fsanaaSzD2f27w@mail.gmail.com>
Subject: Re: [PATCH v5 5/7] gpio: davinci: add OF support
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

On Fri, Nov 8, 2013 at 11:11 AM, Prabhakar Lad
<prabhakar.csengg@gmail.com> wrote:

> From: KV Sujith <sujithkv@ti.com>
>
> This patch adds OF parser support for davinci gpio
> driver and also appropriate documentation in gpio-davinci.txt
> located at Documentation/devicetree/bindings/gpio/.
>
> Signed-off-by: KV Sujith <sujithkv@ti.com>
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> [prabhakar.csengg@gmail.com: simplified the OF code, removed
>                 unnecessary DT property and also simplified
>                 the commit message]
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

I like this patch now!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
