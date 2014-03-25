Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbaCYUpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 16:45:30 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:61025 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121AbaCYUp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:45:27 -0400
MIME-Version: 1.0
In-Reply-To: <1395505004-22650-1-git-send-email-bigeasy@linutronix.de>
References: <1395505004-22650-1-git-send-email-bigeasy@linutronix.de>
Date: Tue, 25 Mar 2014 21:45:26 +0100
Message-ID: <CACRpkdbFj+Msq5HjcV8N5A6TN9sic1+Y2v9aWAMa2g+0zO=D1Q@mail.gmail.com>
Subject: Re: dwapb: a bug fix a few cleanups, v2
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jamie Iles <jamie@jamieiles.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Alan Tull <atull@altera.com>, Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Alan Tull <delicious.quinoa@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2014 at 5:16 PM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:

> Since Alan said that he had drop two patches from earlier series to make
> it work I decided to spent some extra time to check if this is really the
> case.
> I dropped "gpio: dwapb: do not create the irq mapping upfront." until the
> discussion there is over.
>
> This series has been tested back ported and tested on a v3.13 kernel with
> the dummy test [0] here. It was tested on the Arrow board and the dev kit. I
> tested edge and level interrupts. On the Arrow board releasing the button
> causes a lot of interrupts so I assume debouncing is no working well
> there. On the dev kit I see only one interrupt. If I realse it really
> slowly, then the extra interrupts are visible there as well but way less.
>
> [0] http://breakpoint.cc/gpio-dwapb-test.c

Okay so can we have Jamie and Sebastian H. have a look at this
series?

Yours,
Linus Walleij
