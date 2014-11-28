Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbaK1Noq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:44:46 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:37920 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaK1Non convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:44:43 -0500
MIME-Version: 1.0
In-Reply-To: <1416903391-12693-1-git-send-email-acourbot@nvidia.com>
References: <5474391F.6030908@nvidia.com>
	<1416903391-12693-1-git-send-email-acourbot@nvidia.com>
Date: Fri, 28 Nov 2014 14:44:42 +0100
Message-ID: <CACRpkdZ9Hzkzk6SfLcrJTiNv5pYAjDZD3X=BSYU1BMiC-RLvHg@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: remove const modifier from gpiod_get_direction()
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 9:16 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Although gpiod_get_direction() can be considered side-effect free for
> consumers, its internals involve setting or clearing bits in the
> affected GPIO descriptor, for which we need to force-cast the const
> descriptor variable to non-const. This could lead to incorrect behavior
> if the compiler decides to optimize here, so remove this const
> attribute. The intent is to make gpiod_get_direction() private anyway,
> so it does not really matter.
>
> Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Changes since v1:
> - Fixed poor grammar in commit log
> - Added Uwe's Ack

Patch applied after crying blood of the quoted-printable encoding
of this mail.

Yours,
Linus Walleij
