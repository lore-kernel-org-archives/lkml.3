Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbbASXK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 18:10:58 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:56373 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbbASXK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 18:10:56 -0500
MIME-Version: 1.0
In-Reply-To: <87fvb69yec.fsf@dell.be.48ers.dk>
References: <1421581173-28416-1-git-send-email-ricardo.ribalda@gmail.com>
 <1421581173-28416-9-git-send-email-ricardo.ribalda@gmail.com> <87fvb69yec.fsf@dell.be.48ers.dk>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 20 Jan 2015 00:10:34 +0100
Message-ID: <CAPybu_0nyzS6gYBBEEX7VY2t+xtsJ_uVjd=TEuuQGmSmUmboGA@mail.gmail.com>
Subject: Re: [PATCH 8/8] gpio/mpc8xxx: Use of_mm_gpiochip_remove
To: Peter Korsgaard <peter@korsgaard.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Peter Korsgaard <jacmet@sunsite.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter


>
>  > -    hwirq = irq_of_parse_and_map(np, 0);
>  > -    if (hwirq == NO_IRQ)
>  > +    mpc8xxx_gc->irqn = irq_of_parse_and_map(np, 0);
>  > +    if (mpc8xxx_gc->irqn == NO_IRQ)
>  >              return 0;
>
>
> With this return 0 converted to do of_mm_gpiochip_remove():

Are you sure? The driver can still work as a normal gpio without the
irq domain part and the remove function consider this option. The
original code did also continue....

If you still want to abort if no irq I can of course make the change.

Regards!

>
> Acked-by: Peter Korsgaard <peter@korsgaard.com>
>
> --
> Bye, Peter Korsgaard

Regards



-- 
Ricardo Ribalda
