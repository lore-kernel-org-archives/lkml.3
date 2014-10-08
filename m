Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbaJHMcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 08:32:05 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:51862 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172AbaJHMbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 08:31:49 -0400
MIME-Version: 1.0
In-Reply-To: <1412087693-8277-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1412087693-8277-1-git-send-email-pramod.gurav@smartplayin.com>
Date: Wed, 8 Oct 2014 14:31:48 +0200
Message-ID: <CACRpkdYneTDfzd_Y8UMnEpvA9r4rJjKtyzme9VTadT8U_C8SWw@mail.gmail.com>
Subject: Re: [PATCH 1/2] input: remove use of gpiochip_remove() retval
From: Linus Walleij <linus.walleij@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Input <linux-input@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 4:34 PM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:

> Get rid of using return value from gpiochip_remove() as it returns
> void.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: linux-input@vger.kernel.org
> Cc: linux-gpio@vger.kernel.org
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

A similar patch is already ACKed by Dmitry and merged in the GPIO tree.

Yours,
Linus Walleij
