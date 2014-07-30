Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaG3I2D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 04:28:03 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:62515 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaG3I17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 04:27:59 -0400
MIME-Version: 1.0
In-Reply-To: <1406647011-8543-7-git-send-email-Julia.Lawall@lip6.fr>
References: <1406647011-8543-1-git-send-email-Julia.Lawall@lip6.fr> <1406647011-8543-7-git-send-email-Julia.Lawall@lip6.fr>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 30 Jul 2014 17:27:38 +0900
Message-ID: <CAAVeFuLZb3CVV6B771V3-mzYdp0zsxaBfAAdikQDMBxSZTPTjA@mail.gmail.com>
Subject: Re: [PATCH 6/9] gpiolib: devres: use correct structure type name in sizeof
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Linus Walleij <linus.walleij@linaro.org>, kernel-janitors@vger.kernel.org,
        linux-ia64@vger.kernel.org, ceph-devel@vger.kernel.org,
        toralf.foerster@gmx.de, hmh@hmh.eng.br,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 12:16 AM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Correct typo in the name of the type given to sizeof.  Because it is the
> size of a pointer that is wanted, the typo has no impact on compilation or
> execution.
>
> This problem was found using Coccinelle (http://coccinelle.lip6.fr/).  The
> semantic patch used can be found in message 0 of this patch series.

Acked-by: Alexandre Courbot <acourbot@nvidia.com>

Interestingly the compiler never complains despite gpiod_desc not
being a declared type...

Thanks!
