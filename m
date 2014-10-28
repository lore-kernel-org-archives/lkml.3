Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbaJ1PNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:13:53 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:54854 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbaJ1PNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:13:51 -0400
MIME-Version: 1.0
In-Reply-To: <1412188684-20820-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1412188684-20820-1-git-send-email-pramod.gurav@smartplayin.com>
Date: Tue, 28 Oct 2014 16:13:50 +0100
Message-ID: <CACRpkdaX2OmTbUw3ZWV8q6P0vqMa60cOJjPCmK2H0czrty_fXQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: grgpio: remove irq_domain resources on failure
From: Linus Walleij <linus.walleij@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2014 at 8:38 PM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:

> Call irq_domain_remove when gpiochip_add fails to release irq_domain
> resources.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: linux-gpio@vger.kernel.org
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

Patch applied.

This driver is doing really weird stuff in it's IRQ remapping business...

Yours,
Linus Walleij
