Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbaBLQUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:20:55 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38987 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbaBLQUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:20:51 -0500
MIME-Version: 1.0
In-Reply-To: <CAAVeFuJ6BP4JnVb6qD1DYXqPQ3zBKw8hb+xLqcmUjktOxAjdGA@mail.gmail.com>
References: <1392044614-6837-1-git-send-email-jjhiblot@traphandler.com>
	<CAAVeFuJ6BP4JnVb6qD1DYXqPQ3zBKw8hb+xLqcmUjktOxAjdGA@mail.gmail.com>
Date: Wed, 12 Feb 2014 17:20:51 +0100
Message-ID: <CACRpkdbZ0LJorKN_ydk=8KBkyHToYZVAj7xUCYkU=Agtb4sVrA@mail.gmail.com>
Subject: Re: [PATCH] gpio: take in account the active low flag when
 configuring the gpio as an ouput
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Richard Genoud <richard.genoud@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 5:22 AM, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Tue, Feb 11, 2014 at 12:03 AM, Jean-Jacques Hiblot
> <jjhiblot@traphandler.com> wrote:
>> The initial value of the gpio is passed to gpiod_direction_output. Currently
>> this value is the raw value of the GPIO line, but it should be the logical
>> value.
>
> I think we have a patch that already does this:
>
> http://www.kernelhub.org/?msg=390263&p=2
>
> Linus said it would be merged for 3.15, but I am not seeing it in -next. Linus?

I just haven't queued my devel branch for next yet. Will do
today now that I sent a batch of fixes to Torvalds.

Yours,
Linus Walleij
