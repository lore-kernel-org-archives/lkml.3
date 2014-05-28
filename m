Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbaE1I5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:57:19 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:36709 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbaE1I5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:57:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140527153456.GL4730@lukather>
References: <1399621082-10712-1-git-send-email-linus.walleij@linaro.org>
	<20140527153456.GL4730@lukather>
Date: Wed, 28 May 2014 10:57:16 +0200
Message-ID: <CACRpkda5tnDFgOFUk6GL58s-fWZmRfCLiBvbOqNgwrYVFNWySA@mail.gmail.com>
Subject: Re: [PATCH] RFT: pinctrl: sunxi: convert to GPIO irqchip helpers
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 5:34 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> I've been quite late at testing this, I'm sorry, but I finally gave it
> a try.
>
> Besides the minor glitches here and there that were expected, I think
> that it can't really work now given the state of gpiolib_irqchip.

OK I buy that, it was a nice try from my side :-)

Now let's drop this patch to the floor and accept that the sunxi
gpio irqs are complex and cannot be handled by simple helpers.

Thanks a lot for testing the code though!

Yours,
Linus Walleij
