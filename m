Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbaEILqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:46:11 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:37587 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaEILqJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:46:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140430111308.GA11829@linutronix.de>
References: <1395505004-22650-1-git-send-email-bigeasy@linutronix.de>
	<1395505004-22650-7-git-send-email-bigeasy@linutronix.de>
	<5331F6D5.7070809@gmail.com>
	<53427718.30406@linutronix.de>
	<CANk1AXSuBGj3vZ7knKmHTwDZLTkvVFT42Lt9ZTdk-E+sp=xQ+g@mail.gmail.com>
	<20140430111308.GA11829@linutronix.de>
Date: Fri, 9 May 2014 13:46:08 +0200
Message-ID: <CACRpkdb6wh9ah7ivNvU44j79LqFEVv-keAVxK8jO7h5LJsP5zg@mail.gmail.com>
Subject: Re: [PATCH 6/7 v2] gpio: dwapb: use a second irq chip
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Alan Tull <atull@altera.com>, Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 1:13 PM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:

> Right new have one irq chip running always in level mode. It would nicer
> to have two irq chips where one is handling level type interrupts and
> the other one is doing edge interrupts. So we can have at runtime two users
> where one is using edge and the other level.
>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> I am very sorry for the delay. I assumed that I've already fixed the
> patch sent it out. Just realized that it was not the case.
>
> v1…v2:
>     - using the lopp again but breaking the assignment of type and
>       handler out of the loop as suggested by delicious quinoa.

Can I have an ACK from Jamie &&|| Alan on this patch so I can apply
it?

Yours,
Linus Walleij
