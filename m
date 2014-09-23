Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbaIWPOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:14:03 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:58505 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaIWPOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:14:00 -0400
MIME-Version: 1.0
In-Reply-To: <1410703015-24127-1-git-send-email-fabf@skynet.be>
References: <1410703015-24127-1-git-send-email-fabf@skynet.be>
Date: Tue, 23 Sep 2014 17:13:59 +0200
Message-ID: <CACRpkdbZHLqfVZabm47tg9LDC7VS3XfB8zqs+d=0HroH-syMgQ@mail.gmail.com>
Subject: Re: [PATCH 1/1 linux-next] gpio: use container_of to resolve
 cs5535_gpio_chip from gpio_chip
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2014 at 3:56 PM, Fabian Frederick <fabf@skynet.be> wrote:

> Use container_of instead of casting first structure member.
>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> Compiled but untested.

Patch applied.
The existing code is unintelligible, so thanks a lot.

Yours,
Linus Walleij
