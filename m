Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759811Ab3HOUEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 16:04:16 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:56594 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758205Ab3HOUEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 16:04:14 -0400
MIME-Version: 1.0
In-Reply-To: <201308141359.54473.heiko@sntech.de>
References: <201308141359.13872.heiko@sntech.de>
	<201308141359.54473.heiko@sntech.de>
Date: Thu, 15 Aug 2013 22:04:14 +0200
Message-ID: <CACRpkdboWnsRRUEEufQY_=x3bWKyZLoWP5G_YvEhtTtZs6BTuw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] ARM: S3C24XX: number the dma clocks
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Dan Williams <djbw@fb.com>,
        Vinod Koul <vinod.koul@intel.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 1:59 PM, Heiko Stübner <heiko@sntech.de> wrote:

> Each dma channel has its own clock. The upcoming dma driver wants to
> handle these itself and therefore needs to be able to get the correct
> clock for a channel.
>
> Therefore rename the dma clocks to "dma.X" for s3c2412, s3c2416 and
> s3c2443. This does not change the behaviour for the old dma driver at
> all, as all dma clocks are still always on and not handled by the old
> dma driver at all.
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> are always enabled in the original code.
> ---

There is some noise at the end of your commit message.

Yours,
Linus Walleij
