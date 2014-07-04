Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031676AbaGDWgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:36:37 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:64557 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031207AbaGDWgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:36:00 -0400
MIME-Version: 1.0
In-Reply-To: <1401906155-10543-2-git-send-email-berthe.ab@gmail.com>
References: <CAAVeFuLMLfa-1RhcdSrKDUz7=eLqZurBSFSsN7N0x-0S+_btJA@mail.gmail.com>
	<1401906155-10543-1-git-send-email-berthe.ab@gmail.com>
	<1401906155-10543-2-git-send-email-berthe.ab@gmail.com>
Date: Sat, 5 Jul 2014 00:35:59 +0200
Message-ID: <CACRpkdZz+BZHuMY8pB4Ooq0-L-=fjW=OeUOnnS7D3Adzt=dbhQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: removes all usage of gpiochip_remove retval
From: Linus Walleij <linus.walleij@linaro.org>
To: abdoulaye berthe <berthe.ab@gmail.com>
Cc: Alexandre Courbot <gnurou@gmail.com>, Michael Buesch <m@bues.ch>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 8:22 PM, abdoulaye berthe <berthe.ab@gmail.com> wrote:

> This patch updates users of gpiochip_remove return value.
>
> Signed-off-by: abdoulaye berthe <berthe.ab@gmail.com>

I'm scared by the number of sites this patch hits...

BUT it does the right thing.

However it does not apply to the GPIO tree "devel" branch
so please rebase this patch on top of that.
git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git#devel

Yours,
Linus Walleij
