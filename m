Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbaE1HVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:21:30 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:41551 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbaE1HV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:21:29 -0400
MIME-Version: 1.0
In-Reply-To: <1400824647-2525-2-git-send-email-george.cherian@ti.com>
References: <1400824647-2525-1-git-send-email-george.cherian@ti.com>
	<1400824647-2525-2-git-send-email-george.cherian@ti.com>
Date: Wed, 28 May 2014 09:21:28 +0200
Message-ID: <CACRpkdaDTeBhCaxeO0F8EMH7H5dZy1-mdiwgfVB-vXUU_Df=hA@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: pcf857x: Add IRQF_SHARED when request irq
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

> It's quite possible that multiple pcf857x can be hooked up
> to the same interrupt line with the processor. So add IRQF_SHARED
> in request irq..
>
> Signed-off-by: George Cherian <george.cherian@ti.com>

Patch applied.

Yours,
Linus Walleij
