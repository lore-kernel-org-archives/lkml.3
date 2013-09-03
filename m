Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005Ab3ICQla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:41:30 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:59497 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab3ICQl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:41:28 -0400
MIME-Version: 1.0
In-Reply-To: <52005571.4080704@asianux.com>
References: <52005571.4080704@asianux.com>
Date: Tue, 3 Sep 2013 18:41:27 +0200
X-Google-Sender-Auth: lkj7jpBQ4dVTJx1l0lz2zEYBU_I
Message-ID: <CAMuHMdXq3kY=xv7Rp5+OUTjefViNMTBzGAoutamuY07=cbRhNg@mail.gmail.com>
Subject: Re: [PATCH trivial] UAPI: Kbuild: add/modify comments for
 "uapi/Kbuild" and "uapi/linux/Kbuild"
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 3:46 AM, Chen Gang <gang.chen@asianux.com> wrote:
> --- a/include/uapi/Kbuild
> +++ b/include/uapi/Kbuild
> @@ -1,7 +1,6 @@
>  # UAPI Header export list
> -# Top-level Makefile calls into asm-$(ARCH)
> -# List only non-arch directories below
> -
> +# Except "linux/", UAPI means Universal API.

Sorry for my silly question, but what's the purpose of this "Universal
API" comment?

> +# For "linux/", UAPI means User API which can be used by user mode.
>
>  header-y += asm-generic/
>  header-y += linux/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
