Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbaE1HU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:20:26 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:55345 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbaE1HUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:20:23 -0400
MIME-Version: 1.0
In-Reply-To: <1400824647-2525-1-git-send-email-george.cherian@ti.com>
References: <1400824647-2525-1-git-send-email-george.cherian@ti.com>
Date: Wed, 28 May 2014 09:20:22 +0200
Message-ID: <CACRpkdbXqvMN4RF2XbN23jeQjWDC-hj=uUdLUfd1fDu-9DgNFw@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: pcf857x: Avoid calling irq_domain_cleanup twice
From: Linus Walleij <linus.walleij@linaro.org>
To: George Cherian <george.cherian@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 7:57 AM, George Cherian <george.cherian@ti.com> wrote:

> Currently irq_domain_cleanup is called twice if irq_domain_init fails.
> This causes the following crash.

Patch applied with Alex' ACK.

NB: this driver should be switched to the gpiolib irqchip helpers to
avoid fixing spurious bugs like this.

Yours,
Linus Walleij
