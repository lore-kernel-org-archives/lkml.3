Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbaE0OVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:21:21 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:54420 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbaE0OVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:21:17 -0400
MIME-Version: 1.0
In-Reply-To: <1401137894-6096-1-git-send-email-bigeasy@linutronix.de>
References: <CACRpkdY=oVyBCwRkppq11B0tkn2bMw+-h_fDhy538eatVUJ=pQ@mail.gmail.com>
	<1401137894-6096-1-git-send-email-bigeasy@linutronix.de>
Date: Tue, 27 May 2014 16:21:16 +0200
Message-ID: <CACRpkdYx9Zwoig5QZmpF1w_Gcyoga8erPZd0RwvHsiC3prjNTA@mail.gmail.com>
Subject: Re: [PATCH v3] gpio: dwapb: use a second irq chip
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Jamie Iles <jamie@jamieiles.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Alan Tull <atull@altera.com>, Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 10:58 PM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:

> Right new have one irq chip running always in level mode. It would nicer
> to have two irq chips where one is handling level type interrupts and
> the other one is doing edge interrupts. So we can have at runtime two users
> where one is using edge and the other level.
>
> Acked-by: Alan Tull <delicious.quinoa@gmail.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> v2..v3: added acked-by
> v1..v2 - using the lopp again but breaking the assignment of type and
>         handler out of the loop as suggested by delicious quinoa.

OK this version applied worked fine.

Please check the result because I had to rebase it a little.

Yours,
Linus Walleij
