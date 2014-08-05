Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbaHEH04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 03:26:56 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:53465 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458AbaHEH0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 03:26:55 -0400
MIME-Version: 1.0
In-Reply-To: <1407222997-31109-1-git-send-email-geert@linux-m68k.org>
References: <1407222997-31109-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 5 Aug 2014 09:26:54 +0200
X-Google-Sender-Auth: un6lHnSpJrtMA2GEfXLNJ1xCN2Q
Message-ID: <CAMuHMdUekNbigyNeEps6Q_i0jsKVq=rUV-aD0JNRQYg53gYdyQ@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.16
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2014 at 9:16 AM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.16[1]  to v3.16-rc7[3], the summaries are:
>   - build errors: +3/-1

  + error: tpm_ibmvtpm.c: undefined reference to
`.__vio_register_driver':  => .init.text+0x6950)
  + error: tpm_ibmvtpm.c: undefined reference to
`.plpar_hcall_norets':  => .text+0xedc1c), .text+0xedae4),
.text+0xedde0), .text+0xedb9c), .text+0xeda70)
  + error: tpm_ibmvtpm.c: undefined reference to
`.vio_unregister_driver':  => .exit.text+0x1920)

powerpc-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/7732/ (all 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/7708/ (all 119 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
