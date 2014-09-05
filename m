Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbaIEJhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 05:37:19 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:35675 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183AbaIEJhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:37:16 -0400
MIME-Version: 1.0
In-Reply-To: <1409840819-18976-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1409840819-18976-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1409840819-18976-2-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Fri, 5 Sep 2014 11:37:14 +0200
X-Google-Sender-Auth: TvE7FJjKAMn90tHTcjXyimvX7iQ
Message-ID: <CAMuHMdXQ953Cx-MNSvWCKbQhezxr31bpAHo4JMJBK6dCoOQwnw@mail.gmail.com>
Subject: Re: [PATCH v4 01/12] hexdump: introduce test suite
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Marek Vasut <marex@denx.de>,
        Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
        Benjamin Romer <benjamin.romer@unisys.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Chen Gang <gang.chen.5i5j@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 4:26 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Test different scenarios of function calls located in lib/hexdump.c.
>
> Currently hex_dump_to_buffer() is only tested and test data is provided for
> little endian CPUs.

That's a nice one to be amended using Chen's
"arch: Kconfig: Let all little endian architectures define
CPU_LITTLE_ENDIAN explicitly".

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
