Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401Ab3IJLql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 07:46:41 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:55047 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3IJLqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 07:46:40 -0400
MIME-Version: 1.0
In-Reply-To: <10005394.BRCyBMYWy3@tauon>
References: <10005394.BRCyBMYWy3@tauon>
Date: Tue, 10 Sep 2013 13:46:40 +0200
X-Google-Sender-Auth: hBTyXUkLh_EU5MIrePolY9krU1Y
Message-ID: <CAMuHMdUGk7SL+NaZ0nHzMumiS6u5f=-au=6-8uqsPY1x1HKP5A@mail.gmail.com>
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many architectures
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephan Mueller <smueller@chronox.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        dave.taht@bufferbloat.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 1:31 PM, Stephan Mueller <smueller@chronox.de> wrote:
> /dev/random uses the get_cycles() function to obtain entropy in addition to jiffies and the event value of hardware events.
>
> Typically the high-resolution timer of get_cycles delivers the majority of entropy, because the event value is quite deterministic and jiffies are very coarse.
>
> However, on the following architectures, get_cycles will return 0:

> - M68K

Thanks, m68k is being worked on, cfr. https://lkml.org/lkml/2013/9/9/441

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
