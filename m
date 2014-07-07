Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaGGKzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 06:55:23 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:58061 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbaGGKzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 06:55:20 -0400
MIME-Version: 1.0
In-Reply-To: <1401995603-25997-1-git-send-email-andrew.ruder@elecsyscorp.com>
References: <1401995603-25997-1-git-send-email-andrew.ruder@elecsyscorp.com>
Date: Mon, 7 Jul 2014 12:55:19 +0200
Message-ID: <CACRpkdYX-k3bwcCNibxX7wrrZDo6eJ8GrU+yv79tJvz4hWRPOA@mail.gmail.com>
Subject: Re: [PATCH] gpio-pxa: gpio0 and gpio1 support on dt
From: Linus Walleij <linus.walleij@linaro.org>
To: Andrew Ruder <andrew.ruder@elecsyscorp.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 9:13 PM, Andrew Ruder
<andrew.ruder@elecsyscorp.com> wrote:

> pxa_gpio_probe() has some issues supporting the gpio0 and gpio1
> interrupts under device-tree - it never actually sets up the chain
> handler to get interrupts on edge detect for GPIO0 and GPIO1.
>
> Signed-off-by: Andrew Ruder <andrew.ruder@elecsyscorp.com>

Patch applied with Haojian's ACK.

Yours,
Linus Walleij
