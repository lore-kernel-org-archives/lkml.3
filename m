Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbaKLOyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:54:05 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:38175 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbaKLOyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:54:03 -0500
MIME-Version: 1.0
In-Reply-To: <1415100672-31425-1-git-send-email-linus.walleij@linaro.org>
References: <1415100672-31425-1-git-send-email-linus.walleij@linaro.org>
Date: Wed, 12 Nov 2014 15:54:02 +0100
Message-ID: <CACRpkdZUZJmSrHVH4BbNbANgN-BphYL_wCF=6QdXndXdXYXiZg@mail.gmail.com>
Subject: Re: [PATCH] power: reset: augment versatile driver for integrator
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 12:31 PM, Linus Walleij <linus.walleij@linaro.org> wrote:

> Augment the Versatile reset driver to also handle the core
> module reset sequence used on the Integrator/AP and
> Integrator/CP.
>
> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Sebastian Reichel <sre@kernel.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Sebastian: please merge this into your power tree if you're
> OK with it, the corresponding platform changes are orthogonal
> so these can go separately through the ARM SoC tree.

Power folks: ping on this patch.

Yours,
Linus Walleij
