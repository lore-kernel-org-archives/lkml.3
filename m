Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbaGAIBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 04:01:41 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:56944 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbaGAIBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 04:01:40 -0400
MIME-Version: 1.0
In-Reply-To: <1404201524-7568-1-git-send-email-geert@linux-m68k.org>
References: <1404201524-7568-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 1 Jul 2014 10:01:38 +0200
X-Google-Sender-Auth: z8zDlgvLKss6mHH5rG5fPKWtvYw
Message-ID: <CAMuHMdXrvFRRESU7T-nk8WkNgrTSvOvyywMjcRC=OQH7CbbQjw@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.16-rc3
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2014 at 9:58 AM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.16-rc3[1]  to v3.16-rc2[3], the summaries are:
>   - build errors: +5/-63

  + /scratch/kisskb/src/kernel/bounds.c: error: -mcall-aixdesc must be
big endian:  => 1:0
  + /scratch/kisskb/src/scripts/mod/devicetable-offsets.c: error:
-mcall-aixdesc must be big endianmake[3]: :  => 1:0
  + /scratch/kisskb/src/scripts/mod/empty.c: error: -mcall-aixdesc
must be big endian:  => 1:0
  + <stdin>: error: -mcall-aixdesc must be big endian:  => 1:0

powerpc-randconfig

  + error: misc.c: undefined reference to `ftrace_likely_update':  =>
.text+0x22c), .text+0x898)

sh-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/7619/ (all 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/7595/ (all 119 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
