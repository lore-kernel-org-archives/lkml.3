Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab3HGThH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 15:37:07 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:41002 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757246Ab3HGThF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 15:37:05 -0400
MIME-Version: 1.0
In-Reply-To: <000301ce9285$510a2c90$f31e85b0$@samsung.com>
References: <000301ce9285$510a2c90$f31e85b0$@samsung.com>
Date: Wed, 7 Aug 2013 21:37:04 +0200
Message-ID: <CACRpkdaw=xiqk5aYuFStZhYWuvZOBvGdnqW4qyd0E83K=4J+iw@mail.gmail.com>
Subject: Re: [PATCH 3/3] pinctrl: sirf: add missing __iomem annotation
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Barry Song <baohua.song@csr.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 11:14 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> Added missing __iomem annotation in order to fix the following
> sparse warnings:
>
> drivers/pinctrl/sirf/pinctrl-sirf.c:846:14: warning: incorrect type in assignment (different address spaces)
> drivers/pinctrl/sirf/pinctrl-sirf.c:846:14:    expected void *regs
> drivers/pinctrl/sirf/pinctrl-sirf.c:846:14:    got void [noderef] <asn:2>*
> drivers/pinctrl/sirf/pinctrl-sirf.c:869:33: warning: incorrect type in assignment (different address spaces)
> drivers/pinctrl/sirf/pinctrl-sirf.c:869:33:    expected void [noderef] <asn:2>*regs
> drivers/pinctrl/sirf/pinctrl-sirf.c:869:33:    got void *regs
> drivers/pinctrl/sirf/pinctrl-sirf.c:909:17: warning: incorrect type in argument 1 (different address spaces)
> drivers/pinctrl/sirf/pinctrl-sirf.c:909:17:    expected void volatile [noderef] <asn:2>*addr
> drivers/pinctrl/sirf/pinctrl-sirf.c:909:17:    got void *regs
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Patch applied.

Yours,
Linus Walleij
