Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaJBHVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 03:21:55 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:33971 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbaJBHVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 03:21:53 -0400
MIME-Version: 1.0
In-Reply-To: <1412143069-18562-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1412143069-18562-1-git-send-email-pramod.gurav@smartplayin.com>
Date: Thu, 2 Oct 2014 09:21:52 +0200
Message-ID: <CACRpkdZkXjTNo6koF3wn9q-tsBQkOu8+5Q7A+qku0Od_YWULjw@mail.gmail.com>
Subject: Re: [PATCH] serial: remove use of gpiochip_remove() retval
From: Linus Walleij <linus.walleij@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2014 at 7:57 AM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:

> Get rid of using return value from gpiochip_remove() as it returns
> void with a new change in kernel.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: linux-serial@vger.kernel.org
> Cc: linux-gpio@vger.kernel.org
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

NACK.

Already fixed through the GPIO tree.

Yours,
Linus Walleij
