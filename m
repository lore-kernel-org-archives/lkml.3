Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab3BJPB4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 10:01:56 -0500
Received: from mail-ia0-f171.google.com ([209.85.210.171]:47444 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643Ab3BJPBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 10:01:55 -0500
MIME-Version: 1.0
In-Reply-To: <20130210024141.GE25302@quad.lixom.net>
References: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com>
	<1360093715-6348-12-git-send-email-linus.walleij@stericsson.com>
	<20130210024141.GE25302@quad.lixom.net>
Date: Sun, 10 Feb 2013 16:01:54 +0100
Message-ID: <CACRpkdYfG35UUGZZ=N4GQEkEEV_xEK9dhrz3YQ+kS7DaOSOjGA@mail.gmail.com>
Subject: Re: [PATCH 11/14] ARM: ux500: remove irq_base property from platform_data
From: Linus Walleij <linus.walleij@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        arm@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2013 at 3:42 AM, Olof Johansson <olof@lixom.net> wrote:

> This patch on its own doesn't apply cleanly at all to arm-soc, I'm guessing
> because I need the rest of the series. With the presumption that you're not
> going to cause grief from sfr due to excessive conflicts. I.e. please try
> merging with arm-soc for-next to see how bad it is:

OK, there were bad conflicts with two device tree patches.

So I'm going to take that stuff out and funnel through ARM SoC
instead.

I have a number of DT patches from Lee on a queues pull request
anyway, so I'll just stack these on top of that and then hopefully things
will fix themselves up.

> patch 11-14:
> Acked-by: Olof Johansson <olof@lixom.net>

Thanks, I took only 11, 12 into the pinctrl tree. It's better off
like this.

Yours,
Linus Walleij
