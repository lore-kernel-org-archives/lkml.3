Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367AbaGXQVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 12:21:16 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:44060 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759002AbaGXQVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 12:21:12 -0400
MIME-Version: 1.0
In-Reply-To: <1406181062-29596-1-git-send-email-acourbot@nvidia.com>
References: <1406181062-29596-1-git-send-email-acourbot@nvidia.com>
Date: Thu, 24 Jul 2014 18:21:12 +0200
Message-ID: <CACRpkdaLokvZwb_tPdj21iF25AOJ_K6gWA5QK_VVz2Z4U9stkA@mail.gmail.com>
Subject: Re: [PATCH] gpio: remove gpio_ensure_requested()
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 7:51 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> gpio_ensure_requested() has been introduced in Feb. 2008 by commit
> d2876d08d86f2 to force users of the GPIO API to explicitly request GPIOs
> before using them.
>
> Hopefully by now all GPIOs are correctly requested and this extra check
> can be omitted ; in any case the GPIO maintainers won't feel bad if
> machines start failing after 6 years of warnings.
>
> This patch removes that function from the dark ages.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Hm you took the opportunity to also refactor the debounce ops
to static inlines, I see why though so patch applied!

Yours,
Linus Walleij
