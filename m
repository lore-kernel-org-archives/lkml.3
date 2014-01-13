Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbaAMIek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 03:34:40 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:42122 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaAMIeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 03:34:37 -0500
MIME-Version: 1.0
In-Reply-To: <1389601922-18094-1-git-send-email-geert@linux-m68k.org>
References: <1389601922-18094-1-git-send-email-geert@linux-m68k.org>
Date: Mon, 13 Jan 2014 09:34:37 +0100
X-Google-Sender-Auth: rxYzQmi1MIoKYNwOe26snDdvukc
Message-ID: <CAMuHMdV-uxevCYNZvKZsNqGKn8Abg4xHF2CDS--j5iTJWAy6Bg@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.13-rc8
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 9:32 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.13-rc8[1]  to v3.13-rc7[3], the summaries are:
>   - build errors: +1/-13

Just one more "relocation truncated to fit" on ppc.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
