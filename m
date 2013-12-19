Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab3LSUo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:44:27 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:60743 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756650Ab3LSUoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:44:23 -0500
MIME-Version: 1.0
In-Reply-To: <52B349B5.6090200@infradead.org>
References: <20131219165106.73f28ea8aa1bd059423cb5f8@canb.auug.org.au>
	<52B349B5.6090200@infradead.org>
Date: Thu, 19 Dec 2013 21:44:22 +0100
X-Google-Sender-Auth: n6IUWvkhBq7RZsPotVSq2nY9cSA
Message-ID: <CAMuHMdXdz5numoe_8SzYy_AN4++c2c_uqPtbdhq9kzTdLN=7+g@mail.gmail.com>
Subject: Re: linux-next: Tree for Dec 19 (target)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 8:32 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 12/18/13 21:51, Stephen Rothwell wrote:
>> Changes since 20131218:
> on i386:
>
> drivers/built-in.o: In function `target_alua_state_check':
> (.text+0x3fc859): undefined reference to `__udivdi3'

I believe this is already fixed in today's tree (it also happened on m68k
and mips).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
