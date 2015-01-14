Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbbANNNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 08:13:45 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:64140 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbbANNNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 08:13:44 -0500
MIME-Version: 1.0
In-Reply-To: <1421057279-16081-2-git-send-email-geert+renesas@glider.be>
References: <1421057279-16081-1-git-send-email-geert+renesas@glider.be>
	<1421057279-16081-2-git-send-email-geert+renesas@glider.be>
Date: Wed, 14 Jan 2015 14:13:43 +0100
Message-ID: <CACRpkdbrz_4cCa4S2aaz0LxsoWvZn1_hPDagC_LH0e=wJ2Bzog@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: rcar: Fix error path for devm_kzalloc() failure
From: Linus Walleij <linus.walleij@linaro.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Alexandre Courbot <gnurou@gmail.com>, Magnus Damm <magnus.damm@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 11:07 AM, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:

> If the call to devm_kzalloc() fails, nothing must be cleant up.
> This was missed before because gpio_rcar_probe() had a "return"
> statement after the first "goto err0".
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Fixes: df0c6c80232f2ad4 ("gpio: rcar: Add minimal runtime PM support")

Patch applied.

Yours,
Linus Walleij
