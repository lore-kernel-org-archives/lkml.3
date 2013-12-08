Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab3LHKQI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 05:16:08 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:37433 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab3LHKQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 05:16:04 -0500
MIME-Version: 1.0
In-Reply-To: <CABMQnV+mYYmSKK6ayeDbaiOnNSOgUhN4TjZV50eYmQwaQ3rHhQ@mail.gmail.com>
References: <1369815408-12719-1-git-send-email-geert@linux-m68k.org>
	<CABMQnV+mYYmSKK6ayeDbaiOnNSOgUhN4TjZV50eYmQwaQ3rHhQ@mail.gmail.com>
Date: Sun, 8 Dec 2013 11:16:02 +0100
X-Google-Sender-Auth: lkOKMXH9u0lZ3qhr2jbFv8X47fE
Message-ID: <CAMuHMdVLjruEChvHjzTLuNqaR9YpDG7hQ7Ukbwrm4phmm6HfNA@mail.gmail.com>
Subject: Re: [PATCH/RFC] sh: Always link in helper functions extracted from libgcc
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Cc: Paul Mundt <lethal@linux-sh.org>, Linux-sh <linux-sh@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Iwamatsu-san,

On Thu, Dec 5, 2013 at 7:49 AM, Nobuhiro Iwamatsu
<nobuhiro.iwamatsu.yj@renesas.com> wrote:
> I was just creating a patch as your patch.... I noticed your patch by chance.
> I think your proposal is good.
>
> But Paul does not maintain the SH tree.
> Andrew, Could you pickup this patch ?

As Andrew wasn't CCed on the original submission, I forwarded the original
patch to him.

> Tested-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
> Reviewed-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
