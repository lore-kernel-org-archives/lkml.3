Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab3CAAne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:43:34 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:49190 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab3CAAnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:43:32 -0500
MIME-Version: 1.0
In-Reply-To: <201302220926.r1M9Q3wV029855@localhost.localdomain>
References: <201302220926.r1M9Q3wV029855@localhost.localdomain>
Date: Fri, 1 Mar 2013 01:43:32 +0100
Message-ID: <CACRpkdY1M8w7o8S4idAx1JN-fc-t221qF_uwR5U9RBsBAn=Jhw@mail.gmail.com>
Subject: Re: [PATCH] Adds support for Open Firmware in MAX730x GPIO Driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Patrick Vasseur <patrick.vasseur@c-s.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 10:26 AM, Christophe Leroy
<christophe.leroy@c-s.fr> wrote:

> This patch allows the use of the MAX730x Driver on systems using
> the Open Firmware platform format
>
> Signed-off-by: Patrick Vasseur <patrick.vasseur@c-s.fr>
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

(...)
>         /* bits_per_word cannot be configured in platform data */
> -       spi->bits_per_word = 16;
> +       if (spi->dev.platform_data)
> +               spi->bits_per_word = 16;

What about just fixing so you *can* specify that instead?
The comment looks more like a FIXME to me.

Yours,
Linus Walleij
