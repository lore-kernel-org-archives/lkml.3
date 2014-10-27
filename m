Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaJ0P13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:27:29 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:39836 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaJ0P12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:27:28 -0400
MIME-Version: 1.0
In-Reply-To: <1412157780-32219-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1412157780-32219-1-git-send-email-pramod.gurav@smartplayin.com>
Date: Mon, 27 Oct 2014 16:27:27 +0100
Message-ID: <CACRpkdZjqLUMVGZzqkK+E+0BBquu8fw-=6FivFzmO8cUnZe5dw@mail.gmail.com>
Subject: Re: [PATCH] gpio: amd8111: unmap ioport on failure case
From: Linus Walleij <linus.walleij@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2014 at 12:03 PM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:

> This change unmaps ioport when gpiochip_add fails
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: linux-gpio@vger.kernel.org
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

Patch applied. Sorry for disproportionate delays...

Yours,
Linus Walleij
