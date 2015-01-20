Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbbATKkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:40:13 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34244 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbbATKkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:40:11 -0500
From: Peter Korsgaard <peter@korsgaard.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: "linux-gpio\@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Peter Korsgaard <jacmet@sunsite.dk>
Subject: Re: [PATCH 8/8] gpio/mpc8xxx: Use of_mm_gpiochip_remove
References: <1421581173-28416-1-git-send-email-ricardo.ribalda@gmail.com>
	<1421581173-28416-9-git-send-email-ricardo.ribalda@gmail.com>
	<87fvb69yec.fsf@dell.be.48ers.dk>
	<CAPybu_0nyzS6gYBBEEX7VY2t+xtsJ_uVjd=TEuuQGmSmUmboGA@mail.gmail.com>
Date: Tue, 20 Jan 2015 11:40:07 +0100
In-Reply-To: <CAPybu_0nyzS6gYBBEEX7VY2t+xtsJ_uVjd=TEuuQGmSmUmboGA@mail.gmail.com>
	(Ricardo Ribalda Delgado's message of "Tue, 20 Jan 2015 00:10:34
	+0100")
Message-ID: <87d26991mg.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Ricardo" == Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com> writes:

 > Hello Peter
 >> 
 >> > -    hwirq = irq_of_parse_and_map(np, 0);
 >> > -    if (hwirq == NO_IRQ)
 >> > +    mpc8xxx_gc->irqn = irq_of_parse_and_map(np, 0);
 >> > +    if (mpc8xxx_gc->irqn == NO_IRQ)
 >> >              return 0;
 >> 
 >> 
 >> With this return 0 converted to do of_mm_gpiochip_remove():

 > Are you sure? The driver can still work as a normal gpio without the
 > irq domain part and the remove function consider this option. The
 > original code did also continue....

Ahh yes, you are right. Sorry, it's been a while since I wrote that code
(2008).

 > If you still want to abort if no irq I can of course make the change.

No, it is fine.

-- 
Bye, Peter Korsgaard
