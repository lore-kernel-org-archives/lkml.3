Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbaEPPCE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:02:04 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:35333 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498AbaEPPB7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:01:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140430111308.GA11829@linutronix.de>
References: <1395505004-22650-1-git-send-email-bigeasy@linutronix.de>
	<1395505004-22650-7-git-send-email-bigeasy@linutronix.de>
	<5331F6D5.7070809@gmail.com>
	<53427718.30406@linutronix.de>
	<CANk1AXSuBGj3vZ7knKmHTwDZLTkvVFT42Lt9ZTdk-E+sp=xQ+g@mail.gmail.com>
	<20140430111308.GA11829@linutronix.de>
Date: Fri, 16 May 2014 17:01:58 +0200
Message-ID: <CACRpkdY=oVyBCwRkppq11B0tkn2bMw+-h_fDhy538eatVUJ=pQ@mail.gmail.com>
Subject: Re: [PATCH 6/7 v2] gpio: dwapb: use a second irq chip
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: delicious quinoa <delicious.quinoa@gmail.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
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

OK this patch is ACKed by Alan so I would like to apply it but:

Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This is not good. Quoted-printable makes the raw patch look like
that:

- int err, irq;
+ int err, irq, i;
=20
  irq =3D irq_of_parse_and_map(node, 0);

Notice spurious =20 and =3D encoding.

Please resend in ISO8859-1 and take this opportunity to add
Alan's ACK.

Yours,
Linus Walleij
