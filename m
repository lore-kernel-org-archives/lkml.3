Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab3KNKOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 05:14:43 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34290 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab3KNKOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 05:14:38 -0500
MIME-Version: 1.0
In-Reply-To: <20131106234737.8971.37405.sendpatchset@w520>
References: <20131106234737.8971.37405.sendpatchset@w520>
Date: Thu, 14 Nov 2013 11:14:37 +0100
X-Google-Sender-Auth: gwNyYMud7_jibHAQvjiEJArHQVg
Message-ID: <CAMuHMdUw1P91DeAUOQSXLD7dxG4sR8sUOZTMSFEAayi6ZVN7Hw@mail.gmail.com>
Subject: Re: [PATCH] gpio: Renesas RZ GPIO driver
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 7, 2013 at 12:47 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
> The hardware allows control of GPIOs in blocks of up to 16 pins,
> and once device may span multiple blocks. Interrupts are not

... one device ...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
