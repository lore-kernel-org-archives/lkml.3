Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab3GIICP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 04:02:15 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:61177 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab3GIICI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 04:02:08 -0400
MIME-Version: 1.0
In-Reply-To: <1368850897.18069.255@driftwood>
References: <1368850897.18069.255@driftwood>
Date: Tue, 9 Jul 2013 10:02:06 +0200
X-Google-Sender-Auth: u9Wi_N7jcOylGW365sTsshQi7fA
Message-ID: <CAMuHMdX0aP7jm=2vAO=Mg9b-RggynRq+BosvzGfqSRtnyue4+w@mail.gmail.com>
Subject: Re: 3.10-rc1: commit ccdfcc398594 broke uClibc build.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>, linux-net@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Widening the audience...

On Sat, May 18, 2013 at 6:21 AM, Rob Landley <rob@landley.net> wrote:
> The #include <linux/kernel.h> added to include/uapi/linux/netlink.h causes
> the uClibc build to go:
>
> In file included from include/linux/kernel.h:4,
>                  from include/linux/netlink.h:4,
>                  from include/linux/rtnetlink.h:5,
>                  from libc/inet/netlinkaccess.h:27,
>                  from libc/inet/if_index.c:37:
> include/linux/sysinfo.h:8: error: expected specifier-qualifier-list before
> '__kernel_long_t'
> make: *** [libc/inet/if_index.o] Error 1
>
> If I comment out that line, it builds fine. The kernel builds (for my
> config) either way.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
