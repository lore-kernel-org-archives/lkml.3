Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbaEPPvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:51:10 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:36086 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbaEPPvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:51:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140514235232.57bbc9df@wiggum>
References: <1400103816-26086-1-git-send-email-berthe.ab@gmail.com>
	<20140514235232.57bbc9df@wiggum>
Date: Fri, 16 May 2014 17:51:07 +0200
Message-ID: <CACRpkdYD9_PqXMVHdG+QfO3-50+LBLdb7GbLObh7wFrfqN4XaQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: gpio-bt8xx: fix compilation warning
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: abdoulaye berthe <berthe.ab@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 11:52 PM, Michael Büsch <m@bues.ch> wrote:
> On Wed, 14 May 2014 23:43:36 +0200
> abdoulaye berthe <berthe.ab@gmail.com> wrote:
>
>> this fixes a compilation warning by checking
>> the retun value of gpiochip_remove()
>
>
> Really, I would rather change the gpiochip_remove return type to void.

Good point.

Dropping this patch in favor of real solution.

Yours,
Linus Walleij
