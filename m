Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461Ab3KRJe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 04:34:27 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:50747 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab3KRJeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 04:34:21 -0500
MIME-Version: 1.0
In-Reply-To: <1384605261-8682-1-git-send-email-acourbot@nvidia.com>
References: <1384605261-8682-1-git-send-email-acourbot@nvidia.com>
Date: Mon, 18 Nov 2013 10:34:20 +0100
Message-ID: <CACRpkdZc0DWHe6AmawYp=SY=5==SUuJUHDETUTDw-6PbhR3tUg@mail.gmail.com>
Subject: Re: [PATCH v2] Documentation: gpiolib: document new interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Rob Landley <rob@landley.net>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 16, 2013 at 1:34 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> The first version received zero feedback, hopefully this one will get more
> attention. :) Not much changes, just some more proofreading and the fixes
> and improvements that came from it. It looks ok as far as I am concerned.

Sorry I was swamped with other stuff...

> Linus, I hope this can be merged during the -rc cycle of 3.13, since the
> gpiod_ interface is going to be introduced there. It would not make much
> sense for it to come without its documentation.

You're right of course. I'll read through it and apply fixes on top
(or squash into your patch.)

Formal stuff:
Don't we need an 00-INDEX file?
(Maybe Rob can tell whether this is desirable.)

I don't like double spaces after periods. I will just go and remove
all of them from the new documentation unless you convince me
otherwise. Reference:
https://en.wikipedia.org/wiki/Sentence_spacing

Linus
