Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbaIZGbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 02:31:01 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:53868 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbaIZGa7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 02:30:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140925202559.GA1750@roeck-us.net>
References: <20140925202559.GA1750@roeck-us.net>
Date: Fri, 26 Sep 2014 08:30:57 +0200
X-Google-Sender-Auth: LEh9lFjbIvbHd6r1Vs8UHGhKpY4
Message-ID: <CAMuHMdXE4aU1qZ9iGBT48QfMv5v7gsBZSjL_1_D8p=JBJfeN6A@mail.gmail.com>
Subject: Re: linux-next: New build failures in Sep 25 tree
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux <linux@openrisc.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Günther,

[cc openrisc]

On Thu, Sep 25, 2014 at 10:25 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> New build failures:

> openrisc-defconfig
>
> In file included from arch/openrisc/kernel/signal.c:31:0:
> ./arch/openrisc/include/asm/syscall.h: In function 'syscall_get_arch':
> ./arch/openrisc/include/asm/syscall.h:77:9: error: 'EM_OPENRISC' undeclared

That's not a new one. It's been failing for half or year or so.

If you only see it now, that means something else got fixed ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
