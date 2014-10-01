Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372AbaJAHnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:43:23 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:62668 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaJAHnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:43:22 -0400
MIME-Version: 1.0
In-Reply-To: <1412086542-1662-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1412086542-1662-1-git-send-email-pramod.gurav@smartplayin.com>
Date: Wed, 1 Oct 2014 09:43:21 +0200
Message-ID: <CACRpkdaCcaNmv=fciiVJdmu3M7-dhqjqgAuP6eeJkkfptFbA1Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: remove remaining users of gpiochip_remove() retval
From: Linus Walleij <linus.walleij@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 4:15 PM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:

> Some driver in gpio still check for return value from gpiochip_remove
> Get rid of the check for return value.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: linux-gpio@vger.kernel.org
>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

This is already fixed in the GPIO tree, and in linux-next.

I have got more patches like this from other people, and cannot
quite understand what kind of tree you are actually looking at?

Yours,
Linus Walleij
