Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab3C0VwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 17:52:08 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:50042 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab3C0VwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 17:52:06 -0400
MIME-Version: 1.0
In-Reply-To: <1363351927.16666.2.camel@phoenix>
References: <1363351927.16666.2.camel@phoenix>
Date: Wed, 27 Mar 2013 22:52:06 +0100
Message-ID: <CACRpkdbogB+Yv-1oCXr1g+XSzBcWcES0RK5UdvBM18xO0dT1Fw@mail.gmail.com>
Subject: Re: [PATCH] gpio: pl061: Add pl061_gpio_free()
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 1:52 PM, Axel Lin <axel.lin@ingics.com> wrote:

> commit 39b70ee051 "gpio: pl061: bind pinctrl by gpio request"
> adds pl061_gpio_request() to request pinctrl.
> Thus we need to add corresponding pl061_gpio_free() to free the pin.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Excellent catch Axel (as usual).

Correct Haojian?

Patch applied.

Yours,
Linus Walleij
